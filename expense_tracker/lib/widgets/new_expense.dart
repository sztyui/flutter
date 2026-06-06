import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.food;

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount < 0;

    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text('Please make sure a valid data entered!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    var e = Expense(
      title: _titleController.text,
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory, // Uses the selected category
    );
    widget.onAddExpense(e);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _presentDatePicker() {
    final now = DateTime.now();
    showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1, now.month, now.day),
      lastDate: DateTime(now.year + 1, now.month, now.day),
    ).then((value) {
      if (value == null || value == _selectedDate) return;
      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(label: Text('Title')),
          ),
          const SizedBox(height: 16),
          // Row layout to put Amount and Date Picker side by side
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 24,
                  ), // Makes the entered text bigger
                  decoration: const InputDecoration(
                    prefixText: '\$ ',
                    label: Text('Amount'),
                    labelStyle: TextStyle(
                      fontSize: 16,
                    ), // Keeps label text readable
                  ),
                ),
              ),
              TextButton(
                onPressed: _presentDatePicker,
                style: ElevatedButton.styleFrom(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      size: 24, // Makes the icon smaller
                    ),
                    SizedBox(width: 2),
                    Text(
                      _selectedDate == null
                          ? 'Selected date'
                          : formatter.format(_selectedDate!),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Category Selector and Save Button Row
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 1),
              DropdownButton<Category>(
                value: _selectedCategory,
                items: Category.values.map((category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Row(
                      children: [
                        Icon(
                          categoryIcons[category],
                        ), // Displays the specific icon
                        const SizedBox(width: 8),
                        Text(
                          category.name.toUpperCase(),
                        ), // Displays the text name
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedCategory = value; // Saves selection to state
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _submitExpenseData,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.save),
                    SizedBox(width: 2),
                    Text('Save Expense'),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.cancel),
                    SizedBox(width: 2),
                    Text('Cancel'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
