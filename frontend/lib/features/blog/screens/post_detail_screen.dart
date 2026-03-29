import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/cosmic_background.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/blog_provider.dart';

class PostDetailScreen extends StatefulWidget {
  final String slug;
  const PostDetailScreen({super.key, required this.slug});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _commentCtrl = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BlogProvider>().fetchPost(widget.slug);
    });
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Consumer<BlogProvider>(
            builder: (_, blog, __) {
              if (blog.currentPost == null) return const LoadingIndicator();
              final post = blog.currentPost!;
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    expandedHeight: post.thumbnail != null ? 200 : 0,
                    flexibleSpace: post.thumbnail != null
                        ? FlexibleSpaceBar(
                            background: CachedNetworkImage(
                              imageUrl: post.thumbnail!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : null,
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (post.category != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: kNebulaPurple.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: kNebulaPurple.withOpacity(0.4)),
                              ),
                              child: Text(post.category!,
                                  style: const TextStyle(
                                      color: kNebulaPurple, fontSize: 11)),
                            ),
                          const SizedBox(height: 10),
                          Text(post.title,
                              style: GoogleFonts.firaCode(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: kTextPrimary)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundImage: post.authorAvatar != null
                                    ? CachedNetworkImageProvider(
                                        post.authorAvatar!)
                                    : null,
                                backgroundColor: kNebulaPurple.withOpacity(0.3),
                                child: post.authorAvatar == null
                                    ? Text(
                                        (post.authorName ?? '?')[0]
                                            .toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 11, color: Colors.white),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(post.authorName ?? 'Unknown',
                                      style: GoogleFonts.nunito(
                                          fontSize: 13, color: kTextPrimary)),
                                  Text(
                                      DateFormat('MMM d, y')
                                          .format(post.createdAt),
                                      style: GoogleFonts.nunito(
                                          fontSize: 11, color: kTextMuted)),
                                ],
                              ),
                              const Spacer(),
                              _LikeButton(post: post),
                            ],
                          ),
                          const SizedBox(height: 20),
                          if (post.content != null)
                            MarkdownBody(
                              data: post.content!,
                              styleSheet: MarkdownStyleSheet(
                                p: GoogleFonts.nunito(
                                    fontSize: 15,
                                    color: kTextSecondary,
                                    height: 1.7),
                                h1: GoogleFonts.firaCode(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: kTextPrimary),
                                h2: GoogleFonts.firaCode(
                                    fontSize: 18, color: kTextPrimary),
                                h3: GoogleFonts.firaCode(
                                    fontSize: 16, color: kCyberBlue),
                                code: GoogleFonts.firaCode(
                                    fontSize: 13, color: kSuccessGreen),
                                codeblockDecoration: BoxDecoration(
                                  color: kSurface,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          if (post.thumbnail != null ||
                              post.images.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            Text('Images',
                                style: GoogleFonts.firaCode(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: kCyberBlue)),
                            const SizedBox(height: 10),
                            Builder(builder: (_) {
                              final allImages = [
                                if (post.thumbnail != null &&
                                    post.thumbnail!.isNotEmpty)
                                  post.thumbnail!,
                                ...post.images,
                              ];
                              return SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: allImages.length,
                                  itemBuilder: (_, i) => Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: CachedNetworkImage(
                                        imageUrl: allImages[i],
                                        width: 260,
                                        height: 200,
                                        fit: BoxFit.cover,
                                        placeholder: (_, __) => Container(
                                          width: 260,
                                          color: kSurface,
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                                color: kNebulaPurple,
                                                strokeWidth: 2),
                                          ),
                                        ),
                                        errorWidget: (_, __, ___) => Container(
                                          width: 260,
                                          color: kSurface,
                                          child: const Icon(Icons.broken_image,
                                              color: kTextMuted),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                          const SizedBox(height: 30),
                          _buildCommentsSection(blog, post.id),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCommentsSection(BlogProvider blog, int postId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Comments (${blog.comments.length})',
            style: GoogleFonts.firaCode(
                fontSize: 16, fontWeight: FontWeight.bold, color: kCyberBlue)),
        const SizedBox(height: 12),
        Consumer<AuthProvider>(
          builder: (_, auth, __) {
            if (auth.status == AuthStatus.authenticated) {
              return GlassCard(
                child: Column(
                  children: [
                    TextField(
                      controller: _commentCtrl,
                      style: const TextStyle(color: kTextPrimary),
                      decoration: const InputDecoration(
                          hintText: 'Write a comment…',
                          border: InputBorder.none),
                      maxLines: 3,
                      minLines: 1,
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GradientButton(
                        label: _isSubmitting ? 'Sending…' : 'Post',
                        icon: Icons.send_rounded,
                        onPressed: _isSubmitting
                            ? null
                            : () => _submitComment(blog, postId, auth.token!),
                      ),
                    ),
                  ],
                ),
              );
            }
            return GlassCard(
              child: Text('Log in to leave a comment.',
                  style:
                      GoogleFonts.nunito(color: kTextSecondary, fontSize: 14)),
            );
          },
        ),
        const SizedBox(height: 16),
        ...blog.comments.map(
          (c) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GlassCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: c.userAvatar != null
                        ? CachedNetworkImageProvider(c.userAvatar!)
                        : null,
                    backgroundColor: kNebulaPurple.withOpacity(0.3),
                    child: c.userAvatar == null
                        ? Text(c.userName[0].toUpperCase(),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white))
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(c.userName,
                                style: GoogleFonts.firaCode(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: kTextPrimary)),
                            const Spacer(),
                            Text(DateFormat('MMM d').format(c.createdAt),
                                style: GoogleFonts.nunito(
                                    fontSize: 11, color: kTextMuted)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(c.content,
                            style: GoogleFonts.nunito(
                                fontSize: 13, color: kTextSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submitComment(
      BlogProvider blog, int postId, String token) async {
    final text = _commentCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() => _isSubmitting = true);
    await blog.addComment(postId, text, token);
    _commentCtrl.clear();
    if (mounted) setState(() => _isSubmitting = false);
  }
}

class _LikeButton extends StatelessWidget {
  final dynamic post;
  const _LikeButton({required this.post});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (_, auth, __) {
        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: auth.status == AuthStatus.authenticated
              ? () =>
                  context.read<BlogProvider>().likePost(post.id, auth.token!)
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: kNebulaPurple.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kNebulaPurple.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.favorite, size: 14, color: kNebulaPurple),
                const SizedBox(width: 4),
                Text('${post.likesCount}',
                    style: const TextStyle(color: kNebulaPurple, fontSize: 12)),
              ],
            ),
          ),
        );
      },
    );
  }
}
