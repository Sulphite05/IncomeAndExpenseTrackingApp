import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_ghr_wali/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:user_repository/user_repository.dart';

import 'app_view.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  const MyApp(this.userRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    // return const MyAppView();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationBloc>(
          create: (_) => AuthenticationBloc(myUserRepository: userRepository),
        ),
      ],
      child: const MyAppView(),
    );
  }
}
