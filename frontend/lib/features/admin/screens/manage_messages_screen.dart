import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/colors.dart';
import '../../../core/widgets/cosmic_background.dart';
import '../../../core/widgets/glass_card.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/contact_message_model.dart';
import '../services/admin_service.dart';

class ManageMessagesScreen extends StatefulWidget {
  const ManageMessagesScreen({super.key});

  @override
  State<ManageMessagesScreen> createState() => _ManageMessagesScreenState();
}

class _ManageMessagesScreenState extends State<ManageMessagesScreen> {
  final AdminService _service = AdminService();
  List<ContactMessageModel> _messages = [];
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
      _messages = await _service.fetchMessages(token);
    } catch (_) {}
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final unread = _messages.where((m) => !m.isRead).length;

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
                title: Text('Messages${unread > 0 ? ' ($unread new)' : ''}',
                    style: GoogleFonts.firaCode(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kStarWhite)),
              ),
              if (_loading)
                const SliverFillRemaining(
                  child: Center(
                      child: CircularProgressIndicator(color: kNebulaPurple)),
                )
              else if (_messages.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Text('No messages yet',
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
                        child: _buildCard(_messages[i])
                            .animate()
                            .fadeIn(delay: (60 * i).ms),
                      ),
                      childCount: _messages.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(ContactMessageModel msg) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (!msg.isRead)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: const BoxDecoration(
                    color: kCyberBlue,
                    shape: BoxShape.circle,
                  ),
                ),
              Expanded(
                child: Text(msg.subject,
                    style: GoogleFonts.firaCode(
                      fontSize: 13,
                      fontWeight:
                          msg.isRead ? FontWeight.w400 : FontWeight.w700,
                      color: kTextPrimary,
                    )),
              ),
              Text(
                msg.createdAt != null ? DateFormat('MMM d').format(msg.createdAt!) : '',
                style: GoogleFonts.nunito(fontSize: 11, color: kTextMuted),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('${msg.name} <${msg.email}>',
              style: GoogleFonts.nunito(fontSize: 12, color: kTextSecondary)),
          const SizedBox(height: 8),
          Text(msg.message,
              style: GoogleFonts.nunito(fontSize: 12, color: kTextSecondary),
              maxLines: 4,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!msg.isRead)
                TextButton.icon(
                  onPressed: () => _markRead(msg),
                  icon: const Icon(Icons.mark_email_read,
                      size: 16, color: kSuccessGreen),
                  label: Text('Mark read',
                      style: GoogleFonts.nunito(
                          fontSize: 12, color: kSuccessGreen)),
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  ),
                ),
              TextButton.icon(
                onPressed: () => _showDetail(msg),
                icon:
                    const Icon(Icons.open_in_full, size: 16, color: kCyberBlue),
                label: Text('View',
                    style:
                        GoogleFonts.nunito(fontSize: 12, color: kCyberBlue)),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _markRead(ContactMessageModel msg) async {
    final token = context.read<AuthProvider>().token;
    if (token == null) return;
    try {
      await _service.markMessageRead(msg.id, token);
      _load();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Failed to update')));
      }
    }
  }

  void _showDetail(ContactMessageModel msg) {
    // Auto-mark as read when opening
    if (!msg.isRead) _markRead(msg);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
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
              Text(msg.subject,
                  style: GoogleFonts.firaCode(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kTextPrimary)),
              const SizedBox(height: 10),
              _detailRow(Icons.person, msg.name),
              _detailRow(Icons.email, msg.email),
              _detailRow(Icons.calendar_today,
                  msg.createdAt != null ? DateFormat('MMM d, yyyy – h:mm a').format(msg.createdAt!) : 'N/A'),
              const Divider(color: kTextMuted, height: 24),
              Text(msg.message,
                  style:
                      GoogleFonts.nunito(fontSize: 14, color: kTextSecondary)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 14, color: kTextMuted),
          const SizedBox(width: 8),
          Expanded(
              child: Text(text,
                  style:
                      GoogleFonts.nunito(fontSize: 13, color: kTextSecondary))),
        ],
      ),
    );
  }
}
