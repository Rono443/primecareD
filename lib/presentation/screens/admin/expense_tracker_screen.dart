import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class Expense {
  String id;
  String title;
  String category;
  double amount;
  DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
  });
}

class ExpenseTrackerScreen extends StatefulWidget {
  const ExpenseTrackerScreen({super.key});

  @override
  State<ExpenseTrackerScreen> createState() => _ExpenseTrackerScreenState();
}

class _ExpenseTrackerScreenState extends State<ExpenseTrackerScreen> {
  final List<Expense> _expenses = [
    Expense(id: '1', title: 'Electricity Bill', category: 'Utilities', amount: 15000, date: DateTime.now()),
    Expense(id: '2', title: 'Detergent Restock', category: 'Supplies', amount: 8500, date: DateTime.now()),
    Expense(id: '3', title: 'Rent - Westlands', category: 'Fixed', amount: 120000, date: DateTime.now()),
  ];

  final List<String> _categories = ['Utilities', 'Supplies', 'Fixed', 'Maintenance', 'Marketing', 'Wages'];

  void _showExpenseDialog([Expense? expense]) {
    final titleController = TextEditingController(text: expense?.title);
    final amountController = TextEditingController(text: expense?.amount.toString());
    String selectedCat = expense?.category ?? _categories[0];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(expense == null ? 'Log Expense' : 'Edit Expense', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Description')),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCat,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) => setDialogState(() => selectedCat = val!),
                ),
                const SizedBox(height: 16),
                TextField(controller: amountController, decoration: const InputDecoration(labelText: 'Amount (KES)', prefixText: 'KES '), keyboardType: TextInputType.number),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (expense == null) {
                    _expenses.add(Expense(
                      id: DateTime.now().toString(),
                      title: titleController.text,
                      category: selectedCat,
                      amount: double.tryParse(amountController.text) ?? 0,
                      date: DateTime.now(),
                    ));
                  } else {
                    expense.title = titleController.text;
                    expense.category = selectedCat;
                    expense.amount = double.tryParse(amountController.text) ?? 0;
                  }
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteExpense(String id) {
    setState(() => _expenses.removeWhere((e) => e.id == id));
  }

  @override
  Widget build(BuildContext context) {
    double total = _expenses.fold(0, (sum, e) => sum + e.amount);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Business Expenses')),
      body: Column(
        children: [
          _buildSummaryCard(total),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                final ex = _expenses[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_outward, color: Colors.red, size: 20),
                    ),
                    title: Text(ex.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${ex.category} • ${_formatDate(ex.date)}', style: const TextStyle(fontSize: 12)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('KES ${ex.amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                        const SizedBox(width: 8),
                        PopupMenuButton(
                          icon: const Icon(Icons.more_vert_rounded),
                          onSelected: (val) {
                            if (val == 'edit') _showExpenseDialog(ex);
                            if (val == 'delete') _deleteExpense(ex.id);
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'edit', child: Text('Edit')),
                            const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showExpenseDialog(),
        label: const Text('New Expense'),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.secondary,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}';
  }

  Widget _buildSummaryCard(double total) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.secondary, Color(0xFF323B45)]),
        borderRadius: BorderRadius.circular(32),
        boxShadow: AppColors.softGlow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Monthly Total', style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 8),
              Text('KES ${total.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: const Icon(Icons.trending_down_rounded, color: Colors.redAccent, size: 32),
          ),
        ],
      ),
    );
  }
}
