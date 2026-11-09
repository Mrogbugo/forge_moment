import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/wishlist.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class WishlistState extends Equatable {
  final List<Wishlist> wishlists;
  final String activeFilter;
  final bool isLoading;
  final String? errorMessage;

  const WishlistState({
    this.wishlists = const [],
    this.activeFilter = 'all',
    this.isLoading = false,
    this.errorMessage,
  });

  WishlistState copyWith({
    List<Wishlist>? wishlists,
    String? activeFilter,
    bool? isLoading,
    String? errorMessage,
  }) {
    return WishlistState(
      wishlists: wishlists ?? this.wishlists,
      activeFilter: activeFilter ?? this.activeFilter,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  List<Wishlist> get filtered {
    switch (activeFilter) {
      case 'birthday':
        return wishlists
            .where((w) => w.occasion == WishlistOccasion.birthday)
            .toList();
      case 'milestone':
        return wishlists
            .where((w) =>
                w.occasion == WishlistOccasion.anniversary ||
                w.occasion == WishlistOccasion.milestone)
            .toList();
      case 'secret':
        return wishlists
            .where((w) => w.occasion == WishlistOccasion.secret)
            .toList();
      case 'all':
      default:
        return wishlists;
    }
  }

  @override
  List<Object?> get props => [wishlists, activeFilter, isLoading, errorMessage];
}

// ---------------------------------------------------------------------------
// Mock data
// ---------------------------------------------------------------------------

final _mockWishlists = <Wishlist>[
  Wishlist(
    id: 'w1',
    title: "Sarah's 28th Birthday Soirée",
    occasion: WishlistOccasion.birthday,
    targetDate: DateTime(2025, 10, 12),
    items: const [
      WishlistItem(
        id: 'i1',
        name: 'Floral Brushstroke Cake',
        vendorName: 'Divinebakes',
        price: 24750,
        type: WishlistItemType.product,
        claimed: true,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuARhdWp-g4jc_oltvnT-L1kDICqA4DP_618ApsDDLMrjpnJ0qJvLYOGL7SGzPJR50g4xHhH_O-59jUzc-8nXZEHtdtgo5UicSRceaK6QnDf_Fw9OjhozrBV8Y035t5QRjYW0y1645qfTiVhQXyaR2MrLx6dMGf-KSDwlLl7UWfCHZG7bkrTebEt860YTBh6YS2EP9USBuNzI6Nz60KC2v58IhRt-eshABGXINAlmwCqc0dIQNIeTiB7PQ',
      ),
      WishlistItem(
        id: 'i2',
        name: 'Luxury Rose Box',
        vendorName: 'Rose Garden',
        price: 35000,
        type: WishlistItemType.product,
        claimed: true,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBHOLlym1V1rp8C4OaxJ-1vcKCxfygvfldkQSkPfEhcmHC00hkKRLII34uLcGZFoJYcVQJnTwJDsZXFDxYHXIybYS1M9y0bsJwC9bmLCPBC58wVdLqKOUbVcOnrIs1PNsEvyY2DdFtJ4dAOmfEy2AbHAvYIWha5TK1Uu1XoTw0v4ZbQc0ClzplFy-6uurvFIxpjUKM1PJBZvP-Y69i1Fd3Tzp0I1eWt5k1cvjc3_VFxjO0oCAl8EiT-jw',
      ),
      WishlistItem(
        id: 'i3',
        name: 'Cash Bouquet',
        vendorName: 'Forge Moments',
        price: 50000,
        type: WishlistItemType.cash,
        targetAmount: 50000,
        contributedAmount: 0,
      ),
      WishlistItem(
        id: 'i4',
        name: 'White Lilies',
        vendorName: 'Bloom Studio',
        price: 35250,
        type: WishlistItemType.product,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDjPO1vfj_OIk_6B4E2Hk7v8yh5BvB0QRVu0_7yyTPAVBjXcLcJ09u6wstR6kMlNpYv0emRlt4ODtjhKUGwLK0h_hGRdU6AElqi8vj-GPr5HcV6rIuygX8X_wYh7YqwdXKhktisuvqT0xqzLFdWdPhYGHWPjpihXVSqLbzwq8AT64TT_DUdX_1NDGnkObF-xsDtOZtD6dG1e_7pYIiTWZ__ObbZK0ZLSPAcuS-WbzqpUUrtvp3HJPJRkQ',
      ),
      WishlistItem(
        id: 'i8',
        name: 'Gold & Pearl Necklace',
        vendorName: 'GoldCraft NG',
        price: 120000,
        type: WishlistItemType.product,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuC2zI6D_Z2ViFCRN_3Nb4XIZRQRMIlO1_tgLP-y85ZHV4itfphT8qE2c7U2QnWwGUtt7wht8R0vGbM1STJZT8s0T76JovqXIuJDE7VzgH4Q3mSn3fPQPmj66fSTSd3X5TD7f4IEoUf8c8GLxdUPaBXPEQf6ztVT8iN4vYQAjDFi8BMBkh6uxTUdpfIuG_TPsuOnkKY5iIJlmvbuR2Si1BLHEgcO97R1THSBgFlFNEyiUa8kxWq6r1LeQQ',
      ),
      WishlistItem(
        id: 'i9',
        name: 'Spa Retreat',
        vendorName: 'Serene Wellness',
        price: 65000,
        type: WishlistItemType.product,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuA10NZlqWKpUZ7yF3BQpdK2QTiXj49cZkanWLWSg9mxfn6M27nNi2GI20AOzU0GMkFfVq-652UV6-4tdc0ipBOMEeuewlRl7n5EoFTgv61xFKD1SoeG6LmReKZaHCxXF5Gwt_KbTz8X1rJecn04B5_UAUOZKUI0OZJdFz0Bp7Yh_SMhDOFq3MYK9vDRsWIlLM4PGl-fCmunc9bJw3wnXPD823GoscMYYI8q1ZZOoK4h1bIOk7e93lPxjA',
      ),
      WishlistItem(
        id: 'i10',
        name: 'Artisan Truffles',
        vendorName: 'Choco Artisans',
        price: 45000,
        type: WishlistItemType.product,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAzyT65xUrPGO1-flw1shW8JtkPFJ1XsewoCp3gVhMUwOanU2yxGBisMUWCuZuK3qOFiHiQPcz9K48A0XsQcara57D9HzJP3nJanZhC8FGYC782Sj8wFEW8eW6TyjcBCfF6PWGsHCuQoQ_Y0hbb78vSpAvchZYqt_Q19NeWvd60Wq8tUXZfTlFyGL_S5ej7ih6VT7jtREVPEWC5pZvWZLHjkvF3bD4RNyUAHe5Qq4xtA6byNhdKNnFnrI7A',
      ),
      WishlistItem(
        id: 'i11',
        name: 'Eternal Bloom Roses',
        vendorName: 'LuxeBloom Lagos',
        price: 85000,
        type: WishlistItemType.product,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuADhfEk658rXrYh-IwmRaYplrbQgri60ziu1wm6h9cTjiPXjjDkRneIoP0MQZHtxwZvnk-2eNvhd71hufvf0-MUi28o8E8r5kAL7EfS-yXlONltU3JmMzR4PjR1k1AyUAI9Li8OLGcxWGb93iSmiS5eCKmMs-r8vl29QyBocNzrIgw6FZk3LrMT0OCPTdVB-gy1Z8aTxqXdvtHe8xmmBlm1ngru272cax04GvQ4PxAcpVqQSl1CGtUcGw',
      ),
    ],
  ),
  Wishlist(
    id: 'w2',
    title: 'Dream Home & Anniversary',
    occasion: WishlistOccasion.anniversary,
    targetDate: DateTime(2025, 11, 20),
    items: const [
      WishlistItem(
        id: 'i5',
        name: 'Designer Leather Valet Set',
        vendorName: 'Luxury Home',
        price: 35000,
        type: WishlistItemType.product,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBqOn1-tBM3H3autgRpo_YGKwVhLNTPgk40nAIkf_UJN2Wl0LMKLSOoAjbP0bGb0a72gMgSJMDnC7FwQMtj9aUZtZsnvli2DzZecSN_LvdLJ8bHN8-DI0y7_jxl4JQ3uTam_dsIPpApZX7sCpKdrRn-1xc13Qay3oPgK9FOogadLDmNw6fG8W-z-fuB8jg74976FtBNZOSbKwJzy8TrEsAEcSfFRSGKEnSTjvGJ-bff-cuaZytC8bCLAQ',
      ),
      WishlistItem(
        id: 'i6',
        name: 'Champagne & Gourmet Basket',
        vendorName: 'Gourmet Co.',
        price: 45000,
        type: WishlistItemType.product,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuA0wgtKm70yp0_axYoAZ1_mpLDXNhQgluOZzsy7KlSEVbmDfwGWmABbQJm-Np2FRG9s',
      ),
    ],
  ),
  const Wishlist(
    id: 'w3',
    title: 'Festive Cash Box & Airtime',
    occasion: WishlistOccasion.secret,
    items: [
      WishlistItem(
        id: 'i7',
        name: 'Festive Cash Pool',
        vendorName: 'Forge Moments',
        price: 100000,
        type: WishlistItemType.cash,
        targetAmount: 100000,
        contributedAmount: 60000,
        contributorCount: 3,
      ),
    ],
  ),
];

// ---------------------------------------------------------------------------
// Cubit
// ---------------------------------------------------------------------------

class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit() : super(const WishlistState());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    await Future<void>.delayed(const Duration(milliseconds: 400));
    emit(state.copyWith(
      isLoading: false,
      wishlists: _mockWishlists,
    ));
  }

  void setFilter(String filter) {
    emit(state.copyWith(activeFilter: filter));
  }
}
