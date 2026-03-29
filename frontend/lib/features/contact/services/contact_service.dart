import 'package:dio/dio.dart';
import '../../../core/constants/api_endpoints.dart';

class ContactService {
  final _dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));

  Future<void> sendMessage({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    await _dio.post(ApiEndpoints.contact, data: {
      'name': name,
      'email': email,
      'subject': subject,
      'message': message,
    });
  }
}
