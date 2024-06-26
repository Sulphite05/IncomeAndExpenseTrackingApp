import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_ghr_wali/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:smart_ghr_wali/screens/authentication/welcome_screen.dart';
import 'package:smart_ghr_wali/screens/home/home_screen.dart';
import 'blocs/my_user_bloc/my_user_bloc.dart';
import 'blocs/sign_in_bloc/sign_in_bloc.dart';
import 'blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'consts/color_consts.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense Tracker',
        theme: ThemeData(
            colorScheme: ColorScheme.light(
          surface: Colors.grey.shade100,
          onSurface: Colors.black,
          primary: const Color(blue),
          onPrimary: Colors.white,
          secondary: const Color(magenta),
          onSecondary: Colors.white,
          tertiary: const Color(orange),
          outline: Colors.grey,
          error: Colors.red,
        )),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => SignInBloc(
                        userRepository:
                            context.read<AuthenticationBloc>().userRepository),
                  ),
                  BlocProvider(
                    create: (context) => UpdateUserInfoBloc(
                        userRepository:
                            context.read<AuthenticationBloc>().userRepository),
                  ),
                  BlocProvider(
                    create: (context) => MyUserBloc(
                        myUserRepository:
                            context.read<AuthenticationBloc>().userRepository)
                      ..add(GetMyUser(
                          myUserId: context
                              .read<AuthenticationBloc>()
                              .state
                              .user!
                              .uid)),
                  ),
                ],
                child: const HomeScreen(),
              );
            } else {
              return const WelcomeScreen();
            }
          },
        )
        );
  }
}
