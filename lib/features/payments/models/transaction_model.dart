import '../../../core/utils/currency_formatter.dart';

enum TransactionType { sent, received }

enum TransactionStatus { pending, completed, failed, cancelled, expired }

/// Transaction model
class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.status,
    required this.timestamp,
    this.recipientName,
    this.senderName,
    this.description,
    this.isSession = false,
    this.sessionPaymentCount,
  });

  final String id;
  final double amount;
  final TransactionType type;
  final TransactionStatus status;
  final DateTime timestamp;
  final String? recipientName;
  final String? senderName;
  final String? description;
  final bool isSession;
  final int? sessionPaymentCount;

  String get displayName {
    if (isSession) return description ?? 'Payment Session';
    return type == TransactionType.received ? (senderName ?? 'Unknown') : (recipientName ?? 'Unknown');
  }

  String get formattedAmount {
    final isPositive = type == TransactionType.received;
    return CurrencyFormatter.formatWithSign(amount, isPositive: isPositive);
  }

  String get statusText {
    switch (status) {
      case TransactionStatus.pending:
        return 'Waiting for payment';
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.failed:
        return 'Failed';
      case TransactionStatus.cancelled:
        return 'Cancelled';
      case TransactionStatus.expired:
        return 'Expired';
    }
  }
}
