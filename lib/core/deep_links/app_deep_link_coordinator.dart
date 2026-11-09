import 'dart:async';
import 'deep_link_coordinator.dart';

/// Processes incoming URIs (from go_router callbacks or platform channels)
/// and emits typed [DeepLinkEvent]s to subscribers.
///
/// URI validation (FR-12.3 security): only recognised path patterns on
/// allowed hosts are dispatched; anything else is silently dropped.
class AppDeepLinkCoordinator implements DeepLinkCoordinator {
  // Allowed hosts for deep links — prevent open-redirect attacks
  static const _allowedHosts = {'forgemoments.com', 'www.forgemoments.com', 'localhost'};

  final _controller = StreamController<DeepLinkEvent>.broadcast();

  @override
  Stream<DeepLinkEvent> get events => _controller.stream;

  @override
  Future<void> initialize() async {
    // go_router handles the platform-level deep-link routing.
    // This coordinator receives pre-parsed URIs from route builders
    // (e.g. _CallbackPage, _PublicGiftRedirectPage) via [handleUri].
  }

  @override
  Future<void> handleUri(Uri uri) async {
    // Validate host (skip for local dev / universal links)
    if (uri.host.isNotEmpty && !_allowedHosts.contains(uri.host)) return;

    final path = uri.path;
    final params = uri.queryParameters;

    final event = _classify(path, params, uri);
    if (event != null) _controller.add(event);
  }

  DeepLinkEvent? _classify(
    String path,
    Map<String, String> params,
    Uri uri,
  ) {
    // /auth/callback — Google OAuth or OTP return
    if (path == '/auth/callback') return AuthCallbackEvent(uri);

    // /payment/callback — Paystack return; reference is mandatory
    if (path == '/payment/callback') {
      final ref = params['reference'] ?? params['trxref'];
      if (ref != null) return PaymentCallbackEvent(ref);
      return null; // malformed — drop
    }

    // /gift/:id
    final giftMatch = RegExp(r'^/gift/([^/]+)$').firstMatch(path);
    if (giftMatch != null) return GiftLinkEvent(giftMatch.group(1)!);

    // /airtime/:id
    final airtimeMatch = RegExp(r'^/airtime/([^/]+)$').firstMatch(path);
    if (airtimeMatch != null) return AirtimeLinkEvent(airtimeMatch.group(1)!);

    // /store/:productId (product deep-link, FR-MOB-006)
    final productMatch = RegExp(r'^/store/([^/]+)$').firstMatch(path);
    if (productMatch != null) return ProductLinkEvent(productMatch.group(1)!);

    // /order/:id
    final orderMatch = RegExp(r'^/order/([^/]+)$').firstMatch(path);
    if (orderMatch != null) return OrderLinkEvent(orderMatch.group(1)!);

    // /notification/:id
    final notifMatch = RegExp(r'^/notification/([^/]+)$').firstMatch(path);
    if (notifMatch != null) return NotificationLinkEvent(notifMatch.group(1)!);

    return null; // unrecognised path
  }

  void dispose() => _controller.close();
}
