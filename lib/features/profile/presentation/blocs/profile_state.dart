part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final Map<String, dynamic>? profile;
  final Map<String, dynamic>? settings;
  final bool isLoadingProfile;
  final bool isLoadingSettings;
  final bool isUploadingAvatar;
  final double avatarUploadProgress;
  final String? errorMessage;

  const ProfileState({
    this.profile,
    this.settings,
    this.isLoadingProfile = false,
    this.isLoadingSettings = false,
    this.isUploadingAvatar = false,
    this.avatarUploadProgress = 0.0,
    this.errorMessage,
  });

  factory ProfileState.initial() => const ProfileState();

  ProfileState copyWith({
    Map<String, dynamic>? profile,
    Map<String, dynamic>? settings,
    bool? isLoadingProfile,
    bool? isLoadingSettings,
    bool? isUploadingAvatar,
    double? avatarUploadProgress,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      settings: settings ?? this.settings,
      isLoadingProfile: isLoadingProfile ?? this.isLoadingProfile,
      isLoadingSettings: isLoadingSettings ?? this.isLoadingSettings,
      isUploadingAvatar: isUploadingAvatar ?? this.isUploadingAvatar,
      avatarUploadProgress: avatarUploadProgress ?? this.avatarUploadProgress,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        profile,
        settings,
        isLoadingProfile,
        isLoadingSettings,
        isUploadingAvatar,
        avatarUploadProgress,
        errorMessage,
      ];
}
