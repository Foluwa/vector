import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/payment_session_model.dart';

/// Mock session service for creating and managing payment sessions
class SessionService {
  final Map<String, PaymentSession> _sessions = {};
  final Map<String, Timer?> _sessionTimers = {};
  final Random _random = Random();

  // Mock payer names for random payment generation
  static const _mockPayers = [
    'Sarah Johnson',
    'Michael Chen',
    'Emma Williams',
    'David Brown',
    'James Anderson',
    'Olivia Martinez',
    'Daniel Lee',
    'Sophia Taylor',
    'William Garcia',
    'Isabella Rodriguez',
  ];

  /// Create a new payment session
  Future<PaymentSession> createSession({required String linkedBankAccountId}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final now = DateTime.now();
    final sessionId = _generateSessionId();
    final publicUrl = 'https://paywithvector.app/s/$sessionId';
    final qrPayload = publicUrl; // In real app, might be different encoding

    final session = PaymentSession(id: sessionId, publicUrl: publicUrl, qrPayload: qrPayload, startedAt: now, linkedBankAccountId: linkedBankAccountId);

    _sessions[sessionId] = session;

    // Start mock payment timer (simulates real-time payments)
    _startMockPaymentTimer(sessionId);

    return session;
  }

  /// Get a session by ID
  PaymentSession? getSession(String sessionId) {
    return _sessions[sessionId];
  }

  /// Get all sessions (for history display)
  List<PaymentSession> getAllSessions() {
    return _sessions.values.toList();
  }

  /// Add a note to a session
  Future<void> addNoteToSession(String sessionId, String note) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final session = _sessions[sessionId];
    if (session != null) {
      session.addNote(note);
    }
  }

  /// End a payment session
  Future<PaymentSession> endSession(String sessionId) async {
    // Simulate processing delay
    await Future.delayed(const Duration(milliseconds: 1200));

    final session = _sessions[sessionId];
    if (session == null) {
      throw Exception('Session not found');
    }

    // Stop the mock payment timer
    _stopMockPaymentTimer(sessionId);

    // Mark session as ended
    session.endSession();

    return session;
  }

  /// Generate mock session ID
  String _generateSessionId() {
    final year = DateTime.now().year;
    final number = _random.nextInt(999) + 1;
    return 'SES-$year-${number.toString().padLeft(3, '0')}';
  }

  /// Generate mock transaction reference
  String _generateTransactionRef() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return 'TXN-${List.generate(8, (_) => chars[_random.nextInt(chars.length)]).join()}';
  }

  /// Start mock payment timer for demo purposes
  void _startMockPaymentTimer(String sessionId) {
    // Add random payments every 8-15 seconds to simulate real activity
    _sessionTimers[sessionId] = Timer.periodic(const Duration(seconds: 10), (timer) {
      final session = _sessions[sessionId];
      if (session == null || session.status == SessionStatus.ended) {
        timer.cancel();
        return;
      }

      // Randomly add a payment (70% chance each tick)
      if (_random.nextDouble() < 0.7) {
        final payment = SessionPayment(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          payerName: _mockPayers[_random.nextInt(_mockPayers.length)],
          amount: _random.nextDouble() * 150 + 10, // £10 - £160
          timestamp: DateTime.now(),
          transactionReference: _generateTransactionRef(),
        );

        session.addPayment(payment);
      }
    });
  }

  /// Stop mock payment timer
  void _stopMockPaymentTimer(String sessionId) {
    _sessionTimers[sessionId]?.cancel();
    _sessionTimers.remove(sessionId);
  }

  /// Clean up timers on dispose
  void dispose() {
    for (var timer in _sessionTimers.values) {
      timer?.cancel();
    }
    _sessionTimers.clear();
  }
}

/// Riverpod provider for SessionService
final sessionServiceProvider = Provider<SessionService>((ref) {
  final service = SessionService();
  ref.onDispose(() {
    service.dispose();
  });
  return service;
});

/// State notifier for managing active session state
class ActiveSessionNotifier extends StateNotifier<PaymentSession?> {
  ActiveSessionNotifier(this._sessionService) : super(null);

  final SessionService _sessionService;
  Timer? _updateTimer;

  /// Start a new session
  Future<void> startSession(String linkedBankAccountId) async {
    final session = await _sessionService.createSession(linkedBankAccountId: linkedBankAccountId);
    state = session;

    // Start periodic updates to refresh UI (for timer and payment updates)
    _startUpdateTimer();
  }

  /// Add note to current session
  Future<void> addNote(String note) async {
    if (state == null) return;
    await _sessionService.addNoteToSession(state!.id, note);
    // Trigger rebuild by creating new instance
    state = state!.copyWith(note: note);
  }

  /// End current session
  Future<void> endSession() async {
    if (state == null) return;
    _stopUpdateTimer();
    final endedSession = await _sessionService.endSession(state!.id);
    state = endedSession;
  }

  /// Clear current session (after navigating away)
  void clearSession() {
    _stopUpdateTimer();
    state = null;
  }

  /// Ensure timer is running (useful when navigating back to session screen)
  void ensureTimerRunning() {
    if (state != null && state!.status == SessionStatus.active) {
      if (_updateTimer == null || !_updateTimer!.isActive) {
        _startUpdateTimer();
      }
    }
  }

  /// Start periodic timer to update UI
  void _startUpdateTimer() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state != null && state!.status == SessionStatus.active) {
        // Trigger rebuild by creating a new instance (Riverpod needs object identity change)
        state = state!.copyWith();
      } else {
        timer.cancel();
      }
    });
  }

  /// Stop update timer
  void _stopUpdateTimer() {
    _updateTimer?.cancel();
    _updateTimer = null;
  }

  @override
  void dispose() {
    _stopUpdateTimer();
    super.dispose();
  }
}

/// Provider for active session state
final activeSessionProvider = StateNotifierProvider<ActiveSessionNotifier, PaymentSession?>((ref) {
  final sessionService = ref.watch(sessionServiceProvider);
  return ActiveSessionNotifier(sessionService);
});
