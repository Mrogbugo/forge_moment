import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../blocs/wallet_cubit.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          WalletCubit(repository: GetIt.instance<WalletRepository>())
            ..loadWallet()
            ..loadTransactions(),
      child: const _WalletView(),
    );
  }
}

class _WalletView extends StatelessWidget {
  const _WalletView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: _BalanceCard(state: state),
              ),
              SliverToBoxAdapter(
                child: _ActionRow(state: state),
              ),
              if (state.errorMessage != null)
                SliverToBoxAdapter(
                  child: _ErrorBanner(message: state.errorMessage!),
                ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                sliver: _TransactionList(state: state),
              ),
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
        'My Wallet',
        style: AppTextStyles.bodyMd.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
      ),
      centerTitle: true,
    );
  }
}

// ── Balance Card ──────────────────────────────────────────────────────────────

class _BalanceCard extends StatelessWidget {
  final WalletState state;
  const _BalanceCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final wallet = state.wallet;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(51),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Balance',
                style: AppTextStyles.labelMd.copyWith(
                  color: AppColors.onPrimary.withAlpha(179),
                ),
              ),
              if (wallet != null) _StatusChip(status: wallet.status),
            ],
          ),
          const SizedBox(height: 12),
          if (state.isLoadingWallet)
            Container(
              height: 48,
              width: 160,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(40),
                borderRadius: BorderRadius.circular(8),
              ),
            )
          else
            Text.rich(
              TextSpan(
                style: AppTextStyles.currencyDisplay.copyWith(
                  color: AppColors.onPrimary,
                ),
                children: [
                  const TextSpan(
                    text: '₦',
                    style: TextStyle(fontFamily: 'Roboto'),
                  ),
                  TextSpan(
                    text: wallet != null
                        ? _formatAmount(wallet.availableBalance)
                        : '—',
                  ),
                ],
              ),
            ),
          const SizedBox(height: 4),
          Text(
            wallet != null
                ? 'Last updated ${_formatRelativeTime(wallet.lastRefreshed)}'
                : 'Pull to refresh',
            style: AppTextStyles.labelMd.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: AppColors.onPrimary.withAlpha(153),
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    return NumberFormat('#,##0.00', 'en_NG').format(amount);
  }

  String _formatRelativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return DateFormat('d MMM').format(dt);
  }
}

class _StatusChip extends StatelessWidget {
  final WalletStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, bg) = switch (status) {
      WalletStatus.active => ('Active', AppColors.nairaGreen),
      WalletStatus.suspended => ('Suspended', AppColors.error),
      WalletStatus.pendingKyc => ('KYC Required', AppColors.secondary),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg.withAlpha(51),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: bg.withAlpha(153)),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelMd.copyWith(
          fontSize: 11,
          color: AppColors.onPrimary,
        ),
      ),
    );
  }
}

// ── Action Row ────────────────────────────────────────────────────────────────

