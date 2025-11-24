import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/bottom_nav.dart';
import '../../../core/widgets/input_fields.dart';
import '../models/payment_session_model.dart';
import '../services/session_service.dart';

/// History screen - view past transactions with pagination
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  int _selectedTab = 0;
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  static const int _itemsPerPage = AppConstants.defaultPageSize;
  bool _isLoadingMore = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (!_isLoadingMore && _hasMoreData) {
      setState(() {
        _isLoadingMore = true;
        _currentPage++;
      });

      // Simulate loading delay
      Future.delayed(AppConstants.shortDelay, () {
        if (mounted) {
          setState(() => _isLoadingMore = false);
        }
      });
    }
  }

  bool get _hasMoreData {
    final filteredLength = _filteredTransactions.length;
    final paginatedLength = (_currentPage + 1) * _itemsPerPage;
    return paginatedLength < filteredLength;
  }

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
    var allTxns = _allTransactionsWithSessions;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      allTxns = allTxns.where((t) {
        return t.name.toLowerCase().contains(query) || t.amount.toLowerCase().contains(query) || t.time.toLowerCase().contains(query);
      }).toList();
    }

    // Apply tab filter
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

  List<_TransactionData> get _paginatedTransactions {
    final endIndex = (_currentPage + 1) * _itemsPerPage;
    return _filteredTransactions.take(endIndex).toList();
  }

  @override
  Widget build(BuildContext context) {
    final paginatedTransactions = _paginatedTransactions;
    final todayTransactions = paginatedTransactions.where((t) => t.time.contains('hours ago')).toList();
    final yesterdayTransactions = paginatedTransactions.where((t) => t.time.contains('Yesterday')).toList();

    return Scaffold(
      appBar: AppBar(title: Text('History', style: AppTextStyles.h1)),
      body: ListView(
        controller: _scrollController,
        children: [
          // Tabs
          Container(
            padding: AppConstants.paddingH24,
            child: Row(children: [_buildTab('All', 0), _buildTab('Sent', 1), _buildTab('Received', 2), _buildTab('Sessions', 3)]),
          ),
          const SizedBox(height: AppConstants.spacing16),
          // Summary card
          Container(
            margin: AppConstants.paddingH24,
            padding: AppConstants.paddingAll20,
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppConstants.borderRadiusLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('THIS MONTH', style: AppTextStyles.overline),
                const SizedBox(height: AppConstants.spacing12),
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
          const SizedBox(height: AppConstants.spacing24),
          // Search
          Padding(
            padding: AppConstants.paddingH24,
            child: SearchField(
              hint: 'Search by name, amount, or date',
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _currentPage = 0; // Reset pagination on search
                });
              },
            ),
          ),
          const SizedBox(height: AppConstants.spacing24),
          // Transaction list
          if (paginatedTransactions.isEmpty)
            Padding(
              padding: AppConstants.paddingAll48,
              child: Column(
                children: [
                  const Icon(Icons.inbox_outlined, size: 64, color: AppColors.textTertiary),
                  const SizedBox(height: AppConstants.spacing16),
                  Text('No transactions found', style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            )
          else ...[
            if (todayTransactions.isNotEmpty) _buildTransactionSection(context, 'TODAY', todayTransactions),
            if (yesterdayTransactions.isNotEmpty) _buildTransactionSection(context, 'YESTERDAY', yesterdayTransactions),
            if (_isLoadingMore)
              const Padding(
                padding: AppConstants.paddingAll24,
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return Padding(
      padding: const EdgeInsets.only(right: AppConstants.spacing8),
      child: InkWell(
        onTap: () => setState(() {
          _selectedTab = index;
          _currentPage = 0; // Reset pagination on tab change
        }),
        borderRadius: AppConstants.borderRadiusXLarge,
        child: Container(
          padding: AppConstants.paddingH16V8,
          decoration: BoxDecoration(color: isSelected ? AppColors.primary : Colors.transparent, borderRadius: AppConstants.borderRadiusXLarge),
          child: Text(label, style: AppTextStyles.body2Medium.copyWith(color: isSelected ? AppColors.textPrimary : AppColors.textSecondary)),
        ),
      ),
    );
  }

  Widget _buildTransactionSection(BuildContext context, String title, List<_TransactionData> transactions) {
    return Padding(
      padding: AppConstants.paddingH24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.overline),
          const SizedBox(height: AppConstants.spacing12),
          ...transactions.map((t) => _buildTransactionItem(context, t)),
          const SizedBox(height: AppConstants.spacing24),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, _TransactionData data) {
    return InkWell(
      onTap: () {
        if (data.isSession) {
          context.push('/session-settlement/${data.id}');
        } else {
          context.push('/history/transaction/${data.id}');
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppConstants.spacing16),
        child: Row(
          children: [
            Container(
              padding: AppConstants.paddingAll12,
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppConstants.borderRadiusSmall),
              child: Icon(data.icon, size: AppConstants.iconLarge, color: AppColors.textSecondary),
            ),
            const SizedBox(width: AppConstants.spacing12),
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
                const Icon(Icons.check_circle, size: AppConstants.iconSmall, color: AppColors.success),
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
