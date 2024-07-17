import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:income_repository/income_repository.dart';

import '../blocs/incomes_bloc/incomes_bloc.dart';

Future<void> updateIncome(
    BuildContext context, Income income, String categoryId) {
  return showDialog(
      context: context,
      builder: (ctx) {
        TextEditingController incomeAmountController = TextEditingController();
        TextEditingController incomeNameController = TextEditingController();
        bool isLoading = false;

        return BlocProvider.value(
          value: context.read<GetIncomesBloc>(),
          child: StatefulBuilder(builder: (ctx, setState) {
            return BlocListener<GetIncomesBloc, GetIncomesState>(
              listener: (context, state) {
                if (state.status == IncomesOverviewStatus.success) {
                } else if (state.status == IncomesOverviewStatus.loading) {
                  setState(() {
                    isLoading = true;
                  });
                } else if (state.status == IncomesOverviewStatus.failure) {
                  setState(() {
                    isLoading = false; // Hide loading indicator
                  });
                  // Show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to update income'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: AlertDialog(
                title: const Text(
                  'Update Income',
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
                          controller: incomeAmountController,
                          decoration: InputDecoration(
                              filled: true,
                              hintText: ' Rs ${income.amount}',
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
                        controller: incomeNameController,
                        decoration: InputDecoration(
                            hintText: income.name,
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
                                  if (incomeNameController.text.isEmpty) {
                                    incomeNameController.text = income.name;
                                  }
                                  if (incomeAmountController.text.isEmpty) {
                                    incomeAmountController.text =
                                        income.amount.toString();
                                  }

                                  final updatedIncome = income.copyWith(
                                    name: incomeNameController.text,
                                    amount:
                                        int.parse(incomeAmountController.text),
                                  );

                                  context.read<GetIncomesBloc>().add(
                                      UpdateIncome(updatedIncome, categoryId));
                                  Navigator.pop(ctx);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Income updated successfully.'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
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
