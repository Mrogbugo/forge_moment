part of 'celebrations_cubit.dart';

class CelebrationsState extends Equatable {
  final List<Celebration> celebrations;
  final List<Celebration> upcoming;
  final bool isLoading;
  final bool hasMore;
  final int currentPage;
  final String? errorMessage;

  const CelebrationsState({
    this.celebrations = const [],
    this.upcoming = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.errorMessage,
  });

  factory CelebrationsState.initial() => const CelebrationsState();

  CelebrationsState copyWith({
    List<Celebration>? celebrations,
    List<Celebration>? upcoming,
    bool? isLoading,
    bool? hasMore,
    int? currentPage,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CelebrationsState(
      celebrations: celebrations ?? this.celebrations,
      upcoming: upcoming ?? this.upcoming,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        celebrations,
        upcoming,
        isLoading,
        hasMore,
        currentPage,
        errorMessage,
      ];
}
