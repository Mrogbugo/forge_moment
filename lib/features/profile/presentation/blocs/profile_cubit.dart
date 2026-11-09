import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/profile_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;

  ProfileCubit({required ProfileRepository repository})
      : _repository = repository,
        super(ProfileState.initial());

  Future<void> loadProfile() async {
    // TODO: implement
  }

  Future<void> updateProfile(Map<String, dynamic> payload) async {
    // TODO: implement
  }

  Future<void> uploadAvatar(String localPath) async {
    // TODO: implement
  }

  Future<void> loadSettings() async {
    // TODO: implement
  }

  Future<void> updateSettings(Map<String, dynamic> settings) async {
    // TODO: implement
  }
}
