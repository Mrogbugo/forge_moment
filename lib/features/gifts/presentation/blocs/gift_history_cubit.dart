import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/gifts_repository.dart';

part 'gift_history_state.dart';

class GiftHistoryCubit extends Cubit<GiftHistoryState> {
  final GiftsRepository _repository;

  GiftHistoryCubit({required GiftsRepository repository})
      : _repository = repository,
        super(const GiftHistoryState.initial());

  void switchTab(GiftHistoryTab tab) {
    // TODO: implement
  }

  Future<void> loadSent() async {
    // TODO: implement
  }

  Future<void> loadMoreSent() async {
    // TODO: implement
  }

  Future<void> loadReceived() async {
    // TODO: implement
  }

  Future<void> loadMoreReceived() async {
    // TODO: implement
  }

  Future<void> loadIdeas() async {
    // TODO: implement
  }
}
