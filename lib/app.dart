import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:income_repository/income_repository.dart';
import 'package:note_repository/note_repository.dart';
import 'package:smart_ghr_wali/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:smart_ghr_wali/screens/expenses/add_expense/blocs/expenses_bloc/expenses_bloc.dart';
import 'package:user_repository/user_repository.dart';

import 'app_view.dart';
import 'screens/incomes/add_income/blocs/incomes_bloc/incomes_bloc.dart';
import 'screens/notes/blocs/notes_bloc/notes_bloc.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  final ExpenseRepository expenseRepository;
  final IncomeRepository incomeRepository;
  final NoteRepository noteRepository;
  const MyApp(this.userRepository, this.expenseRepository,
      this.incomeRepository, this.noteRepository,
      {super.key});

  @override
  Widget build(BuildContext context) {
    // return const MyAppView();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationBloc>(
          create: (_) => AuthenticationBloc(myUserRepository: userRepository),
        ),
        RepositoryProvider<ExpensesBloc>(
          create: (_) => ExpensesBloc(expenseRepository: expenseRepository),
        ),
        RepositoryProvider<IncomesBloc>(
          create: (_) => IncomesBloc(incomeRepository: incomeRepository),
        ),
        RepositoryProvider<NotesBloc>(
          create: (_) => NotesBloc(noteRepository: noteRepository),
        )
      ],
      child: const MyAppView(),
    );
  }
}
