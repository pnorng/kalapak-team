class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://kalapak-api.onrender.com/api',
  );

  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';
  static const String updateProfile = '/auth/profile';

  // Posts
  static const String posts = '/posts';
  static String postBySlug(String slug) => '/posts/$slug';
  static String postLike(int id) => '/posts/$id/like';
  static String postComment(int id) => '/posts/$id/comment';
  static String postComments(int id) => '/posts/$id/comments';

  // Projects
  static const String projects = '/projects';
  static String projectById(int id) => '/projects/$id';

  // Skills
  static const String skills = '/skills';
  static String skillById(int id) => '/skills/$id';

  // Contact
  static const String contact = '/contact';

  // Team
  static const String team = '/team';
}
