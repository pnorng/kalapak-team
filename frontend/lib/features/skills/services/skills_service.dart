import 'package:dio/dio.dart';
import '../../../core/constants/api_endpoints.dart';
import '../models/skill_model.dart';

class SkillsService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiEndpoints.baseUrl,
    headers: {'Accept': 'application/json'},
  ));

  Future<Map<String, List<SkillModel>>> fetchSkills() async {
    final resp = await _dio.get(ApiEndpoints.skills);
    final data = resp.data['data'] as Map<String, dynamic>;
    return data.map(
      (category, rawList) => MapEntry(
        category,
        (rawList as List)
            .map((e) => SkillModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
    );
  }
}
