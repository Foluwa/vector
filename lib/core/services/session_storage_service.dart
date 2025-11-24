import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/payments/models/payment_session_model.dart';

/// Service for persisting active payment sessions
/// Ensures sessions survive app restarts and navigation
class SessionStorageService {
  static const String _activeSessionKey = 'active_payment_session';
  static const String _sessionPaymentsPrefix = 'session_payments_';

  /// Save active session to persistent storage
  Future<void> saveActiveSession(PaymentSession session) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save session data
      final sessionData = {
        'id': session.id,
        'publicUrl': session.publicUrl,
        'qrPayload': session.qrPayload,
        'startedAt': session.startedAt.toIso8601String(),
        'linkedBankAccountId': session.linkedBankAccountId,
        'status': session.status.name,
        'endedAt': session.endedAt?.toIso8601String(),
        'note': session.note,
      };

      await prefs.setString(_activeSessionKey, jsonEncode(sessionData));

      // Save payments separately (easier to update)
      await _savePayments(session.id, session.payments);
    } catch (e) {
      // Log error but don't throw - persistence failure shouldn't break the app
      print('Error saving session: $e');
    }
  }

  /// Load active session from persistent storage
  Future<PaymentSession?> loadActiveSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionJson = prefs.getString(_activeSessionKey);

      if (sessionJson == null) return null;

      final sessionData = jsonDecode(sessionJson) as Map<String, dynamic>;

      // Load payments
      final payments = await _loadPayments(sessionData['id'] as String);

      return PaymentSession(
        id: sessionData['id'] as String,
        publicUrl: sessionData['publicUrl'] as String,
        qrPayload: sessionData['qrPayload'] as String,
        startedAt: DateTime.parse(sessionData['startedAt'] as String),
        linkedBankAccountId: sessionData['linkedBankAccountId'] as String,
        status: sessionData['status'] == 'ended' ? SessionStatus.ended : SessionStatus.active,
        endedAt: sessionData['endedAt'] != null ? DateTime.parse(sessionData['endedAt'] as String) : null,
        note: sessionData['note'] as String?,
        payments: payments,
      );
    } catch (e) {
      print('Error loading session: $e');
      return null;
    }
  }

  /// Clear active session from storage
  Future<void> clearActiveSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionJson = prefs.getString(_activeSessionKey);

      if (sessionJson != null) {
        final sessionData = jsonDecode(sessionJson) as Map<String, dynamic>;
        final sessionId = sessionData['id'] as String;

        // Clear payments
        await prefs.remove('$_sessionPaymentsPrefix$sessionId');
      }

      await prefs.remove(_activeSessionKey);
    } catch (e) {
      print('Error clearing session: $e');
    }
  }

  /// Save payments for a session
  Future<void> _savePayments(String sessionId, List<SessionPayment> payments) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final paymentsData = payments
          .map(
            (p) => {
              'id': p.id,
              'payerName': p.payerName,
              'amount': p.amount,
              'timestamp': p.timestamp.toIso8601String(),
              'transactionReference': p.transactionReference,
            },
          )
          .toList();

      await prefs.setString('$_sessionPaymentsPrefix$sessionId', jsonEncode(paymentsData));
    } catch (e) {
      print('Error saving payments: $e');
    }
  }

  /// Load payments for a session
  Future<List<SessionPayment>> _loadPayments(String sessionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final paymentsJson = prefs.getString('$_sessionPaymentsPrefix$sessionId');

      if (paymentsJson == null) return [];

      final paymentsData = jsonDecode(paymentsJson) as List<dynamic>;

      return paymentsData
          .map(
            (data) => SessionPayment(
              id: data['id'] as String,
              payerName: data['payerName'] as String,
              amount: (data['amount'] as num).toDouble(),
              timestamp: DateTime.parse(data['timestamp'] as String),
              transactionReference: data['transactionReference'] as String,
            ),
          )
          .toList();
    } catch (e) {
      print('Error loading payments: $e');
      return [];
    }
  }

  /// Check if there's an active session stored
  Future<bool> hasActiveSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_activeSessionKey);
    } catch (e) {
      return false;
    }
  }
}
