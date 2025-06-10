import '../utils/dio/request.dart' show Request;
import '../models/EchoResponse.dart'; // 假设您将在这里定义响应模型

class ApiService {
  static Future<EchoResponse?> getEcho() async {
    try {
      final response = await Request.get(
        '/get?q1=v1',
      ); 
      // 实际项目中，您可能会希望将 response 转换为一个强类型的 Dart 对象
      // 例如，使用 fromJson 构造函数
      return EchoResponse.fromJson(response!);
    } catch (e) {
      // 处理错误，例如记录日志或向用户显示消息
      print('Error fetching echo data: $e');
      return null;
    }
  }
}

