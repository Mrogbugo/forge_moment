// Generic paginated response wrapper — used across gifts, orders, transactions, notifications
class PaginatedResponse<T> {
  final List<T> items;
  final int total;
  final int page;
  final int pageSize;
  final bool hasMore;

  const PaginatedResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromItem,
  ) =>
      PaginatedResponse(
        items: (json['items'] as List? ?? []).map((e) => fromItem(e as Map<String, dynamic>)).toList(),
        total: json['total'] ?? 0,
        page: json['page'] ?? 1,
        pageSize: json['page_size'] ?? 20,
        hasMore: json['has_more'] ?? false,
      );
}
