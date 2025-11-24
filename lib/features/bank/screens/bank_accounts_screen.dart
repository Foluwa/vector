import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/cards.dart';
import '../services/bank_service.dart';

class BankAccountsScreen extends ConsumerWidget {
  const BankAccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(bankAccountsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Bank Accounts')),
      body: SingleChildScrollView(
        padding: AppConstants.paddingAll24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Manage where payments settle', style: AppTextStyles.body2),
            const SizedBox(height: AppConstants.spacing24),
            accountsAsync.when(
              data: (accounts) => Column(
                children: [
                  ...accounts.map(
                    (account) => Padding(
                      padding: const EdgeInsets.only(bottom: AppConstants.spacing16),
                      child: BankAccountCard(
                        bankName: account.bankName,
                        accountType: account.accountType,
                        maskedNumber: account.displayAccountNumber,
                        isDefault: account.isDefault,
                        isExpired: account.isExpired,
                        onReconnect: account.isExpired
                            ? () {
                                // Handle reconnect
                              }
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text('Error: $error'),
            ),
            const SizedBox(height: AppConstants.spacing16),
            PrimaryButton(
              label: 'Add Bank Account +',
              onPressed: () {
                // Handle add bank
              },
            ),
            const SizedBox(height: AppConstants.spacing32),
            Text('Account Limits', style: AppTextStyles.h3),
            const SizedBox(height: AppConstants.spacing16),
            Text('Daily settlement limit: \u00A35,000', style: AppTextStyles.body1),
          ],
        ),
      ),
    );
  }
}
