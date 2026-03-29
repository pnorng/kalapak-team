import 'package:flutter/foundation.dart';
import '../models/contact_message_model.dart';
import '../services/admin_service.dart';

class AdminProvider extends ChangeNotifier {
  final AdminService _service = AdminService();

  List<ContactMessageModel> _messages = [];
  bool _isLoading = false;
  String? _error;

  List<ContactMessageModel> get messages => _messages;
  List<ContactMessageModel> get unreadMessages =>
      _messages.where((m) => !m.isRead).toList();
  int get unreadCount => _messages.where((m) => !m.isRead).length;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchMessages(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _messages = await _service.fetchMessages(token);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markRead(int id, String token) async {
    try {
      await _service.markMessageRead(id, token);
      final idx = _messages.indexWhere((m) => m.id == id);
      if (idx != -1) {
        _messages = List.from(_messages);
        _messages[idx] = ContactMessageModel(
          id: _messages[idx].id,
          name: _messages[idx].name,
          email: _messages[idx].email,
          subject: _messages[idx].subject,
          message: _messages[idx].message,
          isRead: true,
          createdAt: _messages[idx].createdAt,
        );
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> deletePost(int id, String token) async {
    try {
      await _service.deletePost(id, token);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProject(int id, String token) async {
    try {
      await _service.deleteProject(id, token);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteSkill(int id, String token) async {
    try {
      await _service.deleteSkill(id, token);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
