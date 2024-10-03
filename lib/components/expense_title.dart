import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart'; // For better date formatting

class ExpenseTitle extends StatelessWidget {
  final String name;
  final String amount;
  final DateTime dateTime;
  final void Function(BuildContext)? deleteTapped; // Nullable deleteTapped

  const ExpenseTitle({
    super.key,
    required this.name,
    required this.amount,
    required this.dateTime,
    required this.deleteTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0), // Required in the new version
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          // Delete action
          SlidableAction(
            onPressed: deleteTapped ?? (_) {}, // Null check to avoid crashes
            icon: Icons.delete,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
      child: ListTile(
        title: Text(name),
        subtitle: Text(
          DateFormat('dd/MM/yyyy').format(dateTime), // Better date formatting
        ),
        trailing: Text('₹$amount'),
      ),
    );
  }
}
