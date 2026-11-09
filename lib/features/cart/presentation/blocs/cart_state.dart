part of 'cart_cubit.dart';

class CartState extends Equatable {
  final Cart? cart;
  final bool isLoading;
  final String? errorMessage;
  final Map<String, dynamic>? calculation;

  const CartState({
    required this.cart,
    required this.isLoading,
    required this.errorMessage,
    required this.calculation,
  });

  factory CartState.initial() => const CartState(
        cart: null,
        isLoading: false,
        errorMessage: null,
        calculation: null,
      );

  CartState copyWith({
    Object? cart = _cartSentinel,
    bool? isLoading,
    Object? errorMessage = _cartSentinel,
    Object? calculation = _cartSentinel,
  }) {
    return CartState(
      cart: cart == _cartSentinel ? this.cart : cart as Cart?,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage == _cartSentinel
          ? this.errorMessage
          : errorMessage as String?,
      calculation: calculation == _cartSentinel
          ? this.calculation
          : calculation as Map<String, dynamic>?,
    );
  }

  @override
  List<Object?> get props => [cart, isLoading, errorMessage, calculation];
}

const Object _cartSentinel = Object();
