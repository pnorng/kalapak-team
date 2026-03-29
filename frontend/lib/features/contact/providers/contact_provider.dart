import 'package:flutter/foundation.dart';
import '../services/contact_service.dart';

enum ContactStatus { idle, loading, success, error }

class ContactProvider extends ChangeNotifier {
  final _service = ContactService();

  ContactStatus _status = ContactStatus.idle;
  String _error = '';

  ContactStatus get status => _status;
  String get error => _error;

  Future<void> send({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    _status = ContactStatus.loading;
    _error = '';
    notifyListeners();
    try {
      await _service.sendMessage(
          name: name, email: email, subject: subject, message: message);
      _status = ContactStatus.success;
    } catch (e) {
      _error = e.toString();
      _status = ContactStatus.error;
    }
    notifyListeners();
  }

  void reset() {
    _status = ContactStatus.idle;
    _error = '';
    notifyListeners();
  }
}
