import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/bottom_nav.dart';
import '../../../core/widgets/input_fields.dart';
import '../models/payment_session_model.dart';
import '../services/session_service.dart';

/// History screen - view past transactions
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  int _selectedTab = 0;

  // All transactions data
  final List<_TransactionData> _allTransactions = [
    _TransactionData(icon: Icons.qr_code, name: 'Sarah Johnson', time: '2 hours ago', amount: '+£45.00', isPositive: true, id: '1'),
    _TransactionData(icon: Icons.store, name: 'Coffee Shop', time: '5 hours ago', amount: '-£12.50', isPositive: false, id: '2'),
    _TransactionData(
      icon: Icons.layers,
      name: 'Market Session',
      time: 'Yesterday, 3:45 PM',
      amount: '+£234.75',
      isPositive: true,
      subtitle: '12 payments',
      isSession: true,
      id: 'session_1',
    ),
    _TransactionData(icon: Icons.local_taxi, name: 'Taxi Driver', time: 'Yesterday, 9:20 AM', amount: '-£18.00', isPositive: false, id: '3'),
  ];

  // Dynamically add active/ended sessions from SessionService
  List<_TransactionData> get _allTransactionsWithSessions {
    final sessionService = ref.read(sessionServiceProvider);
    final sessions = sessionService.getAllSessions();

    final sessionTransactions = sessions.map((session) {
      return _TransactionData(
        icon: Icons.qr_code_2,
        name: 'Payment Session',
        time: session.status == SessionStatus.active ? 'Active now' : 'Ended ${_formatSessionTime(session.endedAt ?? session.startedAt)}',
        amount: session.formattedTotalAmount,
        isPositive: true,
        subtitle: '${session.paymentsCount} payment${session.paymentsCount == 1 ? '' : 's'}',
        isSession: true,
        id: session.id,
      );
    }).toList();

    return [...sessionTransactions, ..._allTransactions];
  }

  String _formatSessionTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  List<_TransactionData> get _filteredTransactions {
    final allTxns = _allTransactionsWithSessions;
    switch (_selectedTab) {
      case 1: // Sent
        return allTxns.where((t) => !t.isPositive && !t.isSession).toList();
      case 2: // Received
        return allTxns.where((t) => t.isPositive && !t.isSession).toList();
      case 3: // Sessions
        return allTxns.where((t) => t.isSession).toList();
      default: // All
        return allTxns;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredTransactions = _filteredTransactions;
    final todayTransactions = filteredTransactions.where((t) => t.time.contains('hours ago')).toList();
    final yesterdayTransactions = filteredTransactions.where((t) => t.time.contains('Yesterday')).toList();

    return Scaffold(
      appBar: AppBar(title: Text('History', style: AppTextStyles.h1)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Tabs
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(children: [_buildTab('All', 0), _buildTab('Sent', 1), _buildTab('Received', 2), _buildTab('Sessions', 3)]),
            ),
            const SizedBox(height: 16),
            // Summary card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('THIS MONTH', style: AppTextStyles.overline),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Received', style: AppTextStyles.body2),
                            Text('+\u00A3497.25', style: AppTextStyles.h2.copyWith(color: AppColors.positiveAmount)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Sent', style: AppTextStyles.body2),
                            Text('-\u00A3119.75', style: AppTextStyles.h2),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SearchField(
                hint: 'Search by name, amount, or date',
                onChanged: (value) {
                  // Handle search
                },
              ),
            ),
            const SizedBox(height: 24),
            // Transaction list
            if (filteredTransactions.isEmpty)
              Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  children: [
                    Icon(Icons.inbox_outlined, size: 64, color: AppColors.textTertiary),
                    const SizedBox(height: 16),
                    Text('No transactions found', style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              )
            else ...[
              if (todayTransactions.isNotEmpty) _buildTransactionSection(context, 'TODAY', todayTransactions),
              if (yesterdayTransactions.isNotEmpty) _buildTransactionSection(context, 'YESTERDAY', yesterdayTransactions),
            ],
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => setState(() => _selectedTab = index),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: isSelected ? AppColors.primary : Colors.transparent, borderRadius: BorderRadius.circular(20)),
          child: Text(label, style: AppTextStyles.body2Medium.copyWith(color: isSelected ? AppColors.textPrimary : AppColors.textSecondary)),
        ),
      ),
    );
  }

  Widget _buildTransactionSection(BuildContext context, String title, List<_TransactionData> transactions) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.overline),
          const SizedBox(height: 12),
          ...transactions.map((t) => _buildTransactionItem(context, t)),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, _TransactionData data) {
    return InkWell(
      onTap: () {
        if (data.isSession) {
          // Navigate to session settlement screen
          context.push('/session-settlement/${data.id}');
        } else {
          context.push('/history/transaction/${data.id}');
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8)),
              child: Icon(data.icon, size: 24, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.name, style: AppTextStyles.body1Medium),
                  Text(data.time, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                  if (data.subtitle != null) Text(data.subtitle!, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(data.amount, style: AppTextStyles.body1Medium.copyWith(color: data.isPositive ? AppColors.positiveAmount : AppColors.textPrimary)),
                const Icon(Icons.check_circle, size: 16, color: AppColors.success),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionData {
  final IconData icon;
  final String name;
  final String time;
  final String amount;
  final bool isPositive;
  final String? subtitle;
  final bool isSession;
  final String id;

  _TransactionData({
    required this.icon,
    required this.name,
    required this.time,
    required this.amount,
    required this.isPositive,
    required this.id,
    this.subtitle,
    this.isSession = false,
  });
}
