import 'package:equatable/equatable.dart';

enum WishlistOccasion { birthday, anniversary, wedding, graduation, justBecause, milestone, secret }

enum WishlistItemType { product, cash }

class WishlistItem extends Equatable {
  final String id;
  final String name;
  final String vendorName;
  final double price;
  final String? imageUrl;
  final WishlistItemType type;
  final bool claimed;
  final String? claimedBy;
  final int quantity;
  final double? targetAmount;
  final double? contributedAmount;
  final int? contributorCount;
  final String? note;

  const WishlistItem({
    required this.id,
    required this.name,
    required this.vendorName,
    required this.price,
    this.imageUrl,
    required this.type,
    this.claimed = false,
    this.claimedBy,
    this.quantity = 1,
    this.targetAmount,
    this.contributedAmount,
    this.contributorCount,
    this.note,
  });

  @override
  List<Object?> get props => [id];
}

class Wishlist extends Equatable {
  final String id;
  final String title;
  final WishlistOccasion occasion;
  final DateTime? targetDate;
  final List<WishlistItem> items;
  final bool allowPartialContributions;
  final bool keepSurprisesSecret;
  final String? shareLink;
  final String? ownerName;
  final String? ownerAvatarUrl;
  final String? ownerNote;
  final String? deliveryCity;

  const Wishlist({
    required this.id,
    required this.title,
    required this.occasion,
    this.targetDate,
    required this.items,
    this.allowPartialContributions = true,
    this.keepSurprisesSecret = true,
    this.shareLink,
    this.ownerName,
    this.ownerAvatarUrl,
    this.ownerNote,
    this.deliveryCity,
  });

  double get totalValue =>
      items.fold(0, (sum, i) => sum + (i.targetAmount ?? i.price) * i.quantity);

  int get claimedCount => items.where((i) => i.claimed).length;

  double get fundedPercent =>
      items.isEmpty ? 0 : claimedCount / items.length;

  @override
  List<Object?> get props => [id];
}
