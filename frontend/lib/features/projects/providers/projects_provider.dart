import 'package:flutter/foundation.dart';
import '../models/project_model.dart';
import '../services/projects_service.dart';

class ProjectsProvider extends ChangeNotifier {
  final _service = ProjectsService();

  List<ProjectModel> _projects = [];
  List<ProjectModel> _filtered = [];
  bool _isLoading = false;
  String? _error;
  String _search = '';

  List<ProjectModel> get projects => _filtered;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProjects() async {
    if (_projects.isNotEmpty && _search.isEmpty) return;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _projects = await _service.fetchProjects();
      _applyFilter();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    _search = query.toLowerCase();
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_search.isEmpty) {
      _filtered = List.from(_projects);
    } else {
      _filtered = _projects
          .where((p) =>
              p.title.toLowerCase().contains(_search) ||
              p.techStack.any((t) => t.toLowerCase().contains(_search)))
          .toList();
    }
  }
}
