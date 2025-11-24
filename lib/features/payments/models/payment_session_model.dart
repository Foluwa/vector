import '../../../core/utils/currency_formatter.dart';

enum SessionStatus { active, ended }

/// Individual payment within a session
class SessionPayment {
  const SessionPayment({required this.id, required this.payerName, required this.amount, required this.timestamp, required this.transactionReference});

  final String id;
  final String payerName;
  final double amount;
  final DateTime timestamp;
  final String transactionReference;

  String get initials {
    final parts = payerName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return payerName.substring(0, 2).toUpperCase();
  }

  String get formattedAmount => CurrencyFormatter.format(amount);

  String get timeOnly {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

/// Payment session model
class PaymentSession {
  PaymentSession({
    required this.id,
    required this.publicUrl,
    required this.qrPayload,
    required this.startedAt,
    required this.linkedBankAccountId,
    this.status = SessionStatus.active,
    this.endedAt,
    this.note,
    List<SessionPayment>? payments,
  }) : payments = payments ?? [];

  final String id;
  final String publicUrl;
  final String qrPayload;
  final DateTime startedAt;
  final String linkedBankAccountId;
  SessionStatus status;
  DateTime? endedAt;
  String? note;
  final List<SessionPayment> payments;

  // Computed properties
  double get totalAmount => payments.fold(0.0, (sum, payment) => sum + payment.amount);

  int get paymentsCount => payments.length;

  double get totalFees => totalAmount * 0.013; // 1.3% fee

  double get netAmount => totalAmount - totalFees;

  Duration get duration {
    final end = endedAt ?? DateTime.now();
    return end.difference(startedAt);
  }

  String get formattedDuration {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String get formattedTotalAmount => CurrencyFormatter.format(totalAmount);

  String get formattedTotalFees => CurrencyFormatter.format(totalFees);

  String get formattedNetAmount => CurrencyFormatter.format(netAmount);

  // Methods
  void addPayment(SessionPayment payment) {
    payments.add(payment);
  }

  void endSession() {
    status = SessionStatus.ended;
    endedAt = DateTime.now();
  }

  void addNote(String newNote) {
    note = newNote;
  }

  PaymentSession copyWith({
    String? id,
    String? publicUrl,
    String? qrPayload,
    DateTime? startedAt,
    String? linkedBankAccountId,
    SessionStatus? status,
    DateTime? endedAt,
    String? note,
    List<SessionPayment>? payments,
  }) {
    return PaymentSession(
      id: id ?? this.id,
      publicUrl: publicUrl ?? this.publicUrl,
      qrPayload: qrPayload ?? this.qrPayload,
      startedAt: startedAt ?? this.startedAt,
      linkedBankAccountId: linkedBankAccountId ?? this.linkedBankAccountId,
      status: status ?? this.status,
      endedAt: endedAt ?? this.endedAt,
      note: note ?? this.note,
      payments: payments ?? this.payments,
    );
  }
}
