import 'dart:convert';

import 'package:dio/dio.dart';

class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    // 统一处理成功响应
    if (response.statusCode == 200) {
      try {
        // 解析响应数据
        final Map<String, dynamic> data = response.data is String 
            ? jsonDecode(response.data as String) 
            : response.data;
            
        // 检查公共返回格式
        if (data.containsKey('code') && data.containsKey('message')) {
          // 如果业务层返回错误码
          if (data['code'] != 0) {
            return handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                error: data['message'],
                response: response,
                type: DioExceptionType.badResponse,
              ),
            );
          }
          
          // 提取实际业务数据
          response.data = data['data'] ?? data;
        }
      } catch (e) {
        return handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            error: 'Response parse error: $e',
            response: response,
            type: DioExceptionType.unknown,
          ),
        );
      }
    }
    
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    // 统一处理错误响应
    if (err.response != null) {
      try {
        final Map<String, dynamic> data = err.response!.data is String
            ? jsonDecode(err.response!.data as String)
            : err.response!.data;
            
        if (data.containsKey('message')) {
          final newErr = DioException(
            requestOptions: err.requestOptions,
            response: err.response,
            type: err.type,
            error: data['message'],
            stackTrace: err.stackTrace,
          );
          handler.next(newErr);
          return;
        }
      } catch (_) {}
    }
    
    handler.next(err);
  }
}