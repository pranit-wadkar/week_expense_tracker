import 'package:hive_flutter/hive_flutter.dart';

import '../models/expense_item.dart';

class HiveDatabase {
  final _myBox = Hive.box("expense_database");

  // Save list of expenses to Hive
  void saveData(List<ExpenseItem> allExpense) {
    List<List<dynamic>> allExpenseFormatted = [];

    // Format each expense item into a list (serialize DateTime)
    for (var expense in allExpense) {
      List<dynamic> expenseFormatted = [
        expense.name, // Name
        expense.amount, // Amount
        expense.dateTime.toIso8601String(), // Convert DateTime to String
      ];
      allExpenseFormatted.add(expenseFormatted);
    }

    // Save the formatted list to Hive
    _myBox.put("ALL_EXPENSE", allExpenseFormatted);
  }

  // Read list of expenses from Hive
  List<ExpenseItem> readData() {
    List savedExpenses = _myBox.get("ALL_EXPENSE") ?? [];
    List<ExpenseItem> allExpenses = [];

    // Convert saved data back to ExpenseItem objects (deserialize DateTime)
    for (int i = 0; i < savedExpenses.length; i++) {
      String name = savedExpenses[i][0]; // Name
      String amount = savedExpenses[i][1]; // Amount
      DateTime dateTime = DateTime.parse(savedExpenses[i][2]); // Parse DateTime

      ExpenseItem expense = ExpenseItem(
        name: name,
        amount: amount,
        dateTime: dateTime,
      );
      allExpenses.add(expense);
    }

    return allExpenses;
  }
}
