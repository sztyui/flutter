import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onDeleteExpense,
  });

  final List<Expense> expenses;
  final void Function(Expense) onDeleteExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(expenses[index]),
        background: Container(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.75),
          margin: EdgeInsets.symmetric(horizontal: Theme.of(context).cardTheme.margin!.horizontal),
        ),
        child: ExpenseItem(expenses[index], onDelete: onDeleteExpense),
        onDismissed: (direction) {
          if(direction == DismissDirection.endToStart){
            onDeleteExpense(expenses[index]);
          }
          else if(direction == DismissDirection.startToEnd){
            
          }
        },
      ),
    );
  }
}
