import 'package:intl/intl.dart';

/// Currency formatter utility for consistent formatting across the app
class CurrencyFormatter {
  // Private constructor to prevent instantiation
  CurrencyFormatter._();

  /// Default currency formatter with GBP symbol
  static final NumberFormat _gbpFormatter = NumberFormat.currency(symbol: '£', decimalDigits: 2, locale: 'en_GB');

  /// Format amount as GBP with comma separators
  /// Example: 1234.56 -> £1,234.56
  static String format(double amount) {
    return _gbpFormatter.format(amount);
  }

  /// Format amount with sign prefix (+ or -)
  /// Example: 1234.56 -> +£1,234.56 or -£1,234.56
  static String formatWithSign(double amount, {required bool isPositive}) {
    final sign = isPositive ? '+' : '-';
    return '$sign${_gbpFormatter.format(amount.abs())}';
  }

  /// Format amount without currency symbol (just number with commas)
  /// Example: 1234.56 -> 1,234.56
  static String formatNumber(double amount) {
    final formatter = NumberFormat('#,##0.00', 'en_GB');
    return formatter.format(amount);
  }

  /// Parse formatted string back to double
  /// Example: £1,234.56 -> 1234.56
  static double parse(String formattedAmount) {
    try {
      // Remove currency symbol and whitespace
      String cleaned = formattedAmount.replaceAll('£', '').replaceAll(',', '').replaceAll('+', '').replaceAll('-', '').trim();
      return double.parse(cleaned);
    } catch (e) {
      return 0.0;
    }
  }
}
