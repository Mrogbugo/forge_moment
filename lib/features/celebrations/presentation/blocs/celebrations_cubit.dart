import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/celebration.dart';
import '../../domain/repositories/celebrations_repository.dart';

part 'celebrations_state.dart';

class CelebrationsCubit extends Cubit<CelebrationsState> {
  final CelebrationsRepository _repository;

  CelebrationsCubit({required CelebrationsRepository repository})
      : _repository = repository,
        super(CelebrationsState.initial());

  Future<void> loadCelebrations({bool refresh = false}) async {
    // TODO: implement
  }

  Future<void> loadMore() async {
    // TODO: implement
  }

  Future<void> loadUpcoming() async {
    // TODO: implement
  }

  Future<void> addCelebration(Map<String, dynamic> payload) async {
    // TODO: implement
  }

  Future<void> updateCelebration(String id, Map<String, dynamic> payload) async {
    // TODO: implement
  }

  Future<void> deleteCelebration(String id) async {
    // TODO: implement
  }

  Future<void> scheduleGift(String celebrationId, Map<String, dynamic> payload) async {
    // TODO: implement
  }
}
