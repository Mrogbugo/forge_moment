import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/orders_repository.dart';
import '../blocs/orders_cubit.dart';

class OrdersListPage extends StatelessWidget {
  const OrdersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          OrdersCubit(repository: GetIt.instance<OrdersRepository>())
            ..loadOrders(),
      child: const _OrdersView(),
    );
  }
}

class _OrdersView extends StatelessWidget {
  const _OrdersView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              _buildAppBar(context),
              if (state.errorMessage != null)
                SliverToBoxAdapter(
                  child: _ErrorBanner(message: state.errorMessage!),
                ),
              _buildBody(context, state),
            ],
          );
        },
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.surface.withAlpha(230),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: AppColors.onSurfaceVariant,
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(AppRoutes.activity);
          }
        },
      ),
      title: Text(
        'My Orders',
        style: AppTextStyles.bodyMd.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
      ),
      centerTitle: true,
      actions: [
        BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) => IconButton(
            icon: const Icon(Icons.refresh_rounded),
            color: AppColors.onSurfaceVariant,
            onPressed: state.isLoading
                ? null
                : () => context
                    .read<OrdersCubit>()
                    .loadOrders(refresh: true),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, OrdersState state) {
    if (state.isLoading && state.orders.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2.5,
          ),
        ),
      );
    }

    if (state.orders.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: _EmptyOrders(),
      );
    }

    final itemCount =
        state.orders.length + (state.hasMore ? 1 : 0);

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == state.orders.length) {
              // load-more indicator
              if (state.isLoading) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                );
              }
              // "Load more" button
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: OutlinedButton(
                    onPressed: () =>
                        context.read<OrdersCubit>().loadMore(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      'Load more',
                      style: AppTextStyles.labelMd.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              );
            }

            final order = state.orders[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _OrderCard(order: order),
            );
          },
          childCount: itemCount,
        ),
      ),
    );
  }
}

// ── Order Card ────────────────────────────────────────────────────────────────

class _OrderCard extends StatelessWidget {
  final Order order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        AppRoutes.orderDetail.replaceFirst(':orderId', order.id),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant.withAlpha(77)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader(),
            const Divider(height: 1, color: Color(0x0F000000)),
            _buildItemsSection(),
            const Divider(height: 1, color: Color(0x0F000000)),
            _buildCardFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #${order.reference}',
                  style: AppTextStyles.bodyMd.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  DateFormat('d MMM yyyy, HH:mm').format(order.createdAt),
                  style: AppTextStyles.labelMd.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _OrderStatusBadge(status: order.status),
        ],
      ),
    );
  }

  Widget _buildItemsSection() {
    final displayItems =
        order.items.length > 2 ? order.items.take(2).toList() : order.items;
    final extraCount = order.items.length - displayItems.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...displayItems.map((item) => _OrderItemRow(item: item)),
          if (extraCount > 0)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                '+$extraCount more item${extraCount > 1 ? 's' : ''}',
                style: AppTextStyles.labelMd.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCardFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total',
                style: AppTextStyles.labelMd.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text.rich(
                TextSpan(
                  style: AppTextStyles.bodyMd.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                  children: [
                    const TextSpan(
                      text: '₦',
                      style: TextStyle(fontFamily: 'Roboto'),
                    ),
                    TextSpan(
                      text: NumberFormat('#,##0.00', 'en_NG')
                          .format(order.total),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              if (order.status == OrderStatus.pendingPayment)
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Pay Now',
                    style: AppTextStyles.labelMd.copyWith(
                      fontSize: 13,
                      color: AppColors.onPrimary,
                    ),
                  ),
                )
              else
                OutlinedButton(
                  onPressed: () => context.push(
                    AppRoutes.orderDetail
                        .replaceFirst(':orderId', order.id),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.outlineVariant),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View Details',
                        style: AppTextStyles.labelMd.copyWith(
                          fontSize: 13,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right,
                          size: 16, color: AppColors.primary),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  final OrderItem item;
  const _OrderItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primaryFixed.withAlpha(128),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.card_giftcard_outlined,
              size: 15,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item.productName,
              style: AppTextStyles.labelMd.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'x${item.quantity}',
            style: AppTextStyles.labelMd.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
          Text.rich(
            TextSpan(
              style: AppTextStyles.labelMd.copyWith(
                fontSize: 13,
                color: AppColors.onSurface,
              ),
              children: [
                const TextSpan(
                  text: '₦',
                  style: TextStyle(fontFamily: 'Roboto'),
                ),
                TextSpan(
                  text: NumberFormat('#,##0', 'en_NG').format(item.unitPrice),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Status Badge ──────────────────────────────────────────────────────────────

class _OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;
  const _OrderStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      OrderStatus.pendingPayment => ('Pending Payment', AppColors.secondary),
      OrderStatus.paid => ('Paid', AppColors.nairaGreen),
      OrderStatus.processing => ('Processing', AppColors.tertiary),
      OrderStatus.dispatched => ('Dispatched', AppColors.primary),
      OrderStatus.delivered => ('Delivered', AppColors.nairaGreen),
      OrderStatus.cancelled => ('Cancelled', AppColors.onSurfaceVariant),
      OrderStatus.failed => ('Failed', AppColors.error),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTextStyles.labelMd.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryFixed.withAlpha(128),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: AppColors.primary,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No orders yet',
              style: AppTextStyles.bodyMd.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'When you place an order, it will appear here. Browse the store and forge a memorable moment.',
              style: AppTextStyles.labelMd.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.go(AppRoutes.store),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: const StadiumBorder(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
              icon: const Icon(Icons.storefront_outlined, size: 18),
              label: Text(
                'Browse Store',
                style: AppTextStyles.labelMd.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error Banner ──────────────────────────────────────────────────────────────

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withAlpha(77)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline,
              color: AppColors.onErrorContainer, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.labelMd.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColors.onErrorContainer,
                fontSize: 13,
              ),
            ),
          ),
          GestureDetector(
            onTap: () =>
                context.read<OrdersCubit>().loadOrders(refresh: true),
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                'Retry',
                style: AppTextStyles.labelMd.copyWith(
                  color: AppColors.onErrorContainer,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
