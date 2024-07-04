import 'dart:math';
// import 'dart:developer' as devtools show log;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:income_repository/income_repository.dart';
import 'package:smart_ghr_wali/screens/incomes/stats/stats.dart';
import 'add_income/blocs/create_icategory_bloc/create_icategory_bloc.dart';
import 'add_income/blocs/create_income_bloc/create_income_bloc.dart';
import 'add_income/blocs/get_icategories_bloc/bloc/get_icategories_bloc.dart';
import 'add_income/views/add_income.dart';
import 'add_income/blocs/get_incomes_bloc/get_incomes_bloc.dart';
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
    return BlocBuilder<GetIncCategoriesBloc, GetIncCategoriesState>(
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
                            create: (context) => CreateIncCategoryBloc(
                                incomeRepository: context
                                    .read<GetIncomesBloc>()
                                    .incomeRepository),
                          ),
                          BlocProvider(
                            create: (context) => GetIncCategoriesBloc(
                                incomeRepository: context
                                    .read<GetIncomesBloc>()
                                    .incomeRepository)
                              ..add(GetIncCategories()),
                          ),
                          BlocProvider(
                            create: (context) => CreateIncomeBloc(
                                incomeRepository: context
                                    .read<GetIncomesBloc>()
                                    .incomeRepository),
                          ),
                        ],
                        child: const AddIncome(),
                      ),
                    ),
                  );
                  if (!context.mounted) return;
                  context.read<GetIncCategoriesBloc>().add(GetIncCategories());
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
                      create: (context) => GetIncCategoriesBloc(
                          incomeRepository:
                              context.read<GetIncomesBloc>().incomeRepository)
                        ..add(GetIncCategories()),
                      child: const IncomeMainScreen(),
                    )
                  : BlocProvider(
                      create: (context) => GetIncomesBloc(
                          incomeRepository:
                              context.read<GetIncomesBloc>().incomeRepository)
                        ..add(const GetIncomes()),
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