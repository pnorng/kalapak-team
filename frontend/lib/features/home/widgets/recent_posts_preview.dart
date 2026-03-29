import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../blog/providers/blog_provider.dart';

class RecentPostsPreview extends StatelessWidget {
  const RecentPostsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final blog = context.watch<BlogProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: SectionHeader(title: 'Latest Posts'),
            ),
            TextButton(
              onPressed: () => context.go('/blog'),
              child: const Text(
                'See all →',
                style: TextStyle(color: kCyberBlue, fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (blog.isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(kNebulaPurple),
              ),
            ),
          )
        else if (blog.posts.isEmpty)
          const Center(
            child: Text(
              'No posts yet.',
              style: TextStyle(color: kTextMuted),
            ),
          )
        else
          ...blog.posts.take(3).map((post) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassCard(
                  onTap: () => context.push('/blog/${post.slug}'),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      if (post.thumbnail != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: post.thumbnail!,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Container(
                              width: 64,
                              height: 64,
                              color: kSurfaceLight,
                              child: const Icon(Icons.image, color: kTextMuted),
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: kSurfaceLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:
                              const Icon(Icons.article, color: kNebulaPurple),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (post.category != null)
                              Text(
                                post.category!,
                                style: GoogleFonts.spaceMono(
                                  fontSize: 10,
                                  color: kCyberBlue,
                                ),
                              ),
                            Text(
                              post.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: kTextPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              post.authorName ?? 'Kalapak Team',
                              style: GoogleFonts.nunito(
                                fontSize: 11,
                                color: kTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
      ],
    );
  }
}
