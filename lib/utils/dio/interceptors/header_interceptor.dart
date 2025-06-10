import 'package:dio/dio.dart';
import 'package:flutter_flexible/config/app_config.dart';

/*
 * header拦截器
 */
class HeaderInterceptors extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options, handler) async {
    options.baseUrl = AppConfig.host;
    // 设置默认 headers
    options.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'Cache-Control': 'no-cache',
    });

    // 设置 JWT Token（如果有）
    if (AppConfig.jwtToken != null && AppConfig.jwtToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer ${AppConfig.jwtToken}';
    }

    // 如果外部通过 extra 传递了 customHeaders，则合并覆盖默认 headers
    if (options.extra.containsKey('customHeaders')) {
      final customHeaders = options.extra['customHeaders'] as Map<String, dynamic>;
      options.headers.addAll(customHeaders);
    }
    return handler.next(options);
  }

  // 响应拦截
  @override
  onResponse(response, handler) {
    // Do something with response data
    return handler.next(response); // continue
  }

  // 请求失败拦截
  @override
  onError(err, handler) async {
    return handler.next(err); //continue
  }
}
