import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/repositories/auth_repository.dart';
import '../blocs/auth_bloc.dart';

// FR-AUTH-002: New account registration — full name, email, phone (+234), password
// FR-AUTH-003: Google OAuth (native mobile PKCE flow — NOT web token copy)
// Mirrors the login_page.dart blob-background pattern.
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(repository: GetIt.instance<AuthRepository>()),
      child: const _RegisterView(),
    );
  }
}

// ── View ──────────────────────────────────────────────────────────────────────

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView>
    with TickerProviderStateMixin {
  // ── Blob animation controllers ────────────────────────────────────────────
  late final AnimationController _blob1Controller;
  late final AnimationController _blob2Controller;

  late final Animation<double> _blob1X;
  late final Animation<double> _blob1Y;
  late final Animation<double> _blob1Scale;
  late final Animation<double> _blob2X;
  late final Animation<double> _blob2Y;
  late final Animation<double> _blob2Scale;

  // ── Form state ────────────────────────────────────────────────────────────
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _obscurePassword = true;

  // keyframes: 0% → 33% → 66% → 100%
  // translate(0,0)→translate(30,-50)→translate(-20,20)→translate(0,0)
  // scale(1)→scale(1.1)→scale(0.9)→scale(1)
  Animation<double> _xAnim(AnimationController c) => TweenSequence([
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 30.0), weight: 33),
        TweenSequenceItem(tween: Tween(begin: 30.0, end: -20.0), weight: 33),
        TweenSequenceItem(tween: Tween(begin: -20.0, end: 0.0), weight: 34),
      ]).animate(c);

  Animation<double> _yAnim(AnimationController c) => TweenSequence([
        TweenSequenceItem(tween: Tween(begin: 0.0, end: -50.0), weight: 33),
        TweenSequenceItem(tween: Tween(begin: -50.0, end: 20.0), weight: 33),
        TweenSequenceItem(tween: Tween(begin: 20.0, end: 0.0), weight: 34),
      ]).animate(c);

  Animation<double> _scaleAnim(AnimationController c) => TweenSequence([
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.1), weight: 33),
        TweenSequenceItem(tween: Tween(begin: 1.1, end: 0.9), weight: 33),
        TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 34),
      ]).animate(c);

  @override
  void initState() {
    super.initState();

    _blob1Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();

    // Blob 2 starts 2 s into the 7 s cycle — matches CSS animation-delay: 2s
    _blob2Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
    _blob2Controller.value = 2 / 7;

    _blob1X = _xAnim(_blob1Controller);
    _blob1Y = _yAnim(_blob1Controller);
    _blob1Scale = _scaleAnim(_blob1Controller);
    _blob2X = _xAnim(_blob2Controller);
    _blob2Y = _yAnim(_blob2Controller);
    _blob2Scale = _scaleAnim(_blob2Controller);
  }

  @override
  void dispose() {
    _blob1Controller.dispose();
    _blob2Controller.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  // TODO: remove when API is available — bypasses auth entirely for local dev
  void _bypassRegister() {
    authNotifier.setAuthenticated(true);
    context.go(AppRoutes.home);
  }

  // TODO: restore real Google sign-in when API is available
  Future<void> _googleSignIn() async => _bypassRegister();

  void _onSignUp() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    if (name.isEmpty || email.isEmpty || password.isEmpty) return;
    context.read<AuthBloc>().add(AuthRegisterRequested(
          displayName: name,
          email: email,
          password: password,
          phone: phone.isEmpty ? null : '+234$phone',
        ));
  }

  void _onAuthState(BuildContext ctx, AuthState state) {
    if (state is AuthAuthenticated) {
      authNotifier.setAuthenticated(true);
      ctx.go(AppRoutes.home);
    } else if (state is AuthError) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final topPad = MediaQuery.paddingOf(context).top;

    return BlocListener<AuthBloc, AuthState>(
      listener: _onAuthState,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            // ── Blob 1 — primaryFixedDim tint, top-right ──────────────────
            Positioned(
              top: -size.height * 0.08,
              right: -size.width * 0.12,
              child: _AnimatedBlob(
                xAnim: _blob1X,
                yAnim: _blob1Y,
                scaleAnim: _blob1Scale,
                size: Size(size.width * 0.60, size.height * 0.35),
                color: AppColors.primaryFixedDim,
                opacity: 0.60,
              ),
            ),
            // ── Blob 2 — secondaryFixed tint, bottom-left ─────────────────
            Positioned(
              bottom: -size.height * 0.05,
              left: -size.width * 0.15,
              child: _AnimatedBlob(
                xAnim: _blob2X,
                yAnim: _blob2Y,
                scaleAnim: _blob2Scale,
                size: Size(size.width * 0.70, size.height * 0.35),
                color: AppColors.secondaryFixed,
                opacity: 0.40,
              ),
            ),

            // ── Frosted-glass overlay — softens blobs ─────────────────────
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: const SizedBox.expand(),
            ),

            // ── Scrollable form card ───────────────────────────────────────
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, topPad + 24, 20, 40),
              child: _RegisterCard(
                nameController: _nameController,
                emailController: _emailController,
                phoneController: _phoneController,
                passwordController: _passwordController,
                nameFocus: _nameFocus,
                emailFocus: _emailFocus,
                phoneFocus: _phoneFocus,
                passwordFocus: _passwordFocus,
                obscurePassword: _obscurePassword,
                onToggleObscure: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                onSignUp: _bypassRegister,
                onGoogleSignIn: _googleSignIn,
                onLogin: () => context.pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Register Card ─────────────────────────────────────────────────────────────

class _RegisterCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final FocusNode nameFocus;
  final FocusNode emailFocus;
  final FocusNode phoneFocus;
  final FocusNode passwordFocus;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final VoidCallback onSignUp;
  final VoidCallback onGoogleSignIn;
  final VoidCallback onLogin;

  const _RegisterCard({
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.nameFocus,
    required this.emailFocus,
    required this.phoneFocus,
    required this.passwordFocus,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.onSignUp,
    required this.onGoogleSignIn,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest.withAlpha(230),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          // ~8 % primary opacity — matches HTML rgba(230,26,97,0.08)
          color: AppColors.primary.withAlpha(20),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14E6185F), // rgba(230,24,95,0.08)
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _Header(),
          const SizedBox(height: 32),

          // Full Name
          const _FieldLabel(text: 'Full Name'),
          const SizedBox(height: 8),
          _AppTextField(
            controller: nameController,
            focusNode: nameFocus,
            hintText: 'Enter your full name',
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => emailFocus.requestFocus(),
          ),

          const SizedBox(height: 20),

          // Email
          const _FieldLabel(text: 'Email Address'),
          const SizedBox(height: 8),
          _AppTextField(
            controller: emailController,
            focusNode: emailFocus,
            hintText: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => phoneFocus.requestFocus(),
          ),

          const SizedBox(height: 20),

          // Phone
          const _FieldLabel(text: 'Phone Number'),
          const SizedBox(height: 8),
          _PhoneField(
            controller: phoneController,
            focusNode: phoneFocus,
            onSubmitted: (_) => passwordFocus.requestFocus(),
          ),

          const SizedBox(height: 20),

          // Password
          const _FieldLabel(text: 'Password'),
          const SizedBox(height: 8),
          _AppTextField(
            controller: passwordController,
            focusNode: passwordFocus,
            hintText: 'Create a password',
            obscureText: obscurePassword,
            textInputAction: TextInputAction.done,
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 20,
                color: AppColors.onSurfaceVariant,
              ),
              onPressed: onToggleObscure,
            ),
          ),

          const SizedBox(height: 28),

          _PrimaryButton(label: 'Sign Up', onPressed: onSignUp),

          const SizedBox(height: 28),

          const _OrDivider(),

          const SizedBox(height: 24),

          // Google — light pill
          _SocialButton(
            logoUrl:
                'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
            fallbackIcon: Icons.g_mobiledata,
            label: 'Google',
            onPressed: onGoogleSignIn,
            dark: false,
          ),

          const SizedBox(height: 10),

          // Apple — dark pill (bg-on-background per Stitch design)
          _SocialButton(
            logoUrl: null,
            fallbackIcon: Icons.apple,
            label: 'Apple',
            onPressed: () {},
            dark: true,
          ),

          const SizedBox(height: 32),

          // Login footer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              GestureDetector(
                onTap: onLogin,
                child: Text(
                  'Login',
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Redeem icon in primary-container circle
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: AppColors.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.redeem,
            color: AppColors.onPrimaryContainer,
            size: 32,
          ),
        ),
        const SizedBox(height: 16),
        // "Create Account" — EB Garamond headline-lg-mobile, primary
        Text(
          'Create Account',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
            fontSize: 28,
            fontWeight: FontWeight.w600,
            height: 36 / 28,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Join Forge Moments and start sending joy.',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 24 / 16,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ── Field Label ───────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      ),
    );
  }
}

