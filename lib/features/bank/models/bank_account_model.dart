/// Bank account model
class BankAccountModel {
  const BankAccountModel({
    required this.id,
    required this.bankName,
    required this.accountType,
    required this.maskedNumber,
    required this.sortCode,
    this.isDefault = false,
    this.isExpired = false,
  });

  final String id;
  final String bankName;
  final String accountType;
  final String maskedNumber;
  final String sortCode;
  final bool isDefault;
  final bool isExpired;

  BankAccountModel copyWith({String? id, String? bankName, String? accountType, String? maskedNumber, String? sortCode, bool? isDefault, bool? isExpired}) {
    return BankAccountModel(
      id: id ?? this.id,
      bankName: bankName ?? this.bankName,
      accountType: accountType ?? this.accountType,
      maskedNumber: maskedNumber ?? this.maskedNumber,
      sortCode: sortCode ?? this.sortCode,
      isDefault: isDefault ?? this.isDefault,
      isExpired: isExpired ?? this.isExpired,
    );
  }

  String get displayAccountNumber => '$maskedNumber • $sortCode';
}
