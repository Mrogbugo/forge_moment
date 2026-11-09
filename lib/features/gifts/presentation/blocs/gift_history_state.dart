part of 'gift_history_cubit.dart';

enum GiftHistoryTab { sent, received, ideas }

class GiftHistoryState extends Equatable {
  final GiftHistoryTab activeTab;
  final List<Map<String, dynamic>> sentGifts;
  final List<Map<String, dynamic>> receivedGifts;
  final List<Map<String, dynamic>> ideas;
  final bool isLoading;
  final bool hasMore;
  final int currentPage;
  final String? errorMessage;

  const GiftHistoryState({
    required this.activeTab,
    required this.sentGifts,
    required this.receivedGifts,
    required this.ideas,
    required this.isLoading,
    required this.hasMore,
    required this.currentPage,
    this.errorMessage,
  });

  const GiftHistoryState.initial()
      : activeTab = GiftHistoryTab.sent,
        sentGifts = const [],
        receivedGifts = const [],
        ideas = const [],
        isLoading = false,
        hasMore = true,
        currentPage = 1,
        errorMessage = null;

  GiftHistoryState copyWith({
    GiftHistoryTab? activeTab,
    List<Map<String, dynamic>>? sentGifts,
    List<Map<String, dynamic>>? receivedGifts,
    List<Map<String, dynamic>>? ideas,
    bool? isLoading,
    bool? hasMore,
    int? currentPage,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return GiftHistoryState(
      activeTab: activeTab ?? this.activeTab,
      sentGifts: sentGifts ?? this.sentGifts,
      receivedGifts: receivedGifts ?? this.receivedGifts,
      ideas: ideas ?? this.ideas,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        activeTab,
        sentGifts,
        receivedGifts,
        ideas,
        isLoading,
        hasMore,
        currentPage,
        errorMessage,
      ];
}
