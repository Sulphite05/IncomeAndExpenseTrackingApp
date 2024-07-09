import 'dart:math';
// import 'dart:developer' as devtools show log;
import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_expense/stats/stats.dart';
import 'add_expense/blocs/create_category_bloc/create_category_bloc.dart';
import 'add_expense/blocs/create_expense_bloc/create_expense_bloc.dart';
import 'add_expense/blocs/get_categories_bloc/bloc/get_categories_bloc.dart';
import 'add_expense/views/add_expense.dart';
import 'add_expense/blocs/get_expenses_bloc/get_expenses_bloc.dart';
import 'expense_main_screen.dart';

class ExpenseHomeScreen extends StatefulWidget {
  const ExpenseHomeScreen({super.key});

  @override
  State<ExpenseHomeScreen> createState() => _ExpenseHomeScreenState();
}

class _ExpenseHomeScreenState extends State<ExpenseHomeScreen> {
  int index = 0;
  Color selectedItem = Colors.blue;
  Color unselectedItem = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
      builder: (context, state) {
        if (state.status == CategoriesOverviewStatus.success) {
          return Scaffold(
              bottomNavigationBar: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30)),
                child: BottomNavigationBar(
                  onTap: (value) {
                    setState(() {
                      index = value;
                    });
                  },
                  backgroundColor: Colors.white,
                  showSelectedLabels: false, // icon labels won't appear
                  showUnselectedLabels: false,
                  elevation: 3,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(
                        CupertinoIcons.home,
                        color: index == 0 ? selectedItem : unselectedItem,
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        CupertinoIcons.graph_square_fill,
                        color: index == 1 ? selectedItem : unselectedItem,
                      ),
                      label: 'Stats',
                    ),
                  ],
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute<ExpCategory?>(
                      builder: (BuildContext context) => MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => CreateCategoryBloc(
                                expenseRepository: context
                                    .read<GetExpensesBloc>()
                                    .expenseRepository),
                          ),
                          BlocProvider(
                            create: (context) => GetCategoriesBloc(
                                expenseRepository: context
                                    .read<GetExpensesBloc>()
                                    .expenseRepository)
                              ..add(GetCategories()),
                          ),
                          BlocProvider(
                            create: (context) => CreateExpenseBloc(
                                expenseRepository: context
                                    .read<GetExpensesBloc>()
                                    .expenseRepository),
                          ),
                        ],
                        child: const AddExpense(),
                      ),
                    ),
                  );
                  if (!context.mounted) return;
                  context.read<GetCategoriesBloc>().add(GetCategories());
                },
                shape: const CircleBorder(),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.tertiary,
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.primary,
                        ],
                        transform: const GradientRotation(pi / 4),
                      ),
                      shape: BoxShape.circle),
                  child: const Icon(CupertinoIcons.add),
                ),
              ),
              body: index == 0
                  ? BlocProvider(
                      create: (context) => GetCategoriesBloc(
                          expenseRepository:
                              context.read<GetExpensesBloc>().expenseRepository)
                        ..add(GetCategories()),
                      child: const ExpenseMainScreen(),
                    )
                  : BlocProvider(
                      create: (context) => GetExpensesBloc(
                          expenseRepository:
                              context.read<GetExpensesBloc>().expenseRepository)
                        ..add(GetExpenses(
                            startDate: DateTime.now()
                                .subtract(const Duration(days: 7)),
                            endDate: DateTime.now())),
                      child: const StatScreen(),
                    ));
        } else if (state.status == CategoriesOverviewStatus.loading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return const Scaffold();
        }
      },
    );
  }
}
