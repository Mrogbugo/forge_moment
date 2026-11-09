// Dependency Injection container — manual GetIt registration (FRD Section 18)
//
// Code generation (injectable_generator) is intentionally skipped because it
// requires Dart SDK >=3.12.0 while the project targets Dart 3.9.2 (LTS).
// All registrations are explicit and ordered by dependency direction:
//   Layer 0 — Firebase + Hive platform init
//   Layer 1 — Core infrastructure (storage, session, network, analytics)
//   Layer 2 — Cross-feature services (upload, draft, deep links, push)
//   Layer 3 — Feature repository implementations
//   Layer 4 — Router wiring (authNotifier ↔ SessionCoordinatorImpl)

import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../analytics/analytics_service.dart';
import '../analytics/firebase_analytics_service_impl.dart';
import '../api/api_client.dart';
import '../api/dio_api_client.dart';
import '../auth/flutter_secure_storage_impl.dart';
import '../auth/secure_storage.dart';
import '../auth/session_coordinator.dart';
import '../auth/session_coordinator_impl.dart';
import '../crash/crash_reporter.dart';
import '../crash/firebase_crash_reporter_impl.dart';
import '../deep_links/app_deep_link_coordinator.dart';
import '../deep_links/deep_link_coordinator.dart';
import '../draft/draft_repository.dart';
import '../draft/hive_draft_repository_impl.dart';
import '../notifications/firebase_push_notification_service_impl.dart';
import '../notifications/push_notification_service.dart';
import '../upload/flutter_upload_manager_impl.dart';
import '../upload/upload_manager.dart';

// Feature repositories — interfaces
import '../../features/airtime/domain/repositories/airtime_repository.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/celebrations/domain/repositories/celebrations_repository.dart';
import '../../features/checkout/domain/repositories/checkout_repository.dart';
import '../../features/gifts/domain/repositories/gifts_repository.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/notifications/domain/repositories/notifications_repository.dart';
import '../../features/orders/domain/repositories/orders_repository.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/store/domain/repositories/store_repository.dart';
import '../../features/wallet/domain/repositories/wallet_repository.dart';

// Feature repositories — implementations
import '../../features/airtime/data/repositories/airtime_repository_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/celebrations/data/repositories/celebrations_repository_impl.dart';
import '../../features/checkout/data/repositories/checkout_repository_impl.dart';
import '../../features/gifts/data/repositories/gifts_repository_impl.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/notifications/data/repositories/notifications_repository_impl.dart';
import '../../features/orders/data/repositories/orders_repository_impl.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/store/data/repositories/store_repository_impl.dart';
import '../../features/wallet/data/repositories/wallet_repository_impl.dart';

// Router wiring
import '../../app/router/app_router.dart';

final sl = GetIt.instance;

class Injection {
  Injection._();

