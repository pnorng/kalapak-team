import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/colors.dart';
import '../../../core/widgets/cosmic_background.dart';
import '../../../core/widgets/glass_card.dart';
import '../providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameC;
  late TextEditingController _avatarC;
  final _currentPassC = TextEditingController();
  final _newPassC = TextEditingController();
  final _confirmPassC = TextEditingController();

  bool _savingProfile = false;
  bool _savingPassword = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  String? _profileError;
  String? _passwordError;
  bool _profileSaved = false;
  bool _passwordSaved = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _nameC = TextEditingController(text: user?.name ?? '');
    _avatarC = TextEditingController(text: user?.avatar ?? '');
  }

  @override
  void dispose() {
    _nameC.dispose();
    _avatarC.dispose();
    _currentPassC.dispose();
    _newPassC.dispose();
    _confirmPassC.dispose();
    super.dispose();
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
                title: Text(
                  'Edit Profile',
                  style: GoogleFonts.firaCode(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kStarWhite,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildAvatarPreview(),
                        const SizedBox(height: 28),
                        _buildProfileSection(),
                        const SizedBox(height: 28),
                        _buildPasswordSection(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Avatar preview ─────────────────────────────────────────────────────────
  Widget _buildAvatarPreview() {
    return Center(
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _avatarC,
        builder: (_, val, __) {
          final url = val.text.trim();
          return Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: kNebulaPurple.withOpacity(0.18),
                backgroundImage: url.isNotEmpty ? NetworkImage(url) : null,
                onBackgroundImageError: url.isNotEmpty ? (_, __) {} : null,
                child: url.isEmpty
                    ? Text(
                        (context.read<AuthProvider>().user?.name ?? '?')
                            .substring(0, 1)
                            .toUpperCase(),
                        style: GoogleFonts.firaCode(
                          fontSize: 32,
                          color: kNebulaPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: kCyberBlue,
                  shape: BoxShape.circle,
                  border: Border.all(color: kDeepSpace, width: 2),
                ),
                child: const Icon(Icons.edit, size: 14, color: Colors.white),
              ),
            ],
          );
        },
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.85, 0.85));
  }

  // ── Profile section (name + avatar url) ──────────────────────────────────
  Widget _buildProfileSection() {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile Info',
            style: GoogleFonts.firaCode(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: kTextPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildField(
            controller: _nameC,
            label: 'Full Name',
            icon: Icons.person_outline,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Name is required' : null,
          ),
          const SizedBox(height: 14),
          _buildField(
            controller: _avatarC,
            label: 'Avatar URL (optional)',
            icon: Icons.image_outlined,
            hint: 'https://example.com/photo.jpg',
          ),
          if (_profileError != null) ...[
            const SizedBox(height: 10),
            Text(_profileError!,
                style:
                    GoogleFonts.nunito(fontSize: 12, color: Colors.redAccent)),
          ],
          if (_profileSaved) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.check_circle, size: 14, color: kSuccessGreen),
                const SizedBox(width: 6),
                Text('Profile updated!',
                    style:
                        GoogleFonts.nunito(fontSize: 12, color: kSuccessGreen)),
              ],
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _savingProfile ? null : _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: kCyberBlue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: _savingProfile
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text(
                      'Save Profile',
                      style: GoogleFonts.firaCode(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05);
  }

  // ── Password section ──────────────────────────────────────────────────────
  Widget _buildPasswordSection() {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Change Password',
            style: GoogleFonts.firaCode(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: kTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Leave blank to keep your current password.',
            style: GoogleFonts.nunito(fontSize: 12, color: kTextMuted),
          ),
          const SizedBox(height: 16),
          _buildField(
            controller: _currentPassC,
            label: 'Current Password',
            icon: Icons.lock_outline,
            obscure: _obscureCurrent,
            onToggleObscure: () =>
                setState(() => _obscureCurrent = !_obscureCurrent),
          ),
          const SizedBox(height: 14),
          _buildField(
            controller: _newPassC,
            label: 'New Password',
            icon: Icons.lock_reset_outlined,
            obscure: _obscureNew,
            onToggleObscure: () => setState(() => _obscureNew = !_obscureNew),
          ),
          const SizedBox(height: 14),
          _buildField(
            controller: _confirmPassC,
            label: 'Confirm New Password',
            icon: Icons.lock_reset_outlined,
            obscure: _obscureConfirm,
            onToggleObscure: () =>
                setState(() => _obscureConfirm = !_obscureConfirm),
          ),
          if (_passwordError != null) ...[
            const SizedBox(height: 10),
            Text(_passwordError!,
                style:
                    GoogleFonts.nunito(fontSize: 12, color: Colors.redAccent)),
          ],
          if (_passwordSaved) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.check_circle, size: 14, color: kSuccessGreen),
                const SizedBox(width: 6),
                Text('Password changed!',
                    style:
                        GoogleFonts.nunito(fontSize: 12, color: kSuccessGreen)),
              ],
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _savingPassword ? null : _savePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: kNebulaPurple,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: _savingPassword
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text(
                      'Change Password',
                      style: GoogleFonts.firaCode(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05);
  }

  // ── Shared field widget ───────────────────────────────────────────────────
  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    bool obscure = false,
    VoidCallback? onToggleObscure,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: GoogleFonts.nunito(color: kTextPrimary, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: GoogleFonts.nunito(
            color: kTextMuted.withOpacity(0.5), fontSize: 13),
        labelStyle: GoogleFonts.nunito(color: kTextSecondary, fontSize: 13),
        prefixIcon: Icon(icon, color: kTextMuted, size: 18),
        suffixIcon: onToggleObscure != null
            ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: kTextMuted,
                  size: 18,
                ),
                onPressed: onToggleObscure,
              )
            : null,
        filled: true,
        fillColor: kSurface.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kTextMuted.withOpacity(0.15)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kTextMuted.withOpacity(0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kCyberBlue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }

  // ── Actions ───────────────────────────────────────────────────────────────
  Future<void> _saveProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _savingProfile = true;
      _profileError = null;
      _profileSaved = false;
    });

    final error = await context.read<AuthProvider>().updateProfile(
          name: _nameC.text.trim(),
          avatar: _avatarC.text.trim().isEmpty ? '' : _avatarC.text.trim(),
        );

    if (mounted) {
      setState(() {
        _savingProfile = false;
        _profileError = error;
        _profileSaved = error == null;
      });
    }
  }

  Future<void> _savePassword() async {
    final current = _currentPassC.text;
    final newPass = _newPassC.text;
    final confirm = _confirmPassC.text;

    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      setState(() => _passwordError = 'Please fill in all password fields');
      return;
    }
    if (newPass.length < 8) {
      setState(
          () => _passwordError = 'New password must be at least 8 characters');
      return;
    }
    if (newPass != confirm) {
      setState(() => _passwordError = 'New passwords do not match');
      return;
    }

    setState(() {
      _savingPassword = true;
      _passwordError = null;
      _passwordSaved = false;
    });

    final error = await context.read<AuthProvider>().updateProfile(
          currentPassword: current,
          newPassword: newPass,
          newPasswordConfirmation: confirm,
        );

    if (mounted) {
      setState(() {
        _savingPassword = false;
        _passwordError = error;
        _passwordSaved = error == null;
      });
      if (error == null) {
        _currentPassC.clear();
        _newPassC.clear();
        _confirmPassC.clear();
      }
    }
  }
}
