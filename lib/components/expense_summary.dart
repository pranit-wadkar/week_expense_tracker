import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bar graph/bar_graph.dart';
import '../data/expense_data.dart';
import '../datetime/helper.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const ExpenseSummary({super.key, required this.startOfWeek});

  double calculateMax(
    ExpenseData value,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ) {
    List<double> values = [
      value.calculateDailyEXpenseSummary()[sunday] ?? 0,
      value.calculateDailyEXpenseSummary()[monday] ?? 0,
      value.calculateDailyEXpenseSummary()[tuesday] ?? 0,
      value.calculateDailyEXpenseSummary()[wednesday] ?? 0,
      value.calculateDailyEXpenseSummary()[thursday] ?? 0,
      value.calculateDailyEXpenseSummary()[friday] ?? 0,
      value.calculateDailyEXpenseSummary()[saturday] ?? 0,
    ];
    values.sort();
    double max = values.last * 1.1;
    return max == 0 ? 1000 : max; // Ensure the minimum is set
  }

  String calculateWeekTotal(
    ExpenseData value,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ) {
    List<double> values = [
      value.calculateDailyEXpenseSummary()[sunday] ?? 0,
      value.calculateDailyEXpenseSummary()[monday] ?? 0,
      value.calculateDailyEXpenseSummary()[tuesday] ?? 0,
      value.calculateDailyEXpenseSummary()[wednesday] ?? 0,
      value.calculateDailyEXpenseSummary()[thursday] ?? 0,
      value.calculateDailyEXpenseSummary()[friday] ?? 0,
      value.calculateDailyEXpenseSummary()[saturday] ?? 0,
    ];
    return values.reduce((a, b) => a + b).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    String sunday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 0)));
    String monday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 1)));
    String tuesday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 2)));
    String wednesday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 3)));
    String thursday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 4)));
    String friday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 5)));
    String saturday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 6)));

    return Consumer<ExpenseData>(
      builder: (context, value, child) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Week Total:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  '₹${calculateWeekTotal(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday)}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: MyBarGraph(
                maxY: calculateMax(value, sunday, monday, tuesday, wednesday,
                    thursday, friday, saturday),
                sunAmount: value.calculateDailyEXpenseSummary()[sunday] ?? 0,
                monAmount: value.calculateDailyEXpenseSummary()[monday] ?? 0,
                tueAmount: value.calculateDailyEXpenseSummary()[tuesday] ?? 0,
                wedAmount: value.calculateDailyEXpenseSummary()[wednesday] ?? 0,
                thurAmount: value.calculateDailyEXpenseSummary()[thursday] ?? 0,
                friAmount: value.calculateDailyEXpenseSummary()[friday] ?? 0,
                satAmount: value.calculateDailyEXpenseSummary()[saturday] ?? 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
