
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:income_repository/income_repository.dart';
import 'package:intl/intl.dart';

import '../../../../components/popup.dart';
import '../blocs/get_incomes_bloc/get_incomes_bloc.dart';
import 'update_income.dart';

class CategoryIncomesScreen extends StatefulWidget {
  final IncCategory category;
  const CategoryIncomesScreen({Key? key, required this.category})
      : super(key: key);

  @override
  State<CategoryIncomesScreen> createState() => _CategoryIncomesScreenState();
}

class _CategoryIncomesScreenState extends State<CategoryIncomesScreen> {
  Future<bool> showDeleteDialog(BuildContext context) {
    return showGenericDialog<bool>(
      context: context,
      title: 'Delete',
      content: 'Are you sure you want to delete this item?',
      optionsBuilder: () => {
        'Cancel': false,
        'Yes': true,
      },
    ).then((value) => value ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetIncomesBloc, GetIncomesState>(
      builder: (context, state) {
        if (state.status == IncomesOverviewStatus.success) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppBar(
              backgroundColor: Color(widget.category.color),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                widget.category.name,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/${widget.category.icon}.png',
                        scale: 2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    itemCount: state.incomes.length,
                    itemBuilder: (context, index) {
                      final income = state.incomes[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        leading: CircleAvatar(
                          backgroundColor: Color(widget.category.color),
                          child: Text(
                            (index + 1).toString(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          income.name,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        subtitle: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Rs. ${income.amount}\n',
                                style: TextStyle(
                                  height: 2,
                                  fontSize: 14.0,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: DateFormat("'At' HH:mm:ss 'on' dd-MM-yy")
                                    .format(income.date),
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.6),
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              onPressed: () async {
                                await updateIncome(
                                  context,
                                  income,
                                  widget.category.categoryId,
                                );
                                if (!context.mounted) return;
                                context.read<GetIncomesBloc>().add(GetIncomes(
                                    incCategoryId: widget.category.categoryId));
                              },
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.delete_outline_rounded,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                onPressed: () async {
                                  bool check = await showDeleteDialog(context);
                                  if (check) {
                                    if (!context.mounted) return;
                                    context.read<GetIncomesBloc>().add(
                                        DeleteIncome(income.incomeId,
                                            widget.category.categoryId));
                                  }
                                }),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        thickness: 1,
                        color: Colors.grey,
                        indent: 16,
                        endIndent: 16,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (state.status == IncomesOverviewStatus.loading) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppBar(
              backgroundColor: Color(widget.category.color),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                widget.category.name,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/${widget.category.icon}.png',
                        scale: 2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: const Center(
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
