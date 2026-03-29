import 'package:dio/dio.dart';
import '../../../core/constants/api_endpoints.dart';
import '../models/project_model.dart';

class ProjectsService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiEndpoints.baseUrl,
    headers: {'Accept': 'application/json'},
  ));

  Future<List<ProjectModel>> fetchProjects({String? search}) async {
    final resp = await _dio.get(
      ApiEndpoints.projects,
      queryParameters: search != null ? {'search': search} : null,
    );
    final list = resp.data['data'] as List;
    return list
        .map((e) => ProjectModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ProjectModel> fetchProject(int id) async {
    final resp = await _dio.get(ApiEndpoints.projectById(id));
    return ProjectModel.fromJson(resp.data['data'] as Map<String, dynamic>);
  }
}
