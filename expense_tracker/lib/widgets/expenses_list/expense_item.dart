import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work
};

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(
    this.expense, {
    super.key,
    required this.onDelete, // Callback function to trigger deletion
  });

  final Expense expense;
  final Function(Expense) onDelete;

  void _callOnDelete() {
    onDelete(expense);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Main content padding container
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              top: 16,
              bottom: 16,
              right: 48, // Extra right padding prevents text from overlapping the button
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  style: Theme.of(context).textTheme.titleLarge
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      '\$${expense.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          categoryIcons[expense.category],
                          size: 20,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          expense.formattedDate,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Positioned delete button in the top right corner
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              onPressed: _callOnDelete,
              icon: Icon(
                Icons.delete_outline,
                size: 20,
                color: Theme.of(context).colorScheme.error, // Uses theme's error/red color
              ),
              visualDensity: VisualDensity.compact, // Compact footprint
              tooltip: 'Delete Expense',
            ),
          ),
        ],
      ),
    );
  }
}
