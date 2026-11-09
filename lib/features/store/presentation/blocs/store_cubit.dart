import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/product.dart';
import '../../domain/repositories/store_repository.dart';

part 'store_state.dart';

class StoreCubit extends Cubit<StoreState> {
  final StoreRepository _repository;

  StoreCubit({required StoreRepository repository})
      : _repository = repository,
        super(StoreState.initial());

  Future<void> loadCategories() async {
    // TODO: implement
  }

  Future<void> loadProducts({bool refresh = false}) async {
    // TODO: implement
  }

  Future<void> loadMore() async {
    // TODO: implement
  }

  void selectCategory(String? categoryId) {
    // TODO: implement
  }

  void search(String query) {
    // TODO: implement
  }

  void applyFilters({
    double? minPrice,
    double? maxPrice,
    bool? sameDayOnly,
    bool? featuredOnly,
    String? sortBy,
    String? sortOrder,
  }) {
    // TODO: implement
  }

  void clearFilters() {
    // TODO: implement
  }

  Future<void> loadProductDetail(String productId) async {
    // TODO: implement
  }

  Future<void> loadReviews(String productId) async {
    // TODO: implement
  }

  Future<void> submitReview(String productId, Map<String, dynamic> payload) async {
    // TODO: implement
  }
}
