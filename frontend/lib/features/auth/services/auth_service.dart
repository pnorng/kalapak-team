import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/constants/api_endpoints.dart';
import '../models/user_model.dart';

class AuthService {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  static const _tokenKey = 'auth_token';

  AuthService()
      : _dio = Dio(BaseOptions(
          baseUrl: ApiEndpoints.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {'Accept': 'application/json'},
        )),
        _storage = const FlutterSecureStorage();

  Future<String?> getSavedToken() => _storage.read(key: _tokenKey);

  Future<void> _saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  Future<void> _clearToken() => _storage.delete(key: _tokenKey);

  Future<({UserModel user, String token})> login({
    required String email,
    required String password,
  }) async {
    final resp = await _dio.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    final token = resp.data['token'] as String;
    await _saveToken(token);
    return (
      user: UserModel.fromJson(resp.data['user'] as Map<String, dynamic>),
      token: token,
    );
  }

  Future<({UserModel user, String token})> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final resp = await _dio.post(
      ApiEndpoints.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
    final token = resp.data['token'] as String;
    await _saveToken(token);
    return (
      user: UserModel.fromJson(resp.data['user'] as Map<String, dynamic>),
      token: token,
    );
  }

  Future<UserModel?> fetchMe(String token) async {
    try {
      final resp = await _dio.get(
        ApiEndpoints.me,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return UserModel.fromJson(resp.data['user'] as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> logout(String token) async {
    try {
      await _dio.post(
        ApiEndpoints.logout,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } finally {
      await _clearToken();
    }
  }

  Future<UserModel> updateProfile({
    required String token,
    String? name,
    String? avatar,
    String? currentPassword,
    String? newPassword,
    String? newPasswordConfirmation,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (avatar != null) data['avatar'] = avatar.isEmpty ? null : avatar;
    if (newPassword != null && newPassword.isNotEmpty) {
      data['current_password'] = currentPassword;
      data['password'] = newPassword;
      data['password_confirmation'] = newPasswordConfirmation;
    }
    final resp = await _dio.put(
      ApiEndpoints.updateProfile,
      data: data,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return UserModel.fromJson(resp.data['user'] as Map<String, dynamic>);
  }
}
