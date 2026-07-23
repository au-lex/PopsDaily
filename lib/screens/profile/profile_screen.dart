import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:news_app/api_service/hooks/user_api.dart';
import 'package:news_app/config/routes.dart';
import 'package:news_app/theme/app_color_extension.dart';
import 'package:news_app/theme/theme_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _userName;
  String? _userEmail;
  final String? _avatarUrl = null;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final user = await fetchProfile();
      if (!mounted) return;
      setState(() {
        _userName = user.fullName;
        _userEmail = user.email;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('[ProfileScreen] fetchProfile failed: $e');
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  String get _displayName {
    if (_userName != null && _userName!.trim().isNotEmpty) return _userName!.trim();
    return 'Guest';
  }

  String get _displayEmail => _userEmail ?? '';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Settings',
          style: TextStyle(
            color: colors.textPri,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 12),

            // User avatar + name + email
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: colors.pri.withOpacity(0.15),
                  backgroundImage: _avatarUrl != null
                      ? NetworkImage(_avatarUrl!)
                      : null,
                  child: _avatarUrl == null
                      ? Text(
                          _displayName.isNotEmpty && !_isLoading
                              ? _displayName[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: colors.pri,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _isLoading
                          ? Container(
                              height: 17,
                              width: 120,
                              decoration: BoxDecoration(
                                color: colors.surface,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            )
                          : Text(
                              _displayName,
                              style: TextStyle(
                                color: colors.textPri,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                      const SizedBox(height: 6),
                      _isLoading
                          ? Container(
                              height: 13,
                              width: 160,
                              decoration: BoxDecoration(
                                color: colors.surface,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            )
                          : Text(
                              _displayEmail,
                              style: TextStyle(color: colors.textSec, fontSize: 13),
                            ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            _SectionHeader(label: 'General'),
            const SizedBox(height: 8),

            _SettingsTile(
              icon: Iconsax.user,
              label: 'Personal Info',
              onTap: () {
                context.push(AppRoutes.editPersonalInfo);
              },
            ),
            _SettingsTile(
              icon: Iconsax.notification,
              label: 'Notification',
              onTap: () {},
            ),


            _SettingsTile(
              icon: Iconsax.shield_tick,
              label: 'Security',
                onTap: () {
                context.push(AppRoutes.security);
              },
            ),

            // Dark Mode — now wired to the real themeController, not local state
            ValueListenableBuilder<ThemeMode>(
              valueListenable: themeController,
              builder: (context, mode, _) {
                final isDark = mode == ThemeMode.dark;
                return _SettingsTile(
                  icon: Iconsax.eye,
                  label: 'Dark Mode',
                  trailing: Switch(
                    value: isDark,
                    onChanged: (_) => themeController.toggle(),
                    activeColor: colors.white,
                    activeTrackColor: colors.pri,
                    inactiveThumbColor: colors.white,
                    inactiveTrackColor: colors.textSec.withOpacity(0.3),
                  ),
                  onTap: () {},
                );
              },
            ),

            const SizedBox(height: 24),
            _SectionHeader(label: 'About'),
            const SizedBox(height: 8),

            _SettingsTile(
              icon: Iconsax.discover_1,
              label: 'Follow us on Social Media',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Iconsax.document,
              label: 'Help Center',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Iconsax.lock,
              label: 'Privacy Policy',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Iconsax.info_circle,
              label: 'About Newsline',
              onTap: () {},
            ),

            const SizedBox(height: 8),
            _SettingsTile(
              icon: Iconsax.logout,
              label: 'Logout',
              iconColor: colors.error,
              textColor: colors.error,
              showChevron: false,
              onTap: () {
                // TODO: wire to your actual logout flow
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;

  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.textSec,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Divider(color: colors.textSec.withOpacity(0.3), height: 1),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailingText;
  final Widget? trailing;
  final bool showChevron;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailingText,
    this.trailing,
    this.showChevron = true,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? colors.textPri, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: textColor ?? colors.textPri,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText!,
                style: TextStyle(color: colors.textSec, fontSize: 15),
              ),
              const SizedBox(width: 8),
            ],
            if (trailing != null) trailing!,
            if (trailing == null && showChevron)
              Icon(
                Icons.chevron_right,
                color: colors.textSec.withOpacity(0.7),
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}