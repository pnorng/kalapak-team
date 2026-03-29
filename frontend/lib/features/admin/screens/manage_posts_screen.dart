import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/colors.dart';
import '../../../core/widgets/cosmic_background.dart';
import '../../../core/widgets/glass_card.dart';
import '../../auth/providers/auth_provider.dart';
import '../../blog/models/post_model.dart';
import '../services/admin_service.dart';
import '../widgets/admin_form_fields.dart';

class ManagePostsScreen extends StatefulWidget {
  const ManagePostsScreen({super.key});

  @override
  State<ManagePostsScreen> createState() => _ManagePostsScreenState();
}

class _ManagePostsScreenState extends State<ManagePostsScreen> {
  final AdminService _service = AdminService();
  List<PostModel> _posts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final token = context.read<AuthProvider>().token;
    if (token == null) return;
    setState(() => _loading = true);
    try {
      _posts = await _service.fetchPosts(token);
    } catch (_) {}
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: kCyberBlue),
                  onPressed: () => context.pop(),
                ),
                title: Text('Manage Posts',
                    style: GoogleFonts.firaCode(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kStarWhite)),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: kSuccessGreen),
                    onPressed: () => _showPostForm(context),
                    tooltip: 'Create Post',
                  ),
                ],
              ),
              if (_loading)
                const SliverFillRemaining(
                  child: Center(
                      child: CircularProgressIndicator(color: kNebulaPurple)),
                )
              else if (_posts.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Text('No posts yet',
                        style: GoogleFonts.nunito(color: kTextMuted)),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildPostCard(_posts[i])
                            .animate()
                            .fadeIn(delay: (60 * i).ms),
                      ),
                      childCount: _posts.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostCard(PostModel post) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(post.title,
                    style: GoogleFonts.firaCode(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: kTextPrimary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ),
              _actionButtons(
                onEdit: () => _showPostForm(context, post: post),
                onDelete: () => _confirmDelete(post),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _chip(post.category ?? 'Uncategorized', kVioletAccent),
              const SizedBox(width: 8),
              _chip(post.isPublished ? 'Published' : 'Draft',
                  post.isPublished ? kSuccessGreen : kTextMuted),
              const Spacer(),
              const Icon(Icons.favorite, size: 14, color: kTextMuted),
              const SizedBox(width: 3),
              Text('${post.likesCount}',
                  style: GoogleFonts.nunito(fontSize: 11, color: kTextMuted)),
              const SizedBox(width: 8),
              const Icon(Icons.comment, size: 14, color: kTextMuted),
              const SizedBox(width: 3),
              Text('${post.commentsCount}',
                  style: GoogleFonts.nunito(fontSize: 11, color: kTextMuted)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text,
          style: GoogleFonts.nunito(
              fontSize: 10, color: color, fontWeight: FontWeight.w600)),
    );
  }

  Widget _actionButtons(
      {required VoidCallback onEdit, required VoidCallback onDelete}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, size: 18, color: kCyberBlue),
          onPressed: onEdit,
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.all(6),
        ),
        IconButton(
          icon: const Icon(Icons.delete, size: 18, color: Colors.redAccent),
          onPressed: onDelete,
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.all(6),
        ),
      ],
    );
  }

  void _confirmDelete(PostModel post) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Post',
            style: GoogleFonts.firaCode(color: kTextPrimary)),
        content: Text('Delete "${post.title}"?',
            style: GoogleFonts.nunito(color: kTextSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.nunito(color: kTextMuted)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final token = context.read<AuthProvider>().token;
              if (token == null) return;
              try {
                await _service.deletePost(post.id, token);
                _load();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Post deleted')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to delete')),
                  );
                }
              }
            },
            child: Text('Delete',
                style: GoogleFonts.nunito(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void _showPostForm(BuildContext context, {PostModel? post}) {
    final titleC = TextEditingController(text: post?.title ?? '');
    final contentC = TextEditingController(text: post?.content ?? '');
    final categoryC = TextEditingController(text: post?.category ?? '');
    bool isPublished = post?.isPublished ?? true;

    // Merge thumbnail + images into one list; first entry = cover/thumbnail
    final allImageUrls = [
      if (post?.thumbnail != null && post!.thumbnail!.isNotEmpty)
        post.thumbnail!,
      ...?post?.images,
    ];
    final List<TextEditingController> imageControllers =
        allImageUrls.map((url) => TextEditingController(text: url)).toList();
    if (imageControllers.isEmpty) {
      imageControllers.add(TextEditingController());
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post == null ? 'Create Post' : 'Edit Post',
                  style: GoogleFonts.firaCode(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kTextPrimary),
                ),
                const SizedBox(height: 16),
                AdminFormField(controller: titleC, label: 'Title *'),
                AdminFormField(
                    controller: contentC, label: 'Content *', maxLines: 5),
                AdminFormField(controller: categoryC, label: 'Category'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('Images',
                        style: GoogleFonts.firaCode(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: kTextSecondary)),
                    const SizedBox(width: 6),
                    Text('(first = cover thumbnail)',
                        style: GoogleFonts.nunito(
                            fontSize: 10, color: kTextMuted)),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        setModalState(() {
                          imageControllers.add(TextEditingController());
                        });
                      },
                      icon: const Icon(Icons.add, size: 16, color: kCyberBlue),
                      label: Text('Add',
                          style: GoogleFonts.nunito(
                              fontSize: 12, color: kCyberBlue)),
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ...imageControllers.asMap().entries.map((entry) {
                  final i = entry.key;
                  final ctrl = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: AdminFormField(
                            controller: ctrl,
                            label: i == 0
                                ? 'Image 1 (Cover / Thumbnail)'
                                : 'Image ${i + 1}',
                          ),
                        ),
                        if (imageControllers.length > 1)
                          IconButton(
                            icon: const Icon(Icons.remove_circle,
                                size: 20, color: Colors.redAccent),
                            onPressed: () {
                              setModalState(() {
                                imageControllers.removeAt(i);
                              });
                            },
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.only(left: 6),
                          ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 4),
                AdminSwitchField(
                  label: 'Published',
                  value: isPublished,
                  onChanged: (v) => setModalState(() => isPublished = v),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final allUrls = imageControllers
                          .map((c) => c.text.trim())
                          .where((u) => u.isNotEmpty)
                          .toList();
                      _savePost(
                        ctx,
                        post: post,
                        title: titleC.text.trim(),
                        content: contentC.text.trim(),
                        thumbnail: allUrls.isNotEmpty ? allUrls.first : '',
                        category: categoryC.text.trim(),
                        isPublished: isPublished,
                        images: allUrls.length > 1 ? allUrls.sublist(1) : [],
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kNebulaPurple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      post == null ? 'Create' : 'Update',
                      style: GoogleFonts.firaCode(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _savePost(
    BuildContext ctx, {
    PostModel? post,
    required String title,
    required String content,
    required String thumbnail,
    required String category,
    required bool isPublished,
    List<String> images = const [],
  }) async {
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Title and content are required')));
      return;
    }

    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    final data = <String, dynamic>{
      'title': title,
      'content': content,
      'is_published': isPublished,
    };
    if (thumbnail.isNotEmpty) data['thumbnail'] = thumbnail;
    if (category.isNotEmpty) data['category'] = category;
    if (images.isNotEmpty) data['images'] = images;

    try {
      if (post == null) {
        await _service.createPost(data, token);
      } else {
        await _service.updatePost(post.id, data, token);
      }
      if (ctx.mounted) Navigator.pop(ctx);
      _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(post == null ? 'Post created' : 'Post updated')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
