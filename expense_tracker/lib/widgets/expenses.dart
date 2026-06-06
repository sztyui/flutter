import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';


class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _Expenses();
}

class _Expenses extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
    Expense(
      title: 'MÁV bérlet',
      amount: 30.00,
      date: DateTime.now(),
      category: Category.travel,
    ),
    Expense(
      title: 'Kúrvák ❤️',
      amount: 69.99,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void _addExpense(Expense actual) {
    setState(() {
      _registeredExpenses.add(actual);
    });
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _removeExpense(Expense exp) {
    final expenseIndex = _registeredExpenses.indexOf(exp);
    setState(() {
      _registeredExpenses.remove(exp);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text('${exp.title} deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, exp);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onDeleteExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('ExpenseTracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600 
            ? Column(children: [
                Chart(expenses: _registeredExpenses),
                Expanded(child: mainContent)
                ],)
            : Row(children: [
              Expanded(child: Chart(expenses: _registeredExpenses,)),
              Expanded(child: mainContent)
            ],)

    );
  }
}