// ── Text Field ─────────────────────────────────────────────────────────────────

class _AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffixIcon;

  const _AppTextField({
    required this.controller,
    required this.focusNode,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceVariant.withAlpha(150),
        ),
        filled: true,
        fillColor: AppColors.surfaceContainerLowest,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

// ── Phone Field (+234 prefix) ──────────────────────────────────────────────────

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String>? onSubmitted;

  const _PhoneField({
    required this.controller,
    required this.focusNode,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      onSubmitted: onSubmitted,
      style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
      ),
      decoration: InputDecoration(
        hintText: 'Enter phone number',
        hintStyle: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceVariant.withAlpha(150),
        ),
        filled: true,
        fillColor: AppColors.surfaceContainerLowest,
        // Flag + dial code with a vertical divider before the text area
        prefixIcon: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 12),
              const Icon(
                Icons.flag_outlined,
                size: 18,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                '+234',
                style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              const VerticalDivider(
                color: AppColors.outlineVariant,
                width: 1,
                thickness: 1,
                indent: 12,
                endIndent: 12,
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

// ── Primary Button ────────────────────────────────────────────────────────────

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _PrimaryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (_, state) {
        final isLoading = state is AuthLoading;
        return GestureDetector(
          onTap: isLoading ? null : onPressed,
          child: Container(
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.brandDeepRose,
              borderRadius: BorderRadius.circular(9999),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x4DC2185B),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.onPrimary,
                    ),
                  )
                : Text(
                    label,
                    style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 14 * 0.01,
                      color: AppColors.onPrimary,
                    ),
                  ),
          ),
        );
      },
    );
  }
}

