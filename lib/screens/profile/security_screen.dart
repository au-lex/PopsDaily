import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:news_app/api_service/hooks/user_api.dart';
import 'package:news_app/theme/app_color_extension.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  void _onChangePassword(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ChangePasswordSheet(),
    );
  }

  void _onDeleteAccount(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _DeleteAccountSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left_2, color: colors.textPri),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Security',
          style: TextStyle(
            color: colors.textPri,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            _SectionHeader(label: 'Login & Security', colors: colors),
            const SizedBox(height: 8),

            _SecurityTile(
              colors: colors,
              icon: Iconsax.key,
              label: 'Change Password',
              subtitle: 'Update the password used to sign in',
              onTap: () => _onChangePassword(context),
            ),

            const SizedBox(height: 24),
            _SectionHeader(label: 'Danger Zone', colors: colors),
            const SizedBox(height: 8),

            _SecurityTile(
              colors: colors,
              icon: Iconsax.trash,
              label: 'Delete Account',
              subtitle: 'Permanently delete your account and data',
              iconColor: colors.error,
              textColor: colors.error,
              showChevron: false,
              onTap: () => _onDeleteAccount(context),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.colors});

  final String label;
  final AppColorsExtension colors;

  @override
  Widget build(BuildContext context) {
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

class _SecurityTile extends StatelessWidget {
  const _SecurityTile({
    required this.colors,
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
    this.showChevron = true,
    this.iconColor,
    this.textColor,
  });

  final AppColorsExtension colors;
  final IconData icon;
  final String label;
  final String? subtitle;
  final bool showChevron;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: (iconColor ?? colors.pri).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor ?? colors.pri, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: textColor ?? colors.textPri,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(color: colors.textSec, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            if (showChevron)
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

class _ChangePasswordSheet extends StatefulWidget {
  const _ChangePasswordSheet();

  @override
  State<_ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<_ChangePasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isSaving = false;
  String? _submitError;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _submitError = null;
    });

    try {
      await changePassword(
        currentPassword: _currentController.text,
        newPassword: _newController.text,
      );

      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated')),
      );
    } catch (e) {
      debugPrint('[ChangePasswordSheet] changePassword failed: $e');
      if (!mounted) return;
      setState(() {
        _isSaving = false;
        _submitError = "Current password is incorrect, or something went wrong";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: BoxDecoration(
          color: colors.bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.textSec.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Change Password',
                style: TextStyle(
                  color: colors.textPri,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),

              if (_submitError != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _submitError!,
                    style: TextStyle(color: colors.error, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 14),
              ],

              _PasswordField(
                colors: colors,
                controller: _currentController,
                hint: 'Current password',
                obscure: _obscureCurrent,
                onToggleObscure: () =>
                    setState(() => _obscureCurrent = !_obscureCurrent),
                validator: (v) => (v == null || v.isEmpty)
                    ? 'Enter your current password'
                    : null,
              ),
              const SizedBox(height: 14),
              _PasswordField(
                colors: colors,
                controller: _newController,
                hint: 'New password',
                obscure: _obscureNew,
                onToggleObscure: () =>
                    setState(() => _obscureNew = !_obscureNew),
                validator: (v) {
                  if (v == null || v.length < 8) {
                    return 'Must be at least 8 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              _PasswordField(
                colors: colors,
                controller: _confirmController,
                hint: 'Confirm new password',
                obscure: _obscureConfirm,
                onToggleObscure: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
                validator: (v) {
                  if (v != _newController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: !_isSaving ? _onSubmit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.pri,
                    disabledBackgroundColor: colors.pri.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: colors.white,
                          ),
                        )
                      : Text(
                          'Update Password',
                          style: TextStyle(
                            color: colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
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
}

class _DeleteAccountSheet extends StatefulWidget {
  const _DeleteAccountSheet();

  @override
  State<_DeleteAccountSheet> createState() => _DeleteAccountSheetState();
}

class _DeleteAccountSheetState extends State<_DeleteAccountSheet> {
  final _formKey = GlobalKey<FormState>();
  final _confirmController = TextEditingController();

  bool _isDeleting = false;

  static const _confirmWord = 'DELETE';

  @override
  void dispose() {
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isDeleting = true);
    // TODO: wire to your actual delete-account API call
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isDeleting = false);

    Navigator.of(context).pop();
    // TODO: navigate to login / clear session after deletion
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: BoxDecoration(
          color: colors.bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.textSec.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Delete Account',
                style: TextStyle(
                  color: colors.textPri,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This permanently deletes your account and all your data. This action cannot be undone.',
                style: TextStyle(color: colors.textSec, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 20),

              Text(
                'Type $_confirmWord to confirm',
                style: TextStyle(
                  color: colors.textSec,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _confirmController,
                textCapitalization: TextCapitalization.characters,
                style: TextStyle(
                  color: colors.textPri,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                cursorColor: colors.error,
                validator: (v) => (v?.trim() != _confirmWord)
                    ? 'Type $_confirmWord to confirm'
                    : null,
                decoration: InputDecoration(
                  hintText: _confirmWord,
                  hintStyle: TextStyle(color: colors.textSec.withOpacity(0.6)),
                  filled: true,
                  fillColor: colors.surface,
                  prefixIcon: Icon(Iconsax.trash, size: 20, color: colors.error),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: colors.error, width: 1.4),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: colors.error, width: 1.2),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: colors.error, width: 1.4),
                  ),
                  errorStyle: TextStyle(color: colors.error, fontSize: 12),
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: !_isDeleting ? _onSubmit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.error,
                    disabledBackgroundColor: colors.error.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isDeleting
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: colors.white,
                          ),
                        )
                      : Text(
                          'Delete Account',
                          style: TextStyle(
                            color: colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
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
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.colors,
    required this.controller,
    required this.hint,
    required this.obscure,
    required this.onToggleObscure,
    this.validator,
  });

  final AppColorsExtension colors;
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final VoidCallback onToggleObscure;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: TextStyle(
        color: colors.textPri,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      cursorColor: colors.pri,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: colors.textSec.withOpacity(0.6)),
        filled: true,
        fillColor: colors.surface,
        prefixIcon: Icon(Iconsax.lock, size: 20, color: colors.textSec),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Iconsax.eye_slash : Iconsax.eye,
            size: 19,
            color: colors.textSec,
          ),
          onPressed: onToggleObscure,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.pri, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.error, width: 1.4),
        ),
        errorStyle: TextStyle(color: colors.error, fontSize: 12),
      ),
    );
  }
}