import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_flexible/utils/dio/interceptors/Response_interceptor.dart';
import 'package:flutter_flexible/utils/dio/interceptors/error_interceptor.dart';
import '../../config/app_config.dart';
import 'interceptors/header_interceptor.dart';
import 'interceptors/log_interceptor.dart';

Dio _initDio() {
  BaseOptions baseOpts = BaseOptions(
    connectTimeout: const Duration(seconds: 30),  // 调整为30秒
    receiveTimeout: const Duration(seconds: 30),  // 新增接收超时
    baseUrl: AppConfig.host,
    responseType: ResponseType.plain,
    receiveDataWhenStatusError: true,
  );
  Dio dioClient = Dio(baseOpts);
  dioClient.interceptors.addAll([
    HeaderInterceptors(),
    ResponseInterceptor(),  // 响应拦截器
    // 记录请求日志
    LogsInterceptors(),
    ErrorInterceptor(),  // 新增的错误拦截器
  ]);

  if (AppConfig.usingProxy) {
    dioClient.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final HttpClient client = HttpClient();
        client.findProxy = (uri) {
          // 设置Http代理，请注意，代理会在你正在运行应用的设备上生效，而不是在宿主平台生效。
          return "PROXY ${AppConfig.proxyAddress}";
        };
        // https证书校验
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      },
    );
  }
  return dioClient;
}

/// 底层请求方法说明
///
/// [options] dio请求的配置参数，默认get请求
///
/// [data] 请求参数
///
/// [cancelToken] 请求取消对象
///
///```dart
///CancelToken token = CancelToken(); // 通过CancelToken来取消发起的请求
///
///safeRequest(
///  "/test",
///  data: {"id": 12, "name": "xx"},
///  options: Options(method: "POST"),
/// cancelToken: token,
///);
///
///// 取消请求
///token.cancel("cancelled");
///```
typedef FromJson<T> = T Function(dynamic json);

Future<T> safeRequest<T>(
  String url, {
  Object? data,
  Options? options,
  Map<String, dynamic>? queryParameters,
  CancelToken? cancelToken,
  int retryCount = 1,
  Duration retryDelay = const Duration(seconds: 1),
  FromJson<T>? fromJson, // 新增
}) async {
  int attempt = 0;
  while (true) {
    try {
      final response = await Request.dioClient.request(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      // 支持自定义反序列化
      if (fromJson != null) {
        return fromJson(response.data);
      }
      // 默认直接返回
      return response.data as T;
    } on DioException catch (e) {
      // 只对网络错误重试
      if (_shouldRetry(e) && attempt < retryCount) {
        attempt++;
        await Future.delayed(retryDelay * attempt); // 指数退避
        continue;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}

// 判断是否需要重试
bool _shouldRetry(DioException e) {
  return e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.connectionError;
}

class Request {
  static Dio dioClient = _initDio();

  /// get请求
  static Future<T> get<T>(
    String url, {
    Options? options,
    Map<String, dynamic>? queryParameters,
    int retryCount = 1,
    Duration retryDelay = const Duration(seconds: 1),
    FromJson<T>? fromJson,
    CancelToken? cancelToken,
  }) async {
    return safeRequest<T>(
      url,
      options: options,
      queryParameters: queryParameters,
      retryCount: retryCount,
      retryDelay: retryDelay,
      fromJson: fromJson,
      cancelToken: cancelToken,
    );
  }

  /// post请求
  static Future<T> post<T>(
    String url, {
    Options? options,
    Object? data,
    Map<String, dynamic>? queryParameters,
    int retryCount = 1,
    Duration retryDelay = const Duration(seconds: 1),
    FromJson<T>? fromJson,
    CancelToken? cancelToken,
  }) async {
    return safeRequest<T>(
      url,
      options: options?.copyWith(method: 'POST') ?? Options(method: 'POST'),
      data: data,
      queryParameters: queryParameters,
      retryCount: retryCount,
      retryDelay: retryDelay,
      fromJson: fromJson,
      cancelToken: cancelToken,
    );
  }

  /// put请求
  static Future<T> put<T>(
    String url, {
    Options? options,
    Object? data,
    Map<String, dynamic>? queryParameters,
    int retryCount = 1,
    Duration retryDelay = const Duration(seconds: 1),
    FromJson<T>? fromJson,
    CancelToken? cancelToken,
  }) async {
    return safeRequest<T>(
      url,
      options: options?.copyWith(method: 'PUT') ?? Options(method: 'PUT'),
      data: data,
      queryParameters: queryParameters,
      retryCount: retryCount,
      retryDelay: retryDelay,
      fromJson: fromJson,
      cancelToken: cancelToken,
    );
  }

  /// delete请求
  static Future<T> delete<T>(
    String url, {
    Options? options,
    Object? data,
    Map<String, dynamic>? queryParameters,
    int retryCount = 1,
    Duration retryDelay = const Duration(seconds: 1),
    FromJson<T>? fromJson,
    CancelToken? cancelToken,
  }) async {
    return safeRequest<T>(
      url,
      options: options?.copyWith(method: 'DELETE') ?? Options(method: 'DELETE'),
      data: data,
      queryParameters: queryParameters,
      retryCount: retryCount,
      retryDelay: retryDelay,
      fromJson: fromJson,
      cancelToken: cancelToken,
    );
  }

  /// options请求
  static Future<T> options<T>(
    String url, {
    Options? options,
    Object? data,
    Map<String, dynamic>? queryParameters,
    int retryCount = 1,
    Duration retryDelay = const Duration(seconds: 1),
    FromJson<T>? fromJson,
    CancelToken? cancelToken,
  }) async {
    return safeRequest<T>(
      url,
      options: options?.copyWith(method: 'OPTIONS') ?? Options(method: 'OPTIONS'),
      data: data,
      queryParameters: queryParameters,
      retryCount: retryCount,
      retryDelay: retryDelay,
      fromJson: fromJson,
      cancelToken: cancelToken,
    );
  }
}
