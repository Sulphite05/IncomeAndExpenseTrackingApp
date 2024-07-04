import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_ghr_wali/screens/expenses/add_expense/blocs/get_expenses_bloc/get_expenses_bloc.dart';

Future<void> updateExpense(
    BuildContext context, Expense expense, String categoryId) {
  return showDialog(
      context: context,
      builder: (ctx) {
        TextEditingController expenseAmountController = TextEditingController();
        TextEditingController expenseNameController = TextEditingController();
        bool isLoading = false;

        return BlocProvider.value(
          value: context.read<GetExpensesBloc>(),
          child: StatefulBuilder(builder: (ctx, setState) {
            return BlocListener<GetExpensesBloc, GetExpensesState>(
              listener: (context, state) {
                if (state.status == ExpensesOverviewStatus.success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Expense updated successfully.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state.status == ExpensesOverviewStatus.loading) {
                  setState(() {
                    isLoading = true;
                  });
                } else if (state.status == ExpensesOverviewStatus.failure) {
                  setState(() {
                    isLoading = false; // Hide loading indicator
                  });
                  // Show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to update expense'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: AlertDialog(
                title: const Text(
                  'Update Expense',
                ),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextFormField(
                          controller: expenseAmountController,
                          decoration: InputDecoration(
                              filled: true,
                              hintText: ' Rs ${expense.amount}',
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
                        controller: expenseNameController,
                        decoration: InputDecoration(
                            hintText: expense.name,
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
                      SizedBox(
                        width: double.infinity,
                        height: kToolbarHeight,
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : TextButton(
                                onPressed: () {
                                  if (expenseNameController.text.isEmpty) {
                                    expenseNameController.text = expense.name;
                                  }
                                  if (expenseAmountController.text.isEmpty) {
                                    expenseAmountController.text =
                                        expense.amount.toString();
                                  }

                                  final updatedExpense = expense.copyWith(
                                    name: expenseNameController.text,
                                    amount:
                                        int.parse(expenseAmountController.text),
                                  );

                                  context.read<GetExpensesBloc>().add(
                                      UpdateExpense(
                                          updatedExpense, categoryId));
                                  Navigator.pop(ctx);
                                  
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
                ),
              ),
            );
          }),
        );
      });
}
