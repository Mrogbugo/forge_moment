part of 'gift_creation_bloc.dart';

sealed class GiftCreationEvent extends Equatable {
  const GiftCreationEvent();

  @override
  List<Object?> get props => [];
}

class GiftCreationStarted extends GiftCreationEvent {
  const GiftCreationStarted();
}

class GiftTemplateSelected extends GiftCreationEvent {
  final String templateId;
  final Map<String, dynamic> template;

  const GiftTemplateSelected({
    required this.templateId,
    required this.template,
  });

  @override
  List<Object?> get props => [templateId, template];
}

class GiftMessageUpdated extends GiftCreationEvent {
  final String message;

  const GiftMessageUpdated({required this.message});

  @override
  List<Object?> get props => [message];
}

class GiftMonetaryAmountSet extends GiftCreationEvent {
  final double amount;

  const GiftMonetaryAmountSet({required this.amount});

  @override
  List<Object?> get props => [amount];
}

class GiftMediaAdded extends GiftCreationEvent {
  final String localPath;

  const GiftMediaAdded({required this.localPath});

  @override
  List<Object?> get props => [localPath];
}

class GiftMediaRemoved extends GiftCreationEvent {
  final String mediaUrl;

  const GiftMediaRemoved({required this.mediaUrl});

  @override
  List<Object?> get props => [mediaUrl];
}

class GiftMusicSelected extends GiftCreationEvent {
  final String? trackId;

  const GiftMusicSelected({required this.trackId});

  @override
  List<Object?> get props => [trackId];
}

class GiftAnonymousToggled extends GiftCreationEvent {
  const GiftAnonymousToggled();
}

class GiftRecipientSet extends GiftCreationEvent {
  final String name;
  final String contact;
  final DeliveryMethod deliveryMethod;

  const GiftRecipientSet({
    required this.name,
    required this.contact,
    required this.deliveryMethod,
  });

  @override
  List<Object?> get props => [name, contact, deliveryMethod];
}

class GiftDraftSaved extends GiftCreationEvent {
  const GiftDraftSaved();
}

class GiftPaymentInitiated extends GiftCreationEvent {
  final String paymentMethod;

  const GiftPaymentInitiated({required this.paymentMethod});

  @override
  List<Object?> get props => [paymentMethod];
}

class GiftPaymentVerified extends GiftCreationEvent {
  final String reference;

  const GiftPaymentVerified({required this.reference});

  @override
  List<Object?> get props => [reference];
}

class GiftCreationReset extends GiftCreationEvent {
  const GiftCreationReset();
}
