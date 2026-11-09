// Date utilities — Africa/Lagos timezone handling (FRD Business Rules)
// All API timestamps are ISO 8601 UTC; all user-facing displays use Africa/Lagos
// Handles leap-year edge cases for celebration annual dates (FR-CEL-004)
class ForgeDateUtils {
  ForgeDateUtils._();

  /// Format ISO 8601 UTC string for display in Africa/Lagos time (UTC+1, no DST)
  static String formatDisplay(String isoUtc) {
    // TODO: use intl package for full timezone support
    final dt = DateTime.tryParse(isoUtc)?.toLocal();
    if (dt == null) return '';
    return '${dt.day} ${_months[dt.month - 1]} ${dt.year}';
  }

  static String formatTime(String isoUtc) {
    final dt = DateTime.tryParse(isoUtc)?.toLocal();
    if (dt == null) return '';
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $ampm';
  }

  /// Adjust annual celebration date for leap year safety
  static DateTime safeAnnualDate(int month, int day, int year) {
    if (month == 2 && day == 29) {
      final isLeap = (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
      return isLeap ? DateTime(year, 2, 29) : DateTime(year, 3, 1);
    }
    return DateTime(year, month, day);
  }

  static const List<String> _months = [
    'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'
  ];
}
