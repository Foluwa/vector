import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bank_account_model.dart';

/// Mock bank account service
class BankService {
  final List<BankAccountModel> _accounts = [
    const BankAccountModel(id: '1', bankName: 'Monzo', accountType: 'Current', maskedNumber: '•••• 4521', sortCode: '04-00-04', isDefault: true),
    const BankAccountModel(id: '2', bankName: 'Barclays', accountType: 'Savings', maskedNumber: '•••• 8832', sortCode: '20-00-00'),
    const BankAccountModel(id: '3', bankName: 'HSBC', accountType: 'Current', maskedNumber: '•••• 1247', sortCode: '40-47-84', isExpired: true),
    const BankAccountModel(id: '4', bankName: 'Revolut', accountType: 'Current', maskedNumber: '•••• 9103', sortCode: '04-00-75'),
  ];

  /// Get all bank accounts
  Future<List<BankAccountModel>> getAccounts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_accounts);
  }

  /// Get default bank account
  Future<BankAccountModel?> getDefaultAccount() async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _accounts.firstWhere((account) => account.isDefault);
    } catch (e) {
      return null;
    }
  }

  /// Connect a new bank account (mock TrueLayer flow)
  Future<BankAccountModel> connectBank() async {
    await Future.delayed(const Duration(seconds: 2));

    // Simulate successful bank connection
    final newAccount = BankAccountModel(
      id: 'new_${DateTime.now().millisecondsSinceEpoch}',
      bankName: 'New Bank',
      accountType: 'Current',
      maskedNumber: '•••• ${DateTime.now().millisecond}',
      sortCode: '12-34-56',
    );

    _accounts.add(newAccount);
    return newAccount;
  }

  /// Reconnect expired bank account
  Future<BankAccountModel> reconnectBank(String accountId) async {
    await Future.delayed(const Duration(seconds: 2));

    final index = _accounts.indexWhere((account) => account.id == accountId);
    if (index == -1) {
      throw Exception('Account not found');
    }

    final updatedAccount = _accounts[index].copyWith(isExpired: false);
    _accounts[index] = updatedAccount;
    return updatedAccount;
  }

  /// Set default bank account
  Future<void> setDefaultAccount(String accountId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    for (var i = 0; i < _accounts.length; i++) {
      _accounts[i] = _accounts[i].copyWith(isDefault: _accounts[i].id == accountId);
    }
  }

  /// Remove bank account
  Future<void> removeAccount(String accountId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _accounts.removeWhere((account) => account.id == accountId);
  }
}

// Providers
final bankServiceProvider = Provider<BankService>((ref) {
  return BankService();
});

final bankAccountsProvider = FutureProvider<List<BankAccountModel>>((ref) async {
  return ref.watch(bankServiceProvider).getAccounts();
});

final defaultBankAccountProvider = FutureProvider<BankAccountModel?>((ref) async {
  return ref.watch(bankServiceProvider).getDefaultAccount();
});
