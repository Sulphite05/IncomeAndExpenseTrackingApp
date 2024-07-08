import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:income_repository/income_repository.dart';
import 'package:note_repository/note_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'app.dart';
import 'simple_bloc_observer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp(FirebaseUserRepository(), FirebaseExpenseRepo(), FirebaseIncomeRepo(), FirebaseNoteRepo()));
}
