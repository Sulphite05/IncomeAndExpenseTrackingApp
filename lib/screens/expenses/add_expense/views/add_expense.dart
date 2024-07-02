import 'package:expense_repository/expense_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:smart_ghr_wali/screens/expenses/add_expense/blocs/get_expenses_bloc/get_expenses_bloc.dart';

import 'package:uuid/uuid.dart';

import '../blocs/create_expense_bloc/create_expense_bloc.dart';
import '../blocs/get_categories_bloc/bloc/get_categories_bloc.dart';
import 'category_creation.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController amountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  late Expense expense;
  late ExpCategory category;
  bool isLoading = false;

  @override
  void initState() {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    // expense = Expense.empty;
    // expense.category = ExpCategory.empty;
    // super.initState();
    // expense.expenseId = const Uuid().v1();
    super.initState();
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    expense = Expense.empty(const Uuid().v1());
    category = ExpCategory.empty('');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateExpenseBloc, CreateExpenseState>(
      listener: (context, state) {
        if (state is CreateExpenseSuccess) {
          Navigator.pop(context);
        } else if (state is CreateExpenseLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is CreateExpenseFailure) {
          setState(() {
            isLoading = false; // Hide loading indicator
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to create expense ${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          });
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context)
            .unfocus(), // every time I press outside, the focus diables
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
          body: BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
            builder: (context, state) {
              if (state.status == CategoriesOverviewStatus.success) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Add Expense',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextFormField(
                          controller: amountController,
                          decoration: InputDecoration(
                              filled: true,
                              hintText: 'Amount',
                              fillColor: Colors.white,
                              prefixIcon: const Icon(
                                FontAwesomeIcons.moneyBill1,
                                size: 16,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                            hintText: 'Name',
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(
                              FontAwesomeIcons.noteSticky,
                              size: 16,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            )),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Category',
                          filled: true,
                          fillColor: category.color == 0
                              ? Colors.white
                              : Color(category.color),
                          prefixIcon: category.icon == ''
                              ? const Icon(
                                  FontAwesomeIcons.list,
                                  size: 16,
                                  color: Colors.grey,
                                )
                              : Image.asset(
                                  'assets/${category.icon}.png',
                                  scale: 2,
                                ),
                          suffixIcon: IconButton(
                            onPressed: () async {
                              var newCategory =
                                  await getCategoryCreation(context);
                              setState(() {
                                state.categories.insert(0, newCategory);
                              });
                            },
                            icon: const Icon(
                              FontAwesomeIcons.plus,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        controller: categoryController,
                      ),
                      Container(
                          height: 200,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(12),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width,
                          // color: Colors.red,
                          child: ListView.builder(
                            itemCount: state.categories.length,
                            itemBuilder: (context, int i) {
                              return Card(
                                child: ListTile(
                                  onTap: () async {
                                    setState(() {
                                      // expense.category = state.categories[i];
                                      expense = expense.copyWith(
                                        categoryId:
                                            state.categories[i].categoryId,
                                      );
                                    });
                                    final categoryStream = context
                                        .read<GetExpensesBloc>()
                                        .expenseRepository
                                        .getCategories(
                                            categoryId: expense.categoryId);
                                    await for (final value in categoryStream) {
                                      category = value.first;
                                      break;
                                    }
                                    setState(() {
                                      categoryController.text = category.name;
                                    });
                                  },
                                  leading: Image.asset(
                                    'assets/${state.categories[i].icon}.png',
                                    scale: 2,
                                  ),
                                  title: Text(state.categories[i].name),
                                  tileColor: Color(state.categories[i].color),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            },
                          )),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: dateController,
                        onTap: () async {
                          DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: expense.date,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );

                          if (newDate != null) {
                            setState(() {
                              dateController.text =
                                  DateFormat('dd/MM/yyyy').format(newDate);
                              // expense.date = newDate;
                              expense.copyWith(date: newDate);
                            });
                          }
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                            hintText: 'Date',
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(
                              FontAwesomeIcons.clock,
                              size: 16,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            )),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: kToolbarHeight,
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : TextButton(
                                onPressed: () {
                                  if (category.name.isEmpty ||
                                      amountController.text.isEmpty ||
                                      nameController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Please fill in all fields.'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } else {
                                    // Update expense and category
                                    setState(() {
                                      expense = expense.copyWith(
                                        userId: FirebaseAuth
                                            .instance.currentUser!.uid,
                                        name: nameController.text,
                                        amount:
                                            int.parse(amountController.text),
                                      );
                                      // category.totalExpenses += expense.amount;
                                    });

                                    // Update category in the repository
                                    // context
                                    //     .read<GetExpensesBloc>()
                                    //     .expenseRepository
                                    //     .updateCategory(category);

                                    // Add the new expense
                                    context
                                        .read<CreateExpenseBloc>()
                                        .add(CreateExpense(expense));

                                    // Optionally, show a confirmation message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Expense saved successfully.'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                },
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    )),
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
