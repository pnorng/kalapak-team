import 'package:dio/dio.dart';
import '../../../core/constants/api_endpoints.dart';
import '../models/contact_message_model.dart';
import '../../blog/models/post_model.dart';
import '../../projects/models/project_model.dart';
import '../../skills/models/skill_model.dart';

class AdminService {
  final Dio _dio;

  AdminService()
      : _dio = Dio(BaseOptions(
          baseUrl: ApiEndpoints.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {'Accept': 'application/json'},
        ));

  Options _authHeaders(String token) =>
      Options(headers: {'Authorization': 'Bearer $token'});

  // ── Contact Messages ──────────────────────────────────────────────
  Future<List<ContactMessageModel>> fetchMessages(String token) async {
    final resp = await _dio.get(
      ApiEndpoints.contact,
      options: _authHeaders(token),
    );
    final data = resp.data;
    final List items =
        data is Map ? (data['data'] as List? ?? []) : (data as List);
    return items
        .map((j) => ContactMessageModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<void> markMessageRead(int id, String token) async {
    await _dio.patch(
      '${ApiEndpoints.contact}/$id/read',
      options: _authHeaders(token),
    );
  }

  // ── Posts CRUD ────────────────────────────────────────────────────
  Future<List<PostModel>> fetchPosts(String token) async {
    final resp = await _dio.get(
      ApiEndpoints.posts,
      options: _authHeaders(token),
    );
    final data = resp.data;
    final List items =
        data is Map ? (data['data'] as List? ?? []) : (data as List);
    return items
        .map((j) => PostModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<void> createPost(Map<String, dynamic> data, String token) async {
    await _dio.post(
      ApiEndpoints.posts,
      data: data,
      options: _authHeaders(token),
    );
  }

  Future<void> updatePost(int id, Map<String, dynamic> data, String token) async {
    await _dio.put(
      '${ApiEndpoints.posts}/$id',
      data: data,
      options: _authHeaders(token),
    );
  }

  Future<void> deletePost(int id, String token) async {
    await _dio.delete(
      '${ApiEndpoints.posts}/$id',
      options: _authHeaders(token),
    );
  }

  // ── Projects CRUD ─────────────────────────────────────────────────
  Future<List<ProjectModel>> fetchProjects(String token) async {
    final resp = await _dio.get(
      ApiEndpoints.projects,
      options: _authHeaders(token),
    );
    final data = resp.data;
    final List items =
        data is Map ? (data['data'] as List? ?? []) : (data as List);
    return items
        .map((j) => ProjectModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<void> createProject(Map<String, dynamic> data, String token) async {
    await _dio.post(
      ApiEndpoints.projects,
      data: data,
      options: _authHeaders(token),
    );
  }

  Future<void> updateProject(int id, Map<String, dynamic> data, String token) async {
    await _dio.put(
      '${ApiEndpoints.projects}/$id',
      data: data,
      options: _authHeaders(token),
    );
  }

  Future<void> deleteProject(int id, String token) async {
    await _dio.delete(
      '${ApiEndpoints.projects}/$id',
      options: _authHeaders(token),
    );
  }

  // ── Skills CRUD ───────────────────────────────────────────────────
  Future<List<SkillModel>> fetchSkills(String token) async {
    final resp = await _dio.get(
      ApiEndpoints.skills,
      options: _authHeaders(token),
    );
    final data = resp.data['data'] as Map<String, dynamic>;
    final List<SkillModel> all = [];
    for (final list in data.values) {
      for (final item in (list as List)) {
        all.add(SkillModel.fromJson(item as Map<String, dynamic>));
      }
    }
    return all;
  }

  Future<void> createSkill(Map<String, dynamic> data, String token) async {
    await _dio.post(
      ApiEndpoints.skills,
      data: data,
      options: _authHeaders(token),
    );
  }

  Future<void> updateSkill(int id, Map<String, dynamic> data, String token) async {
    await _dio.put(
      '${ApiEndpoints.skills}/$id',
      data: data,
      options: _authHeaders(token),
    );
  }

  Future<void> deleteSkill(int id, String token) async {
    await _dio.delete(
      '${ApiEndpoints.skills}/$id',
      options: _authHeaders(token),
    );
  }
}
