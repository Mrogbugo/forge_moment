import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/airtime/presentation/pages/airtime_create_page.dart';
import '../../features/airtime/presentation/pages/airtime_success_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/role_selection_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/celebrations/presentation/pages/celebration_form_page.dart';
import '../../features/celebrations/presentation/pages/celebrations_list_page.dart';
import '../../features/checkout/presentation/pages/checkout_delivery_page.dart';
import '../../features/checkout/presentation/pages/checkout_personalise_page.dart';
import '../../features/checkout/presentation/pages/checkout_recipient_page.dart';
import '../../features/checkout/presentation/pages/checkout_review_page.dart';
import '../../features/gifts/presentation/pages/digital_gift_template_page.dart';
import '../../features/gifts/presentation/pages/create_wishlist_page.dart';
import '../../features/gifts/presentation/pages/gift_history_page.dart';
import '../../features/gifts/presentation/pages/share_wishlist_page.dart';
import '../../features/gifts/presentation/pages/shared_wishlist_view_page.dart';
import '../../features/gifts/presentation/pages/money_package_page.dart';
import '../../features/gifts/presentation/pages/gift_personalize_page.dart';
import '../../features/gifts/presentation/pages/gift_recipient_page.dart';
import '../../features/gifts/presentation/pages/gift_review_page.dart';
import '../../features/gifts/presentation/pages/gift_success_page.dart';
import '../../features/gifts/presentation/pages/template_browser_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/orders/presentation/pages/order_detail_page.dart';
import '../../features/orders/presentation/pages/orders_list_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/security_page.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../features/profile/presentation/pages/support_page.dart';
import '../../features/store/presentation/pages/ai_concierge_page.dart';
import '../../features/store/presentation/pages/filter_page.dart';
import '../../features/store/presentation/pages/product_detail_page.dart';
import '../../features/store/presentation/pages/store_page.dart';
import '../../features/wallet/presentation/pages/fund_wallet_page.dart';
import '../../features/wallet/presentation/pages/transaction_history_page.dart';
import '../../features/wallet/presentation/pages/wallet_page.dart';
import '../../features/wallet/presentation/pages/withdrawal_page.dart';
import 'app_routes.dart';
import 'app_shell.dart';

// ---------------------------------------------------------------------------
// Auth state notifier
// ---------------------------------------------------------------------------
// Plugged into GoRouter.refreshListenable so the router re-evaluates its
// redirect guard whenever session state changes (login, logout, token expiry).
class AuthNotifier extends ChangeNotifier {
  bool _authenticated = false;
  bool _onboarded = false;
  SharedPreferences? _prefs;

  bool get isAuthenticated => _authenticated;
  bool get isOnboarded => _onboarded;

  /// Called once in [Injection.configure] before [runApp].
  /// Restores real session + onboarded state without notifying listeners
  /// (the GoRouter hasn't been built yet at this point).
  void init({
    required SharedPreferences prefs,
    required bool authenticated,
    required bool onboarded,
  }) {
    _prefs = prefs;
    _authenticated = authenticated;
    _onboarded = onboarded;
  }

  void setAuthenticated(bool value) {
    _authenticated = value;
    notifyListeners();
  }

  void setOnboarded(bool value) {
    _onboarded = value;
    _prefs?.setBool('has_onboarded', value);
    notifyListeners();
  }
}

// Singleton — replace with DI-provided instance once injection is wired.
final authNotifier = AuthNotifier();

// ---------------------------------------------------------------------------
// Router
// ---------------------------------------------------------------------------
class AppRouter {
  AppRouter._();

  static final GoRouter config = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.splash,
    refreshListenable: authNotifier,

    // ── Auth / onboarding guard (FR-MOB-005) ────────────────────────────────
    redirect: (BuildContext context, GoRouterState state) {
      final location = state.matchedLocation;
      final authenticated = authNotifier.isAuthenticated;
      final onboarded = authNotifier.isOnboarded;

      // 1. First launch — show onboarding (FR-MOB-002/003)
      //    Role selection is the natural next step after onboarding, so allow it.
      if (!onboarded &&
          location != AppRoutes.onboarding &&
          location != AppRoutes.roleSelection) {
        return AppRoutes.onboarding;
      }

      // 2. Unauthenticated users hitting protected routes → login
      //    Preserve intended destination so we can return after auth (FR-AUTH-012)
      if (!authenticated && AppRoutes.requiresAuth(location)) {
        final redirect = Uri.encodeComponent(state.uri.toString());
        return '${AppRoutes.login}?redirect=$redirect';
      }

      // 3. Already-authenticated users hitting auth screens → home
      final authScreens = [AppRoutes.login, AppRoutes.roleSelection];
      if (authenticated && authScreens.contains(location)) {
        return AppRoutes.home;
      }

      // 4. Splash resolves to home or onboarding (handled above)
      if (location == AppRoutes.splash) {
        return onboarded ? AppRoutes.home : AppRoutes.onboarding;
      }

      return null; // no redirect needed
    },

