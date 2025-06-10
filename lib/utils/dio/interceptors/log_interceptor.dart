import 'package:dio/dio.dart';
import '../../../config/app_config.dart';

class LogsInterceptors extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options, handler) async {
    if (AppConfig.DEBUG) {
      print('┌────────────────────── Request ──────────────────────');
      print('│ URI: ${options.method} ${options.uri}');
      print('│ Headers: ${options.headers}');
      if (options.data != null) {
        print('│ Body: ${options.data}');
      }
      print('└─────────────────────────────────────────────────────');
    }
    return handler.next(options);
  }

  @override
  onResponse(response, handler) async {
    if (AppConfig.DEBUG) {
      print('┌────────────────────── Response ──────────────────────');
      print('│ Status: ${response.statusCode}');
      print('│ Data: ${response.data}');
      print('└─────────────────────────────────────────────────────');
    }
    return handler.next(response);
  }

  // 请求失败拦截
  @override
  onError(DioException err, handler) async {
    if (AppConfig.DEBUG) {
      print('请求异常信息: ${err.error}');
    }
    return handler.next(err);
  }
}
