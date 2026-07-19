import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:news_app/theme/app_color_extension.dart';

class EditPersonalInfoScreen extends StatefulWidget {
  const EditPersonalInfoScreen({
    super.key,
    this.initialName = 'Jane Doe',
    this.initialEmail = 'jane.doe@example.com',
    this.initialPhone = '',
    this.initialBio = '',
    this.avatarUrl,
  });

  final String initialName;
  final String initialEmail;
  final String initialPhone;
  final String initialBio;
  final String? avatarUrl;

  @override
  State<EditPersonalInfoScreen> createState() =>
      _EditPersonalInfoScreenState();
}

class _EditPersonalInfoScreenState extends State<EditPersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _bioController;

  String? _avatarUrl;
  bool _isSaving = false;
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    _avatarUrl = widget.avatarUrl;
    _nameController = TextEditingController(text: widget.initialName)
      ..addListener(_markDirty);
    _emailController = TextEditingController(text: widget.initialEmail)
      ..addListener(_markDirty);
    _phoneController = TextEditingController(text: widget.initialPhone)
      ..addListener(_markDirty);
    _bioController = TextEditingController(text: widget.initialBio)
      ..addListener(_markDirty);
  }

  void _markDirty() {
    if (!_isDirty) setState(() => _isDirty = true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _onChangePhoto() {
    // TODO: wire to your image picker flow
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    // TODO: wire to your actual update-profile API call
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    setState(() {
      _isSaving = false;
      _isDirty = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated')),
    );
    Navigator.of(context).pop();
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
          'Personal Info',
          style: TextStyle(
            color: colors.textPri,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isDirty && !_isSaving ? _onSave : null,
            child: Text(
              'Save',
              style: TextStyle(
                color: _isDirty ? colors.pri : colors.textSec.withOpacity(0.5),
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              Center(child: _AvatarEditor(
                colors: colors,
                name: _nameController.text,
                avatarUrl: _avatarUrl,
                onTap: _onChangePhoto,
              )),
              const SizedBox(height: 32),

              _FieldLabel('Full Name', colors: colors),
              const SizedBox(height: 8),
              _ProfileTextField(
                controller: _nameController,
                colors: colors,
                icon: Iconsax.user,
                hint: 'Enter your full name',
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Name cannot be empty'
                    : null,
              ),
              const SizedBox(height: 20),

              _FieldLabel('Email Address', colors: colors),
              const SizedBox(height: 8),
              _ProfileTextField(
                controller: _emailController,
                colors: colors,
                icon: Iconsax.sms,
                hint: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Email cannot be empty';
                  }
                  final valid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                      .hasMatch(v.trim());
                  return valid ? null : 'Enter a valid email';
                },
              ),
              const SizedBox(height: 20),

              _FieldLabel('Phone Number', colors: colors),
              const SizedBox(height: 8),
              _ProfileTextField(
                controller: _phoneController,
                colors: colors,
                icon: Iconsax.call,
                hint: 'Enter your phone number',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),

              _FieldLabel('Bio', colors: colors),
              const SizedBox(height: 8),
              _ProfileTextField(
                controller: _bioController,
                colors: colors,
                icon: Iconsax.document_text,
                hint: 'Tell us a little about yourself',
                maxLines: 4,
                alignIconTop: true,
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: !_isSaving ? _onSave : null,
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
                          'Save Changes',
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

class _AvatarEditor extends StatelessWidget {
  const _AvatarEditor({
    required this.colors,
    required this.name,
    required this.avatarUrl,
    required this.onTap,
  });

  final AppColorsExtension colors;
  final String name;
  final String? avatarUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: colors.pri.withOpacity(0.15),
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null
                ? Text(
                    name.isNotEmpty ? name.trim()[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: colors.pri,
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : null,
          ),
          Positioned(
            bottom: -2,
            right: -2,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: colors.pri,
                shape: BoxShape.circle,
                border: Border.all(color: colors.bg, width: 3),
              ),
              child: Icon(Iconsax.camera, size: 15, color: colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label, {required this.colors});

  final String label;
  final AppColorsExtension colors;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: colors.textSec,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _ProfileTextField extends StatelessWidget {
  const _ProfileTextField({
    required this.controller,
    required this.colors,
    required this.icon,
    required this.hint,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.alignIconTop = false,
  });

  final TextEditingController controller;
  final AppColorsExtension colors;
  final IconData icon;
  final String hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool alignIconTop;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
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
        prefixIcon: Padding(
          padding: EdgeInsets.only(
            left: 14,
            right: 10,
            top: alignIconTop ? 14 : 0,
            bottom: alignIconTop ? 14 : 0,
          ),
          child: Icon(icon, size: 20, color: colors.textSec),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 0),
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