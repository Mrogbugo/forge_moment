// Gift status values per FR-HIST-003
enum GiftStatus {
  draft,
  pendingPayment,
  scheduled,
  sent,
  viewed,
  claimed,
  expired,
  cancelled,
  failed,
}

// Delivery method options per FR-GIFT-015
enum DeliveryMethod { whatsapp, email, sms }

class Gift {
  final String id;
  final String? templateId;
  final String? message;
  final List<String> mediaUrls;
  final String? musicTrackId;
  final double? monetaryAmount;
  final bool anonymous;
  final String? recipientName;
  final String? recipientContact;
  final DeliveryMethod? deliveryMethod;
  final GiftStatus status;
  final String? publicLink;
  final DateTime createdAt;
  final DateTime? sentAt;

  const Gift({
    required this.id,
    this.templateId,
    this.message,
    this.mediaUrls = const [],
    this.musicTrackId,
    this.monetaryAmount,
    this.anonymous = false,
    this.recipientName,
    this.recipientContact,
    this.deliveryMethod,
    required this.status,
    this.publicLink,
    required this.createdAt,
    this.sentAt,
  });
}