    routes: [
      // ── Splash ─────────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.nameSplash,
        builder: (_, __) => const _SplashPage(),
      ),

      // ── Onboarding ──────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRoutes.nameOnboarding,
        builder: (_, __) => const OnboardingPage(),
      ),

      // ── Role selection — appears after onboarding, before auth ─────────────
      GoRoute(
        path: AppRoutes.roleSelection,
        name: AppRoutes.nameRoleSelection,
        builder: (_, __) => const RoleSelectionPage(),
      ),

      // ── Auth ────────────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.nameLogin,
        builder: (_, __) => const LoginPage(),
        routes: [
          GoRoute(
            path: 'otp',
            name: AppRoutes.nameOtp,
            builder: (_, state) {
              final email = state.uri.queryParameters['email'] ?? '';
              final purposeStr = state.uri.queryParameters['purpose'] ?? 'login';
              final purpose = OtpPurpose.values.firstWhere(
                (p) => p.name == purposeStr,
                orElse: () => OtpPurpose.login,
              );
              return OtpPage(email: email, purpose: purpose);
            },
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.register,
        name: AppRoutes.nameRegister,
        builder: (_, __) => const RegisterPage(),
      ),

      GoRoute(
        path: AppRoutes.forgotPassword,
        name: AppRoutes.nameForgotPassword,
        builder: (_, __) => const ForgotPasswordPage(),
      ),

      // ── Deep links — handled BEFORE shell so they intercept correctly ───────

      // Google OAuth / OTP callback (FR-MOB-006)
      GoRoute(
        path: AppRoutes.authCallback,
        name: AppRoutes.nameAuthCallback,
        builder: (_, state) => _CallbackPage(
          title: 'Completing sign-in…',
          params: state.uri.queryParameters,
        ),
      ),

      // Paystack payment return (FR-GIFT-022, FR-WAL-006, FR-ORD-018)
      GoRoute(
        path: AppRoutes.paymentCallback,
        name: AppRoutes.namePaymentCallback,
        builder: (_, state) => _CallbackPage(
          title: 'Verifying payment…',
          params: state.uri.queryParameters,
        ),
      ),

      // Public gift link — receivers without the app see web; gifters deep-link
      GoRoute(
        path: AppRoutes.publicGift,
        name: AppRoutes.namePublicGift,
        builder: (_, state) {
          final giftId = state.pathParameters['giftId']!;
          // Authenticated gifters → their sent gift detail
          // Unauthenticated → hand off to web view or login
          return _PublicGiftRedirectPage(giftId: giftId);
        },
      ),

      // Public airtime claim link
      GoRoute(
        path: AppRoutes.publicAirtime,
        name: AppRoutes.namePublicAirtime,
        builder: (_, state) {
          final poolId = state.pathParameters['poolId']!;
          return _PublicAirtimeRedirectPage(poolId: poolId);
        },
      ),

      // ── Create flows (push over shell) ──────────────────────────────────────
      GoRoute(
        path: AppRoutes.createGift,
        name: AppRoutes.nameCreateGift,
        builder: (_, __) => const TemplateBrowserPage(),
        routes: [
          GoRoute(
            path: 'personalise',
            name: AppRoutes.nameGiftPersonalise,
            builder: (_, __) => const GiftPersonalizePage(),
          ),
          GoRoute(
            path: 'recipient',
            name: AppRoutes.nameGiftRecipient,
            builder: (_, __) => const GiftRecipientPage(),
          ),
          GoRoute(
            path: 'review',
            name: AppRoutes.nameGiftReview,
            builder: (_, __) => const GiftReviewPage(),
          ),
          GoRoute(
            path: 'success',
            name: AppRoutes.nameGiftSuccess,
            builder: (_, state) {
              final extra = state.extra as Map<String, String>? ?? {};
              return GiftSuccessPage(
                giftId: extra['giftId'] ?? '',
                publicLink: extra['publicLink'] ?? '',
                recipientName: extra['recipientName'] ?? '',
              );
            },
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.createDigitalGift,
        name: AppRoutes.nameCreateDigitalGift,
        builder: (_, __) => const DigitalGiftTemplatePage(),
      ),

      GoRoute(
        path: AppRoutes.createMoneyPackage,
        name: AppRoutes.nameCreateMoneyPackage,
        builder: (_, __) => const MoneyPackagePage(),
      ),

      GoRoute(
        path: AppRoutes.createAirtime,
        name: AppRoutes.nameCreateAirtime,
        builder: (_, __) => const AirtimeCreatePage(),
        routes: [
          GoRoute(
            path: 'success',
            name: AppRoutes.nameAirtimeSuccess,
            builder: (_, state) {
              final extra = state.extra as Map<String, String>? ?? {};
              return AirtimeSuccessPage(
                poolId: extra['poolId'] ?? '',
                publicLink: extra['publicLink'] ?? '',
              );
            },
          ),
        ],
      ),

      // ── Checkout is a linear 4-step wizard; each step is a sibling top-level
      // route so any step can be deep-linked or resumed independently.
      GoRoute(
        path: AppRoutes.checkoutPersonalise,
        name: AppRoutes.nameCheckoutPersonalise,
        builder: (_, __) => const CheckoutPersonalisePage(),
      ),
      GoRoute(
        path: AppRoutes.checkoutRecipient,
        name: AppRoutes.nameCheckoutRecipient,
        builder: (_, __) => const CheckoutRecipientPage(),
      ),
      GoRoute(
        path: AppRoutes.checkoutDelivery,
        name: AppRoutes.nameCheckoutDelivery,
        builder: (_, __) => const CheckoutDeliveryPage(),
      ),
      GoRoute(
        path: AppRoutes.checkoutReview,
        name: AppRoutes.nameCheckoutReview,
        builder: (_, __) => const CheckoutReviewPage(),
      ),

      // ── Store filter — full-screen, pushed over shell ──────────────────────
      GoRoute(
        path: AppRoutes.storeFilter,
        name: AppRoutes.nameStoreFilter,
        builder: (_, __) => const FilterPage(),
      ),

      // ── AI Gift Concierge ─────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.aiConcierge,
        name: AppRoutes.nameAiConcierge,
        builder: (_, __) => const AiConciergePage(),
      ),

      // ── Wishlist flows (push over shell) ─────────────────────────────────
      GoRoute(
        path: AppRoutes.createWishlist,
        name: AppRoutes.nameCreateWishlist,
        builder: (_, __) => const CreateWishlistPage(),
      ),
      GoRoute(
        path: '/wishlist/share/:wishlistId',
        name: AppRoutes.nameShareWishlist,
        builder: (_, state) =>
            ShareWishlistPage(wishlistId: state.pathParameters['wishlistId']!),
      ),
      GoRoute(
        path: AppRoutes.sharedWishlistView,
        name: AppRoutes.nameSharedWishlistView,
        builder: (_, state) => SharedWishlistViewPage(
            wishlistId: state.pathParameters['wishlistId']!),
      ),

      // ── Shell with bottom nav ─────────────────────────────────────────────
      // Nav: Home (0) | Cart (1) | Store FAB (2) | Gifts (3) | Account (4)
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => AppShell(navigationShell: shell),
        branches: [
          // Branch 0 — Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: AppRoutes.nameHome,
                builder: (_, __) => const HomePage(),
              ),
            ],
          ),

          // Branch 1 — Cart
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.cart,
                name: AppRoutes.nameCart,
                builder: (_, __) => const CartPage(),
              ),
            ],
          ),

          // Branch 2 — Store (centre FAB)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.store,
                name: AppRoutes.nameStore,
                builder: (_, __) => const StorePage(),
                routes: [
                  GoRoute(
                    path: ':productId',
                    name: AppRoutes.nameProductDetail,
                    builder: (_, state) => ProductDetailPage(
                      productId: state.pathParameters['productId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Branch 3 — Gifts / Wishlist
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.gifts,
                name: AppRoutes.nameGifts,
                builder: (_, __) => const GiftHistoryPage(),
              ),
            ],
          ),

          // Branch 4 — Account / Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                name: AppRoutes.nameProfile,
                builder: (_, __) => const ProfilePage(),
                routes: [
                  GoRoute(
                    path: 'celebrations',
                    name: AppRoutes.nameCelebrations,
                    builder: (_, __) => const CelebrationsListPage(),
                    routes: [
                      GoRoute(
                        path: 'new',
                        name: AppRoutes.nameAddCelebration,
                        builder: (_, __) => const CelebrationFormPage(),
                      ),
                      GoRoute(
                        path: ':celebrationId/edit',
                        name: AppRoutes.nameEditCelebration,
                        builder: (_, state) {
                          final extra = state.extra;
                          return CelebrationFormPage(
                            existing: extra != null ? extra as dynamic : null,
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'settings',
                    name: AppRoutes.nameSettings,
                    builder: (_, __) => const SettingsPage(),
                  ),
                  GoRoute(
                    path: 'security',
                    name: AppRoutes.nameSecurity,
                    builder: (_, __) => const SecurityPage(),
                  ),
                  GoRoute(
                    path: 'support',
                    name: AppRoutes.nameSupport,
                    builder: (_, __) => const SupportPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // ── Activity hub + sub-pages (accessible via Profile or notification actions)
      GoRoute(
        path: AppRoutes.activity,
        name: AppRoutes.nameActivity,
        builder: (_, __) => const _ActivityHubPage(),
        routes: [
          GoRoute(
            path: 'orders',
            name: AppRoutes.nameOrders,
            builder: (_, __) => const OrdersListPage(),
            routes: [
              GoRoute(
                path: ':orderId',
                name: AppRoutes.nameOrderDetail,
                builder: (_, state) => OrderDetailPage(
                  orderId: state.pathParameters['orderId']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'wallet',
            name: AppRoutes.nameWallet,
            builder: (_, __) => const WalletPage(),
            routes: [
              GoRoute(
                path: 'fund',
                name: AppRoutes.nameFundWallet,
                builder: (_, __) => const FundWalletPage(),
              ),
              GoRoute(
                path: 'withdraw',
                name: AppRoutes.nameWithdrawal,
                builder: (_, __) => const WithdrawalPage(),
              ),
              GoRoute(
                path: 'transactions',
                name: AppRoutes.nameTransactions,
                builder: (_, __) => const TransactionHistoryPage(),
              ),
            ],
          ),
          GoRoute(
            path: 'notifications',
            name: AppRoutes.nameNotifications,
            builder: (_, __) => const NotificationsPage(),
          ),
        ],
      ),
    ],

    // ── Error page ────────────────────────────────────────────────────────────
    errorBuilder: (_, state) => _ErrorPage(error: state.error),
  );
}

// ---------------------------------------------------------------------------
// Lightweight internal pages (placeholders for pages not yet fully built)
// ---------------------------------------------------------------------------

/// Shown briefly at launch while session + onboarding state is restored (FR-MOB-001).
class _SplashPage extends StatelessWidget {
  const _SplashPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

/// Handles OAuth and payment return URIs (FR-MOB-006).
/// Validates the incoming parameters and delegates to the coordinator.
class _CallbackPage extends StatelessWidget {
  final String title;
  final Map<String, String> params;

  const _CallbackPage({required this.title, required this.params});

  @override
  Widget build(BuildContext context) {
    // TODO: inject DeepLinkCoordinator and call handleUri
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(title),
          ],
        ),
      ),
    );
  }
}

/// Redirects a public gift deep link to the gifter's sent-gift detail
/// if authenticated, otherwise to login with a return path (FR-MOB-006).
class _PublicGiftRedirectPage extends StatelessWidget {
  final String giftId;
  const _PublicGiftRedirectPage({required this.giftId});

  @override
  Widget build(BuildContext context) {
    // TODO: if authenticated, push gift detail; else show web-view or login
    return Scaffold(
      body: Center(child: Text('Opening gift $giftId…')),
    );
  }
}

class _PublicAirtimeRedirectPage extends StatelessWidget {
  final String poolId;
  const _PublicAirtimeRedirectPage({required this.poolId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Opening Airtime Surprise $poolId…')),
    );
  }
}

/// Activity hub — top-level landing for orders, wallet, notifications.
/// Can be a tabbed page or a menu depending on final UX decision (FRD §20).
class _ActivityHubPage extends StatelessWidget {
  const _ActivityHubPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('Orders'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.pushNamed(AppRoutes.nameOrders),
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text('Wallet'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.pushNamed(AppRoutes.nameWallet),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notifications'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.pushNamed(AppRoutes.nameNotifications),
          ),
        ],
      ),
    );
  }
}

/// Shown when go_router cannot match any route.
class _ErrorPage extends StatelessWidget {
  final Exception? error;
  const _ErrorPage({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            const Text('This page doesn\'t exist.'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.goNamed(AppRoutes.nameHome),
              child: const Text('Go home'),
            ),
          ],
        ),
      ),
    );
  }
}
