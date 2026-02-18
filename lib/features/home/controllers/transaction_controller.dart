import 'package:get/get.dart';
import '../models/transaction_model.dart';

class TransactionController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  final List<TransactionModel> allTransactions = const [
    TransactionModel(
      title: 'Web Design Project',
      subtitle: 'Feb 5 • Services',
      amount: '+\$1,250.00',
      isIncome: true,
      trailingText: 'Receipt Attached',
    ),
    TransactionModel(
      title: 'Web Design Project',
      subtitle: 'Feb 5 • Services',
      amount: '+\$1,250.00',
      isIncome: true,
      trailingText: 'Receipt Attached',
    ),
    TransactionModel(
      title: 'Client Lunch',
      subtitle: 'Feb 5 • Travel/Meals',
      amount: '-\$120.00',
      isIncome: false,
      trailingText: 'Receipt Attached',
    ),
    TransactionModel(
      title: 'Client Lunch',
      subtitle: 'Feb 5 • Travel/Meals',
      amount: '-\$120.00',
      isIncome: false,
      trailingText: 'Receipt Attached',
    ),
    TransactionModel(
      title: 'Web Design Project',
      subtitle: 'Feb 5 • Services',
      amount: '+\$1,250.00',
      isIncome: true,
      trailingText: 'Receipt Attached',
    ),
    TransactionModel(
      title: 'Client Lunch',
      subtitle: 'Feb 5 • Travel/Meals',
      amount: '-\$120.00',
      isIncome: false,
      trailingText: 'Receipt Attached',
    ),
  ];

  List<TransactionModel> get filteredTransactions {
    if (selectedIndex.value == 0) return allTransactions;
    if (selectedIndex.value == 1) return allTransactions.where((t) => t.isIncome).toList();
    return allTransactions.where((t) => !t.isIncome).toList();
  }

  void changeFilter(int index) {
    selectedIndex.value = index;
  }
}