  static Future<void> configure() async {
    // ── Layer 0: Platform init ───────────────────────────────────────────────

    // TODO: add google-services.json then restore Firebase.initializeApp() here

    // Hive local persistence (cart + gift drafts)
    await Hive.initFlutter();

    // ── Layer 1: Core infrastructure ─────────────────────────────────────────

    // Secure token storage (iOS Keychain / Android Keystore — FR-AUTH-007)
    sl.registerLazySingleton<SecureStorage>(() => FlutterSecureStorageImpl());

    // Session coordinator — manages access/refresh tokens and auth state
    // Registered as both concrete type and interface so AuthRepositoryImpl
    // can call onLoginSuccess/onGuestConverted without downcasting.
    final session = SessionCoordinatorImpl(storage: sl<SecureStorage>());
    await session.restoreSession(); // rehydrate tokens from Keychain at startup
    sl.registerSingleton<SessionCoordinatorImpl>(session);
    sl.registerSingleton<SessionCoordinator>(session);

    // Dio-backed API client with auth interceptor + retry (FR-AUTH-008)
    sl.registerLazySingleton<ApiClient>(
      () => DioApiClient(session: sl<SessionCoordinator>()),
    );

    // Analytics (Firebase Analytics — FR-13)
    sl.registerLazySingleton<AnalyticsService>(() => FirebaseAnalyticsServiceImpl());

    // Crash reporting (Firebase Crashlytics — FR-12.1)
    sl.registerLazySingleton<CrashReporter>(() => FirebaseCrashReporterImpl());

    // ── Layer 2: Cross-feature services ──────────────────────────────────────

    // Push notifications (FCM — FR-NOT-005)
    sl.registerLazySingleton<PushNotificationService>(
      () => FirebasePushNotificationServiceImpl(),
    );

    // Image upload (compress → strip EXIF → multipart — FR-GIFT-006)
    sl.registerLazySingleton<UploadManager>(() => FlutterUploadManagerImpl());

    // Gift draft persistence (Hive JSON — FR-GIFT-007)
    final draftRepo = HiveDraftRepositoryImpl();
    await draftRepo.init();
    sl.registerSingleton<DraftRepository>(draftRepo);

    // Deep link coordinator (URI validation + typed events — FR-12.3)
    sl.registerLazySingleton<DeepLinkCoordinator>(() => AppDeepLinkCoordinator());

    // ── Layer 3: Feature repositories ────────────────────────────────────────

    // Auth
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        api: sl<ApiClient>(),
        session: sl<SessionCoordinatorImpl>(),
      ),
    );

    // Home / dashboard
    sl.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(api: sl<ApiClient>()),
    );

    // Gifts (creation, sending, history, ideas)
    sl.registerLazySingleton<GiftsRepository>(
      () => GiftsRepositoryImpl(
        api: sl<ApiClient>(),
        uploader: sl<UploadManager>(),
      ),
    );

    // Airtime pools
    sl.registerLazySingleton<AirtimeRepository>(
      () => AirtimeRepositoryImpl(api: sl<ApiClient>()),
    );

    // Store (products, categories, reviews, suggestions)
    sl.registerLazySingleton<StoreRepository>(
      () => StoreRepositoryImpl(api: sl<ApiClient>()),
    );

    // Cart (Hive-persisted + server calculation — FR-CART-003)
    final cartRepo = CartRepositoryImpl(api: sl<ApiClient>());
    await cartRepo.init();
    sl.registerSingleton<CartRepository>(cartRepo);

    // Checkout (delivery options, packaging, order creation)
    sl.registerLazySingleton<CheckoutRepository>(
      () => CheckoutRepositoryImpl(api: sl<ApiClient>()),
    );

    // Orders (list, detail, tracking, cancel)
    sl.registerLazySingleton<OrdersRepository>(
      () => OrdersRepositoryImpl(api: sl<ApiClient>()),
    );

    // Celebrations (reminders, scheduling)
    sl.registerLazySingleton<CelebrationsRepository>(
      () => CelebrationsRepositoryImpl(api: sl<ApiClient>()),
    );

    // Wallet (balance, funding, withdrawals, KYC — FR-WALL-*)
    sl.registerLazySingleton<WalletRepository>(
      () => WalletRepositoryImpl(api: sl<ApiClient>()),
    );

    // Notifications (list, unread count, preferences — FR-NOT-*)
    sl.registerLazySingleton<NotificationsRepository>(
      () => NotificationsRepositoryImpl(api: sl<ApiClient>()),
    );

    // Profile (user info, avatar, settings — FR-PRO-*)
    sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(
        api: sl<ApiClient>(),
        uploadManager: sl<UploadManager>(),
      ),
    );

    // ── Layer 4: Router wiring ────────────────────────────────────────────────

    // Restore onboarded flag and initial auth state into AuthNotifier before
    // runApp() so the GoRouter redirect guard sees the correct values on first
    // evaluation. setOnboarded() will persist future changes automatically.
    final prefs = await SharedPreferences.getInstance();
    // Always show onboarding on every launch (FR-MOB-002).
    // The stored 'has_onboarded' flag is intentionally ignored so the splash
    // guard routes to onboarding regardless of prior sessions.
    authNotifier.init(
      prefs: prefs,
      authenticated: sl<SessionCoordinatorImpl>().isAuthenticated,
      onboarded: false,
    );

    // Connect AuthNotifier (go_router refreshListenable) to real session state.
    // When SessionCoordinatorImpl fires auth state changes, the router
    // re-evaluates its redirect guard automatically.
    sl<SessionCoordinatorImpl>().addListener((authenticated) {
      authNotifier.setAuthenticated(authenticated);
    });
  }
}
