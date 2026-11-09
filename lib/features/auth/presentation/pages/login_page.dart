import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart'
    show
        GoogleSignIn,
        GoogleSignInAccount,
        GoogleSignInAuthentication,
        GoogleSignInException,
        GoogleSignInExceptionCode;
import '../../../../app/router/app_router.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/repositories/auth_repository.dart';
import '../blocs/auth_bloc.dart';

// FR-AUTH-001: email/identifier + password login
// FR-AUTH-003: Google OAuth (native mobile PKCE flow — NOT web token copy)
// FR-AUTH-004: OTP login option
// FR-AUTH-013: distinguish social auth errors (cancel, SDK fail, conflict, network)
// FR-AUTH-015: NEVER log credentials
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(repository: GetIt.instance<AuthRepository>()),
      child: const _LoginView(),
    );
  }
}

// ── View ─────────────────────────────────────────────────────────────────────

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> with TickerProviderStateMixin {
  // ── Blob animation controllers ────────────────────────────────────────────
  late final AnimationController _blob1Controller;
  late final AnimationController _blob2Controller;

  // ── Per-axis TweenSequence animations (CSS @keyframes blob replica) ───────
  late final Animation<double> _blob1X;
  late final Animation<double> _blob1Y;
  late final Animation<double> _blob1Scale;
  late final Animation<double> _blob2X;
  late final Animation<double> _blob2Y;
  late final Animation<double> _blob2Scale;

  // ── Form state ────────────────────────────────────────────────────────────
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
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

    // Blob 2 starts 2s into the 7s cycle to match CSS animation-delay: 2s
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
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  // ── Google Sign-In (FR-AUTH-003) ─────────────────────────────────────────
  // Uses the native SDK on device — NEVER copy-paste a token from web flow.
  // google_sign_in v7: singleton instance + authenticate() (replaces signIn()).
  // authentication is now synchronous on the returned account object.
  // TODO: restore real Google sign-in when API is available
  Future<void> _googleSignIn() async => _bypassLogin();

  // TODO: remove when API is available — bypasses auth entirely for local dev
  void _bypassLogin() {
    authNotifier.setAuthenticated(true);
    context.go(AppRoutes.home);
  }

  void _onAuthState(BuildContext ctx, AuthState state) {
    if (state is AuthAuthenticated || state is AuthGuest) {
      ctx.go(AppRoutes.home);
    } else if (state is AuthOtpSent) {
      ctx.pushNamed(
        AppRoutes.nameOtp,
        queryParameters: {'email': state.email, 'purpose': 'login'},
      );
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
            // ── Animated blob 1 — primary tint (top-left) ────────────────
            Positioned(
              top: -size.height * 0.08,
              left: -size.width * 0.12,
              child: _AnimatedBlob(
                xAnim: _blob1X,
                yAnim: _blob1Y,
                scaleAnim: _blob1Scale,
                size: Size(size.width * 0.55, size.height * 0.35),
                color: AppColors.primaryFixed,
                opacity: 0.70,
              ),
            ),
            // ── Animated blob 2 — secondary tint (bottom-right) ──────────
            Positioned(
              bottom: -size.height * 0.05,
              right: -size.width * 0.15,
              child: _AnimatedBlob(
                xAnim: _blob2X,
                yAnim: _blob2Y,
                scaleAnim: _blob2Scale,
                size: Size(size.width * 0.60, size.height * 0.35),
                color: AppColors.secondaryFixed,
                opacity: 0.50,
              ),
            ),

            // ── Frosted-glass overlay — softens blobs as per Stitch design ─
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: const SizedBox.expand(),
            ),

            // ── Scrollable form card ──────────────────────────────────────
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, topPad + 24, 20, 40),
              child: _LoginCard(
                emailController: _emailController,
                passwordController: _passwordController,
                emailFocus: _emailFocus,
                passwordFocus: _passwordFocus,
                obscurePassword: _obscurePassword,
                onToggleObscure: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                onLogin: _bypassLogin,
                onOtpLogin: _bypassLogin,
                onGoogleSignIn: _googleSignIn,
                onForgotPassword: () =>
                    context.push(AppRoutes.forgotPassword),
                onRegister: () =>
                    context.pushNamed(AppRoutes.nameRegister),
                onBrowseAsGuest: () => context.go(AppRoutes.home),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Login Card ───────────────────────────────────────────────────────────────

class _LoginCard extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final VoidCallback onLogin;
  final VoidCallback onOtpLogin;
  final VoidCallback onGoogleSignIn;
  final VoidCallback onForgotPassword;
  final VoidCallback onRegister;
  final VoidCallback onBrowseAsGuest;

  const _LoginCard({
    required this.emailController,
    required this.passwordController,
    required this.emailFocus,
    required this.passwordFocus,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.onLogin,
    required this.onOtpLogin,
    required this.onGoogleSignIn,
    required this.onForgotPassword,
    required this.onRegister,
    required this.onBrowseAsGuest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest.withAlpha(230),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant, width: 0.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Brand + headline
          const _Header(),
          const SizedBox(height: 32),

          // Email
          const _FieldLabel(text: 'Email address'),
          const SizedBox(height: 8),
          _AppTextField(
            controller: emailController,
            focusNode: emailFocus,
            hintText: 'you@example.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => passwordFocus.requestFocus(),
          ),

          const SizedBox(height: 20),

          // Password row with inline "Forgot?" link
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _FieldLabel(text: 'Password'),
              GestureDetector(
                onTap: onForgotPassword,
                child: Text(
                  'Forgot password?',
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _AppTextField(
            controller: passwordController,
            focusNode: passwordFocus,
            hintText: '••••••••',
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

          // Primary CTA — brandDeepRose (#C2185B)
          _PrimaryButton(label: 'Log In', onPressed: onLogin),

          const SizedBox(height: 14),

          // OTP login link
          Center(
            child: GestureDetector(
              onTap: onOtpLogin,
              child: Text(
                'Log in with OTP instead',
                style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ),

          const SizedBox(height: 28),

          const _OrDivider(),

          const SizedBox(height: 24),

          // Google
          _SocialButton(
            // Google G logo via Stitch CDN — falls back to icon on error
            logoUrl:
                'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
            fallbackIcon: Icons.g_mobiledata,
            label: 'Continue with Google',
            onPressed: onGoogleSignIn,
          ),

          const SizedBox(height: 12),

          // Apple — TODO: implement Sign in with Apple (FR-AUTH-003b)
          _SocialButton(
            logoUrl: null,
            fallbackIcon: Icons.apple,
            label: 'Continue with Apple',
            onPressed: () {},
          ),

          const SizedBox(height: 32),

          // Sign-up footer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              GestureDetector(
                onTap: onRegister,
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Guest bypass — visible until API is ready
          GestureDetector(
            onTap: onBrowseAsGuest,
            child: Center(
              child: Text(
                'Browse as guest →',
                style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant.withAlpha(160),
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.onSurfaceVariant.withAlpha(100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Brand wordmark
        Text(
          'Forge Moments',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 20 * -0.01,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        // Display headline — EB Garamond 32/40 w700
        Text(
          'Welcome Back',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
            fontSize: 32,
            fontWeight: FontWeight.w700,
            height: 40 / 32,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        // Subtitle — Hanken Grotesk body
        Text(
          'Sign in to keep the magic going',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 26 / 16,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ── Field label ───────────────────────────────────────────────────────────────

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

// ── Text field ────────────────────────────────────────────────────────────────
// 16 px radius, surfaceBright fill, icon prefix — matches Stitch login HTML

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
        fillColor: AppColors.surfaceBright,
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

// ── Primary button (brandDeepRose — #C2185B) ──────────────────────────────────

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
                  color: Color(0x4DC2185B), // rgba(194,24,91,0.30)
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

// ── "Or continue with" divider ────────────────────────────────────────────────

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: AppColors.outlineVariant,
            thickness: 0.5,
          ),
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
          child: Divider(
            color: AppColors.outlineVariant,
            thickness: 0.5,
          ),
        ),
      ],
    );
  }
}

// ── Social button (Google / Apple) ────────────────────────────────────────────

class _SocialButton extends StatelessWidget {
  final String? logoUrl;
  final IconData fallbackIcon;
  final String label;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.logoUrl,
    required this.fallbackIcon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant),
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
                      errorWidget: (_, __, ___) => Icon(
                        fallbackIcon,
                        size: 22,
                        color: AppColors.onSurface,
                      ),
                    )
                  : Icon(
                      fallbackIcon,
                      size: 22,
                      color: AppColors.onSurface,
                    ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Animated Blob (CSS @keyframes blob replica) ───────────────────────────────
// X and Y are translated together each frame; scale is applied via Transform.scale.
// Using Listenable.merge so a single AnimatedBuilder drives all three.

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
