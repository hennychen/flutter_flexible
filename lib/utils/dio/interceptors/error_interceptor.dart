import 'package:dio/dio.dart';
import '../dio_error_util.dart';

class ErrorInterceptor extends InterceptorsWrapper {
  @override
  onError(DioException err, handler) async {
    final errorMessage = DioErrorUtil.handleError(err);
    // 添加401等状态码处理
    if (err.response?.statusCode == 401) {
      // 跳转登录页等处理
    }
    return handler.next(err);
  }
}