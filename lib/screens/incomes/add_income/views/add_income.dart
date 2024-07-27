import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:income_repository/income_repository.dart';
import 'package:intl/intl.dart';

import 'package:uuid/uuid.dart';

import '../../../expenses/add_expense/views/category_creation.dart';
import '../blocs/icategories_bloc/bloc/icategories_bloc.dart';
import '../blocs/incomes_bloc/incomes_bloc.dart';

class AddIncome extends StatefulWidget {
  const AddIncome({super.key});

  @override
  State<AddIncome> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  TextEditingController amountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  late Income income;
  late IncCategory category;
  bool isLoading = false;

  @override
  void initState() {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    super.initState();
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    income = Income.empty(const Uuid().v1());
    category = IncCategory.empty('');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IncomesBloc, IncomesState>(
      listener: (context, state) {
        if (state.status == IncomesOverviewStatus.success) {
        } else if (state.status == IncomesOverviewStatus.loading) {
          setState(() {
            isLoading = true;
          });
        } else if (state.status == IncomesOverviewStatus.failure) {
          setState(() {
            isLoading = false; // Hide loading indicator
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to create Income ${state}'),
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
          body: BlocBuilder<IncCategoriesBloc, IncCategoriesState>(
            builder: (context, state) {
              if (state.status == IncCategoriesOverviewStatus.success) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Add Income',
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
                                  'assets/incomes/${category.icon}.png',
                                  scale: 2,
                                ),
                          suffixIcon: IconButton(
                            onPressed: () async {
                              await getCategoryCreation(context);
                              setState(() {
                                context
                                    .read<IncCategoriesBloc>()
                                    .add(GetIncCategories());
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
                          child: ListView.builder(
                            itemCount: state.incCategories.length,
                            itemBuilder: (context, int i) {
                              return Card(
                                child: ListTile(
                                  onTap: () async {
                                    setState(() {
                                      // income.category = state.incCategories[i];
                                      income = income.copyWith(
                                        categoryId:
                                            state.incCategories[i].categoryId,
                                      );
                                    });
                                    final categoryStream = context
                                        .read<IncomesBloc>()
                                        .incomeRepository
                                        .getCategories(
                                            categoryId: income.categoryId);
                                    await for (final value in categoryStream) {
                                      category = value.first;
                                      break;
                                    }
                                    setState(() {
                                      categoryController.text = category.name;
                                    });
                                  },
                                  leading: Image.asset(
                                    'assets/incomes/${state.incCategories[i].icon}.png',
                                    scale: 2,
                                  ),
                                  title: Text(state.incCategories[i].name),
                                  tileColor:
                                      Color(state.incCategories[i].color),
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
                            initialDate: income.date,
                            firstDate:
                                DateTime.now().add(const Duration(days: -365)),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );

                          if (newDate != null) {
                            setState(() {
                              dateController.text =
                                  DateFormat('dd/MM/yyyy').format(newDate);
                              income = income.copyWith(date: newDate);
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
                                    // Update Income and category
                                    setState(() {
                                      income = income.copyWith(
                                        userId: FirebaseAuth
                                            .instance.currentUser!.uid,
                                        name: nameController.text,
                                        amount:
                                            int.parse(amountController.text),
                                      );
                                    });

                                    context
                                        .read<IncomesBloc>()
                                        .add(CreateIncome(income));

                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Income saved successfully.'),
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
