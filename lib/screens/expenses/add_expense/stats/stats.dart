import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:smart_ghr_wali/screens/expenses/add_expense/blocs/get_expenses_bloc/get_expenses_bloc.dart';
import 'aggregate_expenses.dart';
import 'chart.dart';

class StatScreen extends StatelessWidget {
  const StatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetExpensesBloc, GetExpensesState>(
      builder: (context, state) {
        if (state.status == ExpensesOverviewStatus.success) {
          final aggregatedExpenses = aggregateExpensesByDay(state.expenses);

          // Calculate date range
          final now = DateTime.now();
          final startDate = now.subtract(const Duration(days: 7));
          final endDate = now;

          // Format the dates
          final dateFormat = DateFormat('MMM d, yyyy');
          final startDateStr = dateFormat.format(startDate);
          final endDateStr = dateFormat.format(endDate);

          return SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Total Transactions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'From $startDateStr to $endDateStr',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[1000],
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
                      child: MyChart(
                          aggregatedExpenses: aggregatedExpenses,
                          context: context),
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
