// NGN currency formatting (FRD Business Rules + FR-UX)
// All user-facing amounts display as ₦ with Nigerian locale formatting
// API always receives unambiguous numeric values (no currency symbols)
class CurrencyFormatter {
  CurrencyFormatter._();

  /// Display: ₦1,500.00
  static String format(num amount) {
    final formatted = amount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
    return '₦$formatted';
  }

  /// Compact: ₦1.5k, ₦20k
  static String formatCompact(num amount) {
    if (amount >= 1000000) return '₦${(amount / 1000000).toStringAsFixed(1)}M';
    if (amount >= 1000) return '₦${(amount / 1000).toStringAsFixed(1)}k';
    return format(amount);
  }

  /// Strip formatting for API submission
  static double parse(String input) =>
      double.tryParse(input.replaceAll(RegExp(r'[₦,\s]'), '')) ?? 0.0;
}
