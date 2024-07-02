import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_ghr_wali/screens/expenses/add_expense/blocs/get_categories_bloc/bloc/get_categories_bloc.dart';
import 'package:smart_ghr_wali/screens/expenses/add_expense/blocs/get_expenses_bloc/get_expenses_bloc.dart';

import 'add_expense/views/category_expenses.dart';

class ExpenseMainScreen extends StatefulWidget {
  const ExpenseMainScreen({super.key});

  @override
  State<ExpenseMainScreen> createState() => _ExpenseMainScreenState();
}

class _ExpenseMainScreenState extends State<ExpenseMainScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
      builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(CupertinoIcons.back),
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.yellow[700],
                              ),
                            ),
                            Icon(
                              CupertinoIcons.money_dollar,
                              color: Colors.yellow[900],
                              size: 40,
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome to',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.outline),
                            ),
                            Text(
                              'Expenses',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(CupertinoIcons.settings),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.tertiary,
                        ],
                        transform: const GradientRotation(pi / 4),
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 4,
                            color: Colors.grey.shade300,
                            offset: const Offset(5, 5))
                      ]),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Total Balance',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text(
                          'Rs. 400,000',
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: const BoxDecoration(
                                        color: Colors.white30,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          CupertinoIcons.arrow_down,
                                          size: 12,
                                          color: Colors.greenAccent,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Income',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          'Rs. 20,000',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: const BoxDecoration(
                                        color: Colors.white30,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          CupertinoIcons.arrow_down,
                                          size: 12,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Expense',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          'Rs. 15,000',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ]),
                        ),
                      ]),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transactions',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.outline,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      final category = state.categories[index];
                      return InkWell(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => GetExpensesBloc(
                                      expenseRepository: context
                                          .read<GetExpensesBloc>()
                                          .expenseRepository)
                                    ..add(GetExpenses(
                                        categoryId: category.categoryId)),
                                  child: CategoryExpensesScreen(
                                    category: category,
                                  ),
                                ),
                              ),
                            );
                            setState(() {
                              context
                                  .read<GetCategoriesBloc>()
                                  .add(GetCategories());
                            });
                          },
                          child: Padding(
                            key: ValueKey(category.categoryId),
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Color(category.color),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            Image.asset(
                                              'assets/${category.icon}.png',
                                              scale: 2,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 12.0,
                                        ),
                                        Text(
                                          category.name,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Rs. ${category.totalExpenses}.00',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ));
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
