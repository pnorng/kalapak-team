import 'package:flutter/foundation.dart';
import '../models/comment_model.dart';
import '../models/post_model.dart';
import '../services/blog_service.dart';

enum BlogStatus { initial, loading, loaded, error }

class BlogProvider extends ChangeNotifier {
  final _service = BlogService();

  BlogStatus _status = BlogStatus.initial;
  List<PostModel> _posts = [];
  PostModel? _currentPost;
  List<CommentModel> _comments = [];
  String _searchQuery = '';
  String _selectedCategory = '';
  String _error = '';

  BlogStatus get status => _status;
  bool get isLoading => _status == BlogStatus.loading;
  List<PostModel> get posts => _posts;
  PostModel? get currentPost => _currentPost;
  List<CommentModel> get comments => _comments;
  String get selectedCategory => _selectedCategory;
  String get error => _error;

  Future<void> fetchPosts() async {
    _status = BlogStatus.loading;
    notifyListeners();
    try {
      _posts = await _service.fetchPosts(
        category: _selectedCategory.isNotEmpty ? _selectedCategory : null,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );
      _status = BlogStatus.loaded;
    } catch (e) {
      _error = e.toString();
      _status = BlogStatus.error;
    }
    notifyListeners();
  }

  Future<void> fetchPost(String slug) async {
    _currentPost = null;
    _comments = [];
    notifyListeners();
    try {
      _currentPost = await _service.fetchPost(slug);
      notifyListeners();
      _comments = await _service.fetchComments(_currentPost!.id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void search(String query) {
    _searchQuery = query;
    fetchPosts();
  }

  void filterCategory(String category) {
    _selectedCategory = category;
    fetchPosts();
  }

  Future<void> likePost(int id, String token) async {
    final result = await _service.likePost(id, token);
    final idx = _posts.indexWhere((p) => p.id == id);
    if (idx != -1) {
      _posts[idx] = PostModel(
        id: _posts[idx].id,
        title: _posts[idx].title,
        slug: _posts[idx].slug,
        content: _posts[idx].content,
        thumbnail: _posts[idx].thumbnail,
        category: _posts[idx].category,
        authorId: _posts[idx].authorId,
        authorName: _posts[idx].authorName,
        authorAvatar: _posts[idx].authorAvatar,
        isPublished: _posts[idx].isPublished,
        likesCount: result.likesCount,
        commentsCount: _posts[idx].commentsCount,
        createdAt: _posts[idx].createdAt,
      );
      notifyListeners();
    }
    if (_currentPost?.id == id) {
      _currentPost = PostModel(
        id: _currentPost!.id,
        title: _currentPost!.title,
        slug: _currentPost!.slug,
        content: _currentPost!.content,
        thumbnail: _currentPost!.thumbnail,
        category: _currentPost!.category,
        authorId: _currentPost!.authorId,
        authorName: _currentPost!.authorName,
        authorAvatar: _currentPost!.authorAvatar,
        isPublished: _currentPost!.isPublished,
        likesCount: result.likesCount,
        commentsCount: _currentPost!.commentsCount,
        createdAt: _currentPost!.createdAt,
      );
      notifyListeners();
    }
  }

  Future<void> addComment(int postId, String content, String token) async {
    final comment = await _service.addComment(postId, content, token);
    _comments = [..._comments, comment];
    notifyListeners();
  }
}
