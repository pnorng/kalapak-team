import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../models/member_model.dart';

class MemberCard extends StatelessWidget {
  final MemberModel member;
  const MemberCard({super.key, required this.member});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundImage: member.avatar != null
                ? CachedNetworkImageProvider(member.avatar!)
                : null,
            backgroundColor: kNebulaPurple.withOpacity(0.3),
            child: member.avatar == null
                ? Text(member.name[0].toUpperCase(),
                    style: const TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.bold))
                : null,
          ),
          const SizedBox(height: 12),
          Text(member.name,
              style: GoogleFonts.firaCode(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: kTextPrimary)),
          const SizedBox(height: 4),
          ShaderMask(
            shaderCallback: (b) => kButtonGradient.createShader(b),
            child: Text(member.role,
                style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ),
          if (member.bio != null) ...[
            const SizedBox(height: 8),
            Text(member.bio!,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                    fontSize: 12, color: kTextSecondary, height: 1.5)),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (member.githubUrl != null)
                _SocialBtn(
                    icon: Icons.code,
                    color: kTextPrimary,
                    onTap: () => _launch(member.githubUrl!)),
              if (member.linkedinUrl != null)
                _SocialBtn(
                    icon: Icons.business_center_outlined,
                    color: kCyberBlue,
                    onTap: () => _launch(member.linkedinUrl!)),
              if (member.email != null)
                _SocialBtn(
                    icon: Icons.email_outlined,
                    color: kNebulaPurple,
                    onTap: () => _launch('mailto:${member.email}')),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _SocialBtn(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.4)),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
      ),
    );
  }
}
