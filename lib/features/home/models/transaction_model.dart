class TransactionModel {
  final String title;
  final String subtitle;
  final String amount;
  final bool isIncome;
  final String trailingText;

  const TransactionModel({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isIncome,
    required this.trailingText,
  });
}
