part of 'store_cubit.dart';

class StoreState extends Equatable {
  final List<Map<String, dynamic>> categories;
  final String? selectedCategoryId;
  final List<Product> products;
  final bool isLoadingProducts;
  final bool isLoadingCategories;
  final bool hasMore;
  final int currentPage;
  final String? searchQuery;
  final double? minPrice;
  final double? maxPrice;
  final bool sameDayOnly;
  final bool featuredOnly;
  final String? sortBy;
  final String? sortOrder;
  final String? errorMessage;
  final Product? selectedProduct;
  final bool isLoadingDetail;
  final List<Map<String, dynamic>> reviews;
  final bool isLoadingReviews;

  const StoreState({
    required this.categories,
    required this.selectedCategoryId,
    required this.products,
    required this.isLoadingProducts,
    required this.isLoadingCategories,
    required this.hasMore,
    required this.currentPage,
    required this.searchQuery,
    required this.minPrice,
    required this.maxPrice,
    required this.sameDayOnly,
    required this.featuredOnly,
    required this.sortBy,
    required this.sortOrder,
    required this.errorMessage,
    required this.selectedProduct,
    required this.isLoadingDetail,
    required this.reviews,
    required this.isLoadingReviews,
  });

  factory StoreState.initial() => const StoreState(
        categories: [],
        selectedCategoryId: null,
        products: [],
        isLoadingProducts: false,
        isLoadingCategories: false,
        hasMore: true,
        currentPage: 1,
        searchQuery: null,
        minPrice: null,
        maxPrice: null,
        sameDayOnly: false,
        featuredOnly: false,
        sortBy: null,
        sortOrder: null,
        errorMessage: null,
        selectedProduct: null,
        isLoadingDetail: false,
        reviews: [],
        isLoadingReviews: false,
      );

  StoreState copyWith({
    List<Map<String, dynamic>>? categories,
    Object? selectedCategoryId = _sentinel,
    List<Product>? products,
    bool? isLoadingProducts,
    bool? isLoadingCategories,
    bool? hasMore,
    int? currentPage,
    Object? searchQuery = _sentinel,
    Object? minPrice = _sentinel,
    Object? maxPrice = _sentinel,
    bool? sameDayOnly,
    bool? featuredOnly,
    Object? sortBy = _sentinel,
    Object? sortOrder = _sentinel,
    Object? errorMessage = _sentinel,
    Object? selectedProduct = _sentinel,
    bool? isLoadingDetail,
    List<Map<String, dynamic>>? reviews,
    bool? isLoadingReviews,
  }) {
    return StoreState(
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId == _sentinel
          ? this.selectedCategoryId
          : selectedCategoryId as String?,
      products: products ?? this.products,
      isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      searchQuery: searchQuery == _sentinel ? this.searchQuery : searchQuery as String?,
      minPrice: minPrice == _sentinel ? this.minPrice : minPrice as double?,
      maxPrice: maxPrice == _sentinel ? this.maxPrice : maxPrice as double?,
      sameDayOnly: sameDayOnly ?? this.sameDayOnly,
      featuredOnly: featuredOnly ?? this.featuredOnly,
      sortBy: sortBy == _sentinel ? this.sortBy : sortBy as String?,
      sortOrder: sortOrder == _sentinel ? this.sortOrder : sortOrder as String?,
      errorMessage: errorMessage == _sentinel ? this.errorMessage : errorMessage as String?,
      selectedProduct: selectedProduct == _sentinel
          ? this.selectedProduct
          : selectedProduct as Product?,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      reviews: reviews ?? this.reviews,
      isLoadingReviews: isLoadingReviews ?? this.isLoadingReviews,
    );
  }

  @override
  List<Object?> get props => [
        categories, selectedCategoryId, products, isLoadingProducts,
        isLoadingCategories, hasMore, currentPage, searchQuery,
        minPrice, maxPrice, sameDayOnly, featuredOnly, sortBy, sortOrder,
        errorMessage, selectedProduct, isLoadingDetail, reviews, isLoadingReviews,
      ];
}

const Object _sentinel = Object();
