import 'dart:math';
// import 'dart:developer' as devtools show log;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:income_repository/income_repository.dart';
import 'package:smart_ghr_wali/screens/incomes/stats/stats.dart';
import 'add_income/blocs/icategories_bloc/bloc/icategories_bloc.dart';
import 'add_income/views/add_income.dart';
import 'add_income/blocs/incomes_bloc/incomes_bloc.dart';
import 'income_main_screen.dart';

class IncomeHomeScreen extends StatefulWidget {
  const IncomeHomeScreen({super.key});

  @override
  State<IncomeHomeScreen> createState() => _IncomeHomeScreenState();
}

class _IncomeHomeScreenState extends State<IncomeHomeScreen> {
  int index = 0;
  Color selectedItem = Colors.blue;
  Color unselectedItem = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IncCategoriesBloc, IncCategoriesState>(
      builder: (context, state) {
        if (state.status == IncCategoriesOverviewStatus.success) {
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
                    MaterialPageRoute<IncCategory?>(
                      builder: (BuildContext context) => MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => IncCategoriesBloc(
                                incomeRepository: context
                                    .read<IncomesBloc>()
                                    .incomeRepository),
                          ),
                          BlocProvider(
                            create: (context) => IncCategoriesBloc(
                                incomeRepository: context
                                    .read<IncomesBloc>()
                                    .incomeRepository)
                              ..add(GetIncCategories()),
                          ),
                          BlocProvider(
                            create: (context) => IncomesBloc(
                                incomeRepository: context
                                    .read<IncomesBloc>()
                                    .incomeRepository),
                          ),
                        ],
                        child: const AddIncome(),
                      ),
                    ),
                  );
                  if (!context.mounted) return;
                  context.read<IncCategoriesBloc>().add(GetIncCategories());
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
                      create: (context) => IncCategoriesBloc(
                          incomeRepository:
                              context.read<IncomesBloc>().incomeRepository)
                        ..add(GetIncCategories()),
                      child: const IncomeMainScreen(),
                    )
                  : BlocProvider(
                      create: (context) => IncomesBloc(
                          incomeRepository:
                              context.read<IncomesBloc>().incomeRepository)
                        ..add(GetIncomes(
                            startDate: DateTime.now()
                                .subtract(const Duration(days: 7)),
                            endDate: DateTime.now())),
                      child: const StatScreen(),
                    ));
        } else if (state.status == IncCategoriesOverviewStatus.loading) {
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
