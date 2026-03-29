import 'package:dio/dio.dart';
import '../../../core/constants/api_endpoints.dart';
import '../models/comment_model.dart';
import '../models/post_model.dart';

class BlogService {
  final _dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));

  Future<List<PostModel>> fetchPosts({String? category, String? search}) async {
    final queryParams = <String, dynamic>{};
    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    final res = await _dio.get(
      ApiEndpoints.posts,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    final data = res.data['data'] as List;
    return data
        .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<PostModel> fetchPost(String slug) async {
    final res = await _dio.get('${ApiEndpoints.posts}/$slug');
    return PostModel.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  Future<({bool liked, int likesCount})> likePost(int id, String token) async {
    final res = await _dio.post(
      '${ApiEndpoints.posts}/$id/like',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final d = res.data['data'] as Map<String, dynamic>;
    return (liked: d['liked'] as bool, likesCount: d['likes_count'] as int);
  }

  Future<CommentModel> addComment(int id, String content, String token) async {
    final res = await _dio.post(
      ApiEndpoints.postComment(id),
      data: {'content': content},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return CommentModel.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  Future<List<CommentModel>> fetchComments(int id) async {
    final res = await _dio.get('${ApiEndpoints.posts}/$id/comments');
    final data = res.data['data'] as List;
    return data
        .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
