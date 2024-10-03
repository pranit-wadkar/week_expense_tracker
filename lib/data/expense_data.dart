import 'package:flutter/material.dart';

import '../datetime/helper.dart';
import '../models/expense_item.dart';
import 'hive_database.dart';

class ExpenseData extends ChangeNotifier {
  // list of expenses
  List<ExpenseItem> overallExpenseList = [];

  // get list
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  // Hive database instance
  final db = HiveDatabase();

  // display
  void prepareData() {
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
  }

  // add new expense
  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // delete an expense
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // Get the name of the day (Mon, Tue, etc.)
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  // Get the start date of the week (Sunday)
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;
    DateTime today = DateTime.now();

    // Loop to find the last Sunday
    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        // Corrected to 'Sun'
        startOfWeek = today.subtract(Duration(days: i));
        break; // Exit loop once Sunday is found
      }
    }

    // Fallback to today if no Sunday is found (edge case)
    return startOfWeek ?? today;
  }

  // Calculate daily expense summary
  Map<String, double> calculateDailyEXpenseSummary() {
    Map<String, double> dailyExpenseSummary = {};

    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);

      // Error handling for invalid amount format
      try {
        double amount = double.parse(expense.amount);

        // If the date already exists in the summary, add to the existing amount
        if (dailyExpenseSummary.containsKey(date)) {
          double currentAmount = dailyExpenseSummary[date]!;
          dailyExpenseSummary[date] = currentAmount + amount;
        } else {
          dailyExpenseSummary[date] = amount;
        }
      } catch (e) {
        // Handle parsing error, could log or ignore invalid entries
        print('Error parsing amount: ${expense.amount}');
      }
    }

    return dailyExpenseSummary;
  }
}
