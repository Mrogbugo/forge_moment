part of 'checkout_bloc.dart';

sealed class CheckoutEvent extends Equatable {
  const CheckoutEvent();
}

final class CheckoutStarted extends CheckoutEvent {
  final Map<String, dynamic> cartPayload;
  const CheckoutStarted({required this.cartPayload});
  @override
  List<Object?> get props => [cartPayload];
}

final class CheckoutDeliveryOptionSelected extends CheckoutEvent {
  final Map<String, dynamic> option;
  const CheckoutDeliveryOptionSelected({required this.option});
  @override
  List<Object?> get props => [option];
}

final class CheckoutPackagingOptionSelected extends CheckoutEvent {
  final Map<String, dynamic>? option;
  const CheckoutPackagingOptionSelected({required this.option});
  @override
  List<Object?> get props => [option];
}

final class CheckoutAddressSet extends CheckoutEvent {
  final Map<String, dynamic> address;
  const CheckoutAddressSet({required this.address});
  @override
  List<Object?> get props => [address];
}

final class CheckoutRecipientSet extends CheckoutEvent {
  final String name;
  final String phone;
  const CheckoutRecipientSet({required this.name, required this.phone});
  @override
  List<Object?> get props => [name, phone];
}

final class CheckoutMessageSet extends CheckoutEvent {
  final String? message;
  const CheckoutMessageSet({required this.message});
  @override
  List<Object?> get props => [message];
}

final class CheckoutOrderPlaced extends CheckoutEvent {
  const CheckoutOrderPlaced();
  @override
  List<Object?> get props => [];
}

final class CheckoutPaymentVerified extends CheckoutEvent {
  final String orderId;
  final String reference;
  const CheckoutPaymentVerified({required this.orderId, required this.reference});
  @override
  List<Object?> get props => [orderId, reference];
}

final class CheckoutReset extends CheckoutEvent {
  const CheckoutReset();
  @override
  List<Object?> get props => [];
}
