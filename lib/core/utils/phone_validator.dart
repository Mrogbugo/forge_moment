// Nigerian/international phone normalization (FR-GIFT-016)
// Normalizes to E.164 format for API; displays in local format for UI
class PhoneValidator {
  PhoneValidator._();

  static const String _ngPrefix = '+234';

  /// Normalizes 08012345678 → +2348012345678
  static String? normalize(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('234') && digits.length == 13) return '+$digits';
    if (digits.startsWith('0') && digits.length == 11) return '$_ngPrefix${digits.substring(1)}';
    if (digits.length == 10) return '$_ngPrefix$digits';
    return null; // unrecognized format
  }

  static bool isValidNigerian(String input) => normalize(input) != null;

  static bool isValidEmail(String input) =>
      RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$').hasMatch(input.trim());

  static bool isValidWhatsApp(String input) => isValidNigerian(input);
}
