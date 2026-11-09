import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/home_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;

  HomeCubit({required HomeRepository repository})
      : _repository = repository,
        super(HomeState.initial());

  Future<void> loadDashboard() async {
    // TODO: implement
  }

  Future<void> refresh() => loadDashboard();
}
