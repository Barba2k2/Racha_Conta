// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/text_strings.dart';
import '../../controllers/theme_controller/theme_controller.dart';
import '../../models/expense_model.dart';
import 'chart/chart.dart';
import 'expanses_list/expenses_list.dart';
import '../new_expense/new_expense.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({Key? key, this.expenseModel}) : super(key: key);
  final ExpenseModel? expenseModel;

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final List<ExpenseModel> _registeredExpenses = [
    ExpenseModel(
      title: 'Jetete',
      ammount: 19.99,
      date: DateTime.now(),
      category: Category.trabalho,
      description: 'Teste',
      expenseId: 'Despesa001',
      userId: '',
    ),
    ExpenseModel(
      title: 'Cinema',
      ammount: 15.69,
      date: DateTime.now(),
      category: Category.lazer,
      description: 'Pipoca e ingresso',
      expenseId: 'Despesa002',
      userId: '',
    ),
  ];

  void _openAddExpanseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
      ),
    );
  }

  void _addExpense(ExpenseModel expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(ExpenseModel expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: Text('Despesa apagada.'),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(
                expenseIndex,
                expense,
              );
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;
    Widget mainContent = const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(emptyExpenses),
      ),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpenseList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Racha Conta',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(color: whiteColor),
        ),
        centerTitle: true,
        backgroundColor: tPrimaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: _openAddExpanseOverlay,
            icon: Icon(
              Icons.add,
              size: 32,
            ),
          ),
        ],
      ),
      body: Container(
        color: isDark ? darkNavBar : Color(0xFFF5F5F5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Chart(expenses: _registeredExpenses),
            Expanded(
              child: mainContent,
            ),
          ],
        ),
      ),
    );
  }
}
