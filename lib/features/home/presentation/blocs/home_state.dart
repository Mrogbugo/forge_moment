part of 'home_cubit.dart';

class HomeState extends Equatable {
  final Map<String, dynamic>? dashboard;
  final List<Map<String, dynamic>> recommendations;
  final bool isLoading;
  final String? errorMessage;

  const HomeState({
    this.dashboard,
    this.recommendations = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  factory HomeState.initial() => const HomeState();

  HomeState copyWith({
    Map<String, dynamic>? dashboard,
    List<Map<String, dynamic>>? recommendations,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HomeState(
      dashboard: dashboard ?? this.dashboard,
      recommendations: recommendations ?? this.recommendations,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [dashboard, recommendations, isLoading, errorMessage];
}
