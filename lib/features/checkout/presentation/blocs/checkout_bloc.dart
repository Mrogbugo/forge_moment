import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/repositories/checkout_repository.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutRepository _repository;

  CheckoutBloc({required CheckoutRepository repository})
      : _repository = repository,
        super(CheckoutState.initial()) {
    on<CheckoutStarted>(_onStarted);
    on<CheckoutDeliveryOptionSelected>(_onDeliveryOptionSelected);
    on<CheckoutPackagingOptionSelected>(_onPackagingOptionSelected);
    on<CheckoutAddressSet>(_onAddressSet);
    on<CheckoutRecipientSet>(_onRecipientSet);
    on<CheckoutMessageSet>(_onMessageSet);
    on<CheckoutOrderPlaced>(_onOrderPlaced);
    on<CheckoutPaymentVerified>(_onPaymentVerified);
    on<CheckoutReset>(_onReset);
  }

  Future<void> _onStarted(CheckoutStarted event, Emitter<CheckoutState> emit) async {
    // TODO: implement
  }

  void _onDeliveryOptionSelected(CheckoutDeliveryOptionSelected event, Emitter<CheckoutState> emit) {
    // TODO: implement
  }

  void _onPackagingOptionSelected(CheckoutPackagingOptionSelected event, Emitter<CheckoutState> emit) {
    // TODO: implement
  }

  void _onAddressSet(CheckoutAddressSet event, Emitter<CheckoutState> emit) {
    // TODO: implement
  }

  void _onRecipientSet(CheckoutRecipientSet event, Emitter<CheckoutState> emit) {
    // TODO: implement
  }

  void _onMessageSet(CheckoutMessageSet event, Emitter<CheckoutState> emit) {
    // TODO: implement
  }

  Future<void> _onOrderPlaced(CheckoutOrderPlaced event, Emitter<CheckoutState> emit) async {
    // TODO: implement
  }

  Future<void> _onPaymentVerified(CheckoutPaymentVerified event, Emitter<CheckoutState> emit) async {
    // TODO: implement
  }

  void _onReset(CheckoutReset event, Emitter<CheckoutState> emit) {
    emit(CheckoutState.initial());
  }
}