class _ActionRow extends StatelessWidget {
  final WalletState state;
  const _ActionRow({required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          _ActionButton(
            icon: Icons.add_rounded,
            label: 'Fund',
            onTap: () => context.push(AppRoutes.fundWallet),
          ),
          const SizedBox(width: 12),
          _ActionButton(
            icon: Icons.arrow_upward_rounded,
            label: 'Withdraw',
            enabled: state.wallet?.withdrawalEligible ?? false,
            onTap: () {
              if (state.wallet?.withdrawalEligible == true) {
                context.push(AppRoutes.withdrawal);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.wallet?.withdrawalIneligibleReason ??
                          'Withdrawal is not available at this time.',
                      style: AppTextStyles.bodyMd.copyWith(
                        fontSize: 14,
                        color: AppColors.onPrimary,
                      ),
                    ),
                    backgroundColor: AppColors.onSurface,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  ),
                );
              }
            },
          ),
          const SizedBox(width: 12),
          _ActionButton(
            icon: Icons.receipt_long_outlined,
            label: 'History',
            onTap: () => context.push(AppRoutes.transactions),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool enabled;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: enabled
                ? AppColors.surfaceContainerLowest
                : AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.outlineVariant.withAlpha(102),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color:
                    enabled ? AppColors.primary : AppColors.onSurfaceVariant,
                size: 22,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: AppTextStyles.labelMd.copyWith(
                  fontSize: 13,
                  color: enabled
                      ? AppColors.onSurface
                      : AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Transaction List ──────────────────────────────────────────────────────────

class _TransactionList extends StatelessWidget {
  final WalletState state;
  const _TransactionList({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingTransactions && state.transactions.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2.5,
            ),
          ),
        ),
      );
    }

    if (state.transactions.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: _EmptyTransactions(),
      );
    }

    // +1 for header row, +1 for optional load-more indicator
    final itemCount =
        1 + state.transactions.length + (state.hasMoreTransactions ? 1 : 0);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: AppTextStyles.bodyMd.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.transactions),
                    child: Text(
                      'See all',
                      style: AppTextStyles.labelMd.copyWith(
                        color: AppColors.primary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final txIndex = index - 1;

          if (txIndex == state.transactions.length) {
            if (state.isLoadingTransactions) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
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
            return const SizedBox.shrink();
          }

          final tx = state.transactions[txIndex];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _TransactionTile(transaction: tx),
          );
        },
        childCount: itemCount,
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final WalletTransaction transaction;
  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type == TransactionType.credit ||
        transaction.type == TransactionType.funding ||
        transaction.type == TransactionType.refund;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant.withAlpha(77)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _TransactionIcon(type: transaction.type),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: AppTextStyles.bodyMd.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    _StatusDot(status: transaction.status),
                    const SizedBox(width: 4),
                    Text(
                      _statusLabel(transaction.status),
                      style: AppTextStyles.labelMd.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: _statusColor(transaction.status),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '·',
                      style: TextStyle(
                          color: AppColors.onSurfaceVariant.withAlpha(102)),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('d MMM, HH:mm').format(transaction.createdAt),
                      style: AppTextStyles.labelMd.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text.rich(
            TextSpan(
              style: AppTextStyles.bodyMd.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isCredit ? AppColors.nairaGreen : AppColors.onSurface,
              ),
              children: [
                TextSpan(text: isCredit ? '+' : '-'),
                const TextSpan(
                  text: '₦',
                  style: TextStyle(fontFamily: 'Roboto'),
                ),
                TextSpan(
                  text: NumberFormat('#,##0.00', 'en_NG')
                      .format(transaction.amount),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(TransactionStatus status) => switch (status) {
        TransactionStatus.completed => 'Completed',
        TransactionStatus.pending => 'Pending',
        TransactionStatus.processing => 'Processing',
        TransactionStatus.failed => 'Failed',
      };

  Color _statusColor(TransactionStatus status) => switch (status) {
        TransactionStatus.completed => AppColors.nairaGreen,
        TransactionStatus.pending => AppColors.secondary,
        TransactionStatus.processing => AppColors.tertiary,
        TransactionStatus.failed => AppColors.error,
      };
}

class _TransactionIcon extends StatelessWidget {
  final TransactionType type;
  const _TransactionIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    final (icon, bg) = switch (type) {
      TransactionType.credit => (
          Icons.arrow_downward_rounded,
          AppColors.nairaGreen
        ),
      TransactionType.debit => (Icons.arrow_upward_rounded, AppColors.primary),
      TransactionType.withdrawal => (
          Icons.account_balance_outlined,
          AppColors.onSurfaceVariant
        ),
      TransactionType.funding => (
          Icons.add_card_outlined,
          AppColors.nairaGreen
        ),
      TransactionType.giftSend => (
          Icons.card_giftcard_outlined,
          AppColors.primary
        ),
      TransactionType.refund => (Icons.replay_rounded, AppColors.secondary),
    };

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bg.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: bg, size: 20),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final TransactionStatus status;
  const _StatusDot({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      TransactionStatus.completed => AppColors.nairaGreen,
      TransactionStatus.pending => AppColors.secondary,
      TransactionStatus.processing => AppColors.tertiary,
      TransactionStatus.failed => AppColors.error,
    };
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyTransactions extends StatelessWidget {
  const _EmptyTransactions();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primaryFixed.withAlpha(128),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No transactions yet',
              style: AppTextStyles.bodyMd.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fund your wallet to get started. Your transactions will appear here.',
              style: AppTextStyles.labelMd.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.push(AppRoutes.fundWallet),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: const StadiumBorder(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(
                'Fund Wallet',
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
            onTap: () {
              final cubit = context.read<WalletCubit>();
              cubit.loadWallet();
              cubit.loadTransactions(refresh: true);
            },
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
