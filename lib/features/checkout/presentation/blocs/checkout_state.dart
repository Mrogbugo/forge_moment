part of 'checkout_bloc.dart';

enum CheckoutStep { delivery, packaging, review, payment, success }

class CheckoutState extends Equatable {
  final CheckoutStep step;
  final List<Map<String, dynamic>> deliveryOptions;
  final List<Map<String, dynamic>> packagingOptions;
  final Map<String, dynamic>? selectedDeliveryOption;
  final Map<String, dynamic>? selectedPackagingOption;
  final Map<String, dynamic>? address;
  final String? recipientName;
  final String? recipientPhone;
  final String? cardMessage;
  final Map<String, dynamic>? placedOrder;
  final bool isLoading;
  final String? errorMessage;

  const CheckoutState({
    required this.step,
    required this.deliveryOptions,
    required this.packagingOptions,
    required this.selectedDeliveryOption,
    required this.selectedPackagingOption,
    required this.address,
    required this.recipientName,
    required this.recipientPhone,
    required this.cardMessage,
    required this.placedOrder,
    required this.isLoading,
    required this.errorMessage,
  });

  factory CheckoutState.initial() => const CheckoutState(
        step: CheckoutStep.delivery,
        deliveryOptions: [],
        packagingOptions: [],
        selectedDeliveryOption: null,
        selectedPackagingOption: null,
        address: null,
        recipientName: null,
        recipientPhone: null,
        cardMessage: null,
        placedOrder: null,
        isLoading: false,
        errorMessage: null,
      );

  CheckoutState copyWith({
    CheckoutStep? step,
    List<Map<String, dynamic>>? deliveryOptions,
    List<Map<String, dynamic>>? packagingOptions,
    Object? selectedDeliveryOption = _chkSentinel,
    Object? selectedPackagingOption = _chkSentinel,
    Object? address = _chkSentinel,
    Object? recipientName = _chkSentinel,
    Object? recipientPhone = _chkSentinel,
    Object? cardMessage = _chkSentinel,
    Object? placedOrder = _chkSentinel,
    bool? isLoading,
    Object? errorMessage = _chkSentinel,
  }) {
    return CheckoutState(
      step: step ?? this.step,
      deliveryOptions: deliveryOptions ?? this.deliveryOptions,
      packagingOptions: packagingOptions ?? this.packagingOptions,
      selectedDeliveryOption: selectedDeliveryOption == _chkSentinel
          ? this.selectedDeliveryOption
          : selectedDeliveryOption as Map<String, dynamic>?,
      selectedPackagingOption: selectedPackagingOption == _chkSentinel
          ? this.selectedPackagingOption
          : selectedPackagingOption as Map<String, dynamic>?,
      address: address == _chkSentinel ? this.address : address as Map<String, dynamic>?,
      recipientName: recipientName == _chkSentinel ? this.recipientName : recipientName as String?,
      recipientPhone: recipientPhone == _chkSentinel ? this.recipientPhone : recipientPhone as String?,
      cardMessage: cardMessage == _chkSentinel ? this.cardMessage : cardMessage as String?,
      placedOrder: placedOrder == _chkSentinel ? this.placedOrder : placedOrder as Map<String, dynamic>?,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage == _chkSentinel ? this.errorMessage : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
        step, deliveryOptions, packagingOptions, selectedDeliveryOption,
        selectedPackagingOption, address, recipientName, recipientPhone,
        cardMessage, placedOrder, isLoading, errorMessage,
      ];
}

const Object _chkSentinel = Object();
