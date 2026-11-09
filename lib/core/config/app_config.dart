import 'feature_flags.dart';

// Runtime config loaded from backend bootstrap endpoint (FR-10.2)
// Covers: support contacts, policy URLs, limits, payment channels, feature flags
class AppConfig {
  final FeatureFlags featureFlags;
  final String supportPhone;
  final String supportEmail;
  final String termsUrl;
  final String privacyUrl;
  final int maxGiftMediaCount;
  final int maxGiftMessageLength;
  final int maxInscriptionLength;

  const AppConfig({
    this.featureFlags = const FeatureFlags(),
    this.supportPhone = '',
    this.supportEmail = '',
    this.termsUrl = '',
    this.privacyUrl = '',
    this.maxGiftMediaCount = 5,
    this.maxGiftMessageLength = 1000,
    this.maxInscriptionLength = 80,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) => AppConfig(
        featureFlags: FeatureFlags.fromJson(json['feature_flags'] ?? {}),
        supportPhone: json['support_phone'] ?? '',
        supportEmail: json['support_email'] ?? '',
        termsUrl: json['terms_url'] ?? '',
        privacyUrl: json['privacy_url'] ?? '',
        maxGiftMediaCount: json['max_gift_media_count'] ?? 5,
        maxGiftMessageLength: json['max_gift_message_length'] ?? 1000,
        maxInscriptionLength: json['max_inscription_length'] ?? 80,
      );
}
