import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/gift.dart';
import '../../domain/repositories/gifts_repository.dart';

part 'gift_creation_event.dart';
part 'gift_creation_state.dart';

class GiftCreationBloc extends Bloc<GiftCreationEvent, GiftCreationState> {
  final GiftsRepository _repository;

  GiftCreationBloc({required GiftsRepository repository})
      : _repository = repository,
        super(const GiftCreationState.initial()) {
    on<GiftCreationStarted>(_onStarted);
    on<GiftTemplateSelected>(_onTemplateSelected);
    on<GiftMessageUpdated>(_onMessageUpdated);
    on<GiftMonetaryAmountSet>(_onMonetaryAmountSet);
    on<GiftMediaAdded>(_onMediaAdded);
    on<GiftMediaRemoved>(_onMediaRemoved);
    on<GiftMusicSelected>(_onMusicSelected);
    on<GiftAnonymousToggled>(_onAnonymousToggled);
    on<GiftRecipientSet>(_onRecipientSet);
    on<GiftDraftSaved>(_onDraftSaved);
    on<GiftPaymentInitiated>(_onPaymentInitiated);
    on<GiftPaymentVerified>(_onPaymentVerified);
    on<GiftCreationReset>(_onReset);
  }

  Future<void> _onStarted(GiftCreationStarted event, Emitter<GiftCreationState> emit) async {
    // TODO: implement
  }

  void _onTemplateSelected(GiftTemplateSelected event, Emitter<GiftCreationState> emit) {
    // TODO: implement
  }

  void _onMessageUpdated(GiftMessageUpdated event, Emitter<GiftCreationState> emit) {
    // TODO: implement
  }

  void _onMonetaryAmountSet(GiftMonetaryAmountSet event, Emitter<GiftCreationState> emit) {
    // TODO: implement
  }

  Future<void> _onMediaAdded(GiftMediaAdded event, Emitter<GiftCreationState> emit) async {
    // TODO: implement
  }

  Future<void> _onMediaRemoved(GiftMediaRemoved event, Emitter<GiftCreationState> emit) async {
    // TODO: implement
  }

  void _onMusicSelected(GiftMusicSelected event, Emitter<GiftCreationState> emit) {
    // TODO: implement
  }

  void _onAnonymousToggled(GiftAnonymousToggled event, Emitter<GiftCreationState> emit) {
    // TODO: implement
  }

  void _onRecipientSet(GiftRecipientSet event, Emitter<GiftCreationState> emit) {
    // TODO: implement
  }

  Future<void> _onDraftSaved(GiftDraftSaved event, Emitter<GiftCreationState> emit) async {
    // TODO: implement
  }

  Future<void> _onPaymentInitiated(GiftPaymentInitiated event, Emitter<GiftCreationState> emit) async {
    // TODO: implement
  }

  Future<void> _onPaymentVerified(GiftPaymentVerified event, Emitter<GiftCreationState> emit) async {
    // TODO: implement
  }

  void _onReset(GiftCreationReset event, Emitter<GiftCreationState> emit) {
    emit(const GiftCreationState.initial());
  }
}
