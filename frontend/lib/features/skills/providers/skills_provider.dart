import 'package:flutter/foundation.dart';
import '../models/skill_model.dart';
import '../services/skills_service.dart';

class SkillsProvider extends ChangeNotifier {
  final _service = SkillsService();

  Map<String, List<SkillModel>> _groupedSkills = {};
  bool _isLoading = false;
  String? _error;

  Map<String, List<SkillModel>> get groupedSkills => _groupedSkills;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchSkills() async {
    if (_groupedSkills.isNotEmpty) return; // cached
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _groupedSkills = await _service.fetchSkills();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
