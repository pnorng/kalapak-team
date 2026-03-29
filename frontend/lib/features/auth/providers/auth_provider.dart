import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthService _service;

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _token;
  String? _error;

  AuthProvider(this._service) {
    _init();
  }

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get token => _token;
  String? get error => _error;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isAdmin => _user?.isAdmin ?? false;

  Future<void> _init() async {
    _status = AuthStatus.loading;
    notifyListeners();

    final saved = await _service.getSavedToken();
    if (saved != null) {
      final me = await _service.fetchMe(saved);
      if (me != null) {
        _token = saved;
        _user = me;
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    try {
      final result = await _service.login(email: email, password: password);
      _user = result.user;
      _token = result.token;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    try {
      final result = await _service.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      _user = result.user;
      _token = result.token;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    if (_token != null) await _service.logout(_token!);
    _user = null;
    _token = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<String?> updateProfile({
    String? name,
    String? avatar,
    String? currentPassword,
    String? newPassword,
    String? newPasswordConfirmation,
  }) async {
    if (_token == null) return 'Not authenticated';
    try {
      final updated = await _service.updateProfile(
        token: _token!,
        name: name,
        avatar: avatar,
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );
      _user = updated;
      notifyListeners();
      return null; // success
    } catch (e) {
      return _parseError(e);
    }
  }

  String _parseError(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        if (data.containsKey('message')) return data['message'] as String;
        if (data.containsKey('errors')) {
          final errors = data['errors'] as Map<String, dynamic>;
          return errors.values.expand((v) => v is List ? v : [v]).join('\n');
        }
      }
      return e.message ?? 'Network error. Please try again.';
    }
    if (e is Exception) return e.toString().replaceFirst('Exception: ', '');
    return 'An unexpected error occurred.';
  }
}