// ── "Or continue with" Divider ────────────────────────────────────────────────

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: AppColors.outlineVariant, thickness: 0.5),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Or continue with',
            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        const Expanded(
          child: Divider(color: AppColors.outlineVariant, thickness: 0.5),
        ),
      ],
    );
  }
}

// ── Social Button ─────────────────────────────────────────────────────────────

class _SocialButton extends StatelessWidget {
  final String? logoUrl;
  final IconData fallbackIcon;
  final String label;
  final VoidCallback onPressed;
  // dark=true → bg-on-background / white text (Apple button per design)
  final bool dark;

  const _SocialButton({
    required this.logoUrl,
    required this.fallbackIcon,
    required this.label,
    required this.onPressed,
    this.dark = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = dark ? AppColors.onBackground : AppColors.surfaceContainerLowest;
    final fg = dark ? AppColors.onPrimary : AppColors.onSurface;
    final borderColor =
        dark ? AppColors.onBackground : AppColors.outlineVariant;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: logoUrl != null
                  ? CachedNetworkImage(
                      imageUrl: logoUrl!,
                      fit: BoxFit.contain,
                      errorWidget: (_, __, ___) =>
                          Icon(fallbackIcon, size: 22, color: fg),
                    )
                  : Icon(fallbackIcon, size: 22, color: fg),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Animated Blob (CSS @keyframes blob replica) ───────────────────────────────

class _AnimatedBlob extends StatelessWidget {
  final Animation<double> xAnim;
  final Animation<double> yAnim;
  final Animation<double> scaleAnim;
  final Size size;
  final Color color;
  final double opacity;

  const _AnimatedBlob({
    required this.xAnim,
    required this.yAnim,
    required this.scaleAnim,
    required this.size,
    required this.color,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([xAnim, yAnim, scaleAnim]),
      builder: (_, __) => Transform.translate(
        offset: Offset(xAnim.value, yAnim.value),
        child: Transform.scale(
          scale: scaleAnim.value,
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withAlpha((opacity * 0.4 * 255).round()),
                boxShadow: [
                  BoxShadow(
                    color: color.withAlpha((opacity * 255).round()),
                    blurRadius: 80,
                    spreadRadius: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
