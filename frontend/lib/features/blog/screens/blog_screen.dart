import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/cosmic_background.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../models/post_model.dart';
import '../providers/blog_provider.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  final _searchCtrl = TextEditingController();
  final _categories = [
    'All',
    'Flutter',
    'Laravel',
    'DevOps',
    'Tutorial',
    'News'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BlogProvider>().fetchPosts();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildCategories(),
              Expanded(child: _buildPostList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          ShaderMask(
            shaderCallback: (b) => kButtonGradient.createShader(b),
            child: Text('Blog',
                style: GoogleFonts.firaCode(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          const Spacer(),
          const Icon(Icons.rss_feed_rounded, color: kCyberBlue, size: 22),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextField(
        controller: _searchCtrl,
        style: const TextStyle(color: kTextPrimary),
        decoration: InputDecoration(
          hintText: 'Search posts…',
          prefixIcon: const Icon(Icons.search, color: kTextMuted),
          suffixIcon: _searchCtrl.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: kTextMuted),
                  onPressed: () {
                    _searchCtrl.clear();
                    context.read<BlogProvider>().search('');
                  },
                )
              : null,
        ),
        onChanged: (v) {
          setState(() {});
          context.read<BlogProvider>().search(v);
        },
      ),
    );
  }

  Widget _buildCategories() {
    return Consumer<BlogProvider>(
      builder: (_, provider, __) => SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: _categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final cat = _categories[i];
            final isSelected = (i == 0 && provider.selectedCategory.isEmpty) ||
                provider.selectedCategory == cat;
            return GestureDetector(
              onTap: () => provider.filterCategory(i == 0 ? '' : cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  gradient: isSelected ? kButtonGradient : null,
                  color: isSelected ? null : kSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: isSelected ? Colors.transparent : kBorderColor),
                ),
                child: Text(cat,
                    style: TextStyle(
                      color: isSelected ? Colors.white : kTextSecondary,
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    )),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPostList() {
    return Consumer<BlogProvider>(
      builder: (_, provider, __) {
        if (provider.status == BlogStatus.loading) {
          return const LoadingIndicator();
        }
        if (provider.status == BlogStatus.error) {
          return ErrorView(
              message: provider.error, onRetry: provider.fetchPosts);
        }
        if (provider.posts.isEmpty) {
          return Center(
            child: Text('No posts found',
                style: GoogleFonts.nunito(color: kTextSecondary, fontSize: 15)),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: provider.posts.length,
          itemBuilder: (_, i) => _PostCard(post: provider.posts[i])
              .animate()
              .fadeIn(delay: (i * 60).ms),
        );
      },
    );
  }
}

class _PostCard extends StatelessWidget {
  final PostModel post;
  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/blog/${post.slug}'),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (post.thumbnail != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: post.thumbnail!,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              if (post.thumbnail != null) const SizedBox(height: 12),
              if (post.category != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: kNebulaPurple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kNebulaPurple.withOpacity(0.4)),
                  ),
                  child: Text(post.category!,
                      style:
                          const TextStyle(color: kNebulaPurple, fontSize: 11)),
                ),
              const SizedBox(height: 8),
              Text(post.title,
                  style: GoogleFonts.firaCode(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kTextPrimary)),
              const SizedBox(height: 8),
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundImage: post.authorAvatar != null
                        ? CachedNetworkImageProvider(post.authorAvatar!)
                        : null,
                    backgroundColor: kNebulaPurple.withOpacity(0.3),
                    child: post.authorAvatar == null
                        ? Text(
                            (post.authorName ?? '?')[0].toUpperCase(),
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white),
                          )
                        : null,
                  ),
                  const SizedBox(width: 6),
                  Text(post.authorName ?? 'Unknown',
                      style: GoogleFonts.nunito(
                          fontSize: 12, color: kTextSecondary)),
                  const Spacer(),
                  Text(DateFormat('MMM d, y').format(post.createdAt),
                      style:
                          GoogleFonts.nunito(fontSize: 12, color: kTextMuted)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.favorite_outline,
                      size: 14, color: kNebulaPurple),
                  const SizedBox(width: 4),
                  Text('${post.likesCount}',
                      style:
                          const TextStyle(fontSize: 12, color: kTextSecondary)),
                  const SizedBox(width: 14),
                  const Icon(Icons.comment_outlined,
                      size: 14, color: kCyberBlue),
                  const SizedBox(width: 4),
                  Text('${post.commentsCount}',
                      style:
                          const TextStyle(fontSize: 12, color: kTextSecondary)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
