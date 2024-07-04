import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_ghr_wali/screens/expenses/add_expense/blocs/get_categories_bloc/bloc/get_categories_bloc.dart';
import 'package:smart_ghr_wali/screens/expenses/expense_home_screen.dart';

import '../../blocs/my_user_bloc/my_user_bloc.dart';
import '../../blocs/sign_in_bloc/sign_in_bloc.dart';
import '../../blocs/update_user_info_bloc/update_user_info_bloc.dart';
import '../expenses/add_expense/blocs/get_expenses_bloc/get_expenses_bloc.dart';
import '../incomes/add_income/blocs/get_icategories_bloc/bloc/get_icategories_bloc.dart';
import '../incomes/add_income/blocs/get_incomes_bloc/get_incomes_bloc.dart';
import '../incomes/income_home_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateUserInfoBloc, UpdateUserInfoState>(
      listener: (context, state) {
        if (state is UploadPictureSuccess) {
          setState(() {
            context.read<MyUserBloc>().state.user!.picture = state.userImage;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        floatingActionButton: BlocBuilder<MyUserBloc, MyUserState>(
          builder: (context, state) {
            if (state.status == MyUserStatus.success) {
              return FloatingActionButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute<void>(
                  //     builder: (BuildContext context) =>
                  //         BlocProvider<CreatePostBloc>(
                  //       create: (context) => CreatePostBloc(
                  //           postRepository: FirebasePostRepository()),
                  //       child: PostScreen(state.user!),
                  //     ),
                  //   ),
                  // );
                },
                child: const Icon(CupertinoIcons.add),
              );
            } else {
              return const FloatingActionButton(
                onPressed: null,
                child: Icon(CupertinoIcons.clear),
              );
            }
          },
        ),
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 250, 102, 213),
          foregroundColor: Theme.of(context).colorScheme.surface,
          title: BlocBuilder<MyUserBloc, MyUserState>(
            builder: (context, state) {
              if (state.status == MyUserStatus.success) {
                return Row(
                  children: [
                    state.user!.picture == ""
                        ? GestureDetector(
                            onTap: () async {
                              final ImagePicker picker = ImagePicker();
                              final XFile? image = await picker.pickImage(
                                  source: ImageSource.gallery,
                                  maxHeight: 500,
                                  maxWidth: 500,
                                  imageQuality: 40);
                              if (image != null) {
                                CroppedFile? croppedFile =
                                    await ImageCropper().cropImage(
                                  sourcePath: image.path,
                                  aspectRatio: const CropAspectRatio(
                                      ratioX: 1, ratioY: 1),
                                  aspectRatioPresets: [
                                    CropAspectRatioPreset.square
                                  ],
                                  uiSettings: [
                                    AndroidUiSettings(
                                        toolbarTitle: 'Cropper',
                                        toolbarColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        toolbarWidgetColor: Colors.white,
                                        initAspectRatio:
                                            CropAspectRatioPreset.original,
                                        lockAspectRatio: false),
                                    IOSUiSettings(
                                      title: 'Cropper',
                                    ),
                                  ],
                                );
                                if (croppedFile != null) {
                                  setState(() {
                                    context.read<UpdateUserInfoBloc>().add(
                                        UploadPicture(
                                            croppedFile.path,
                                            context
                                                .read<MyUserBloc>()
                                                .state
                                                .user!
                                                .id));
                                  });
                                }
                              }
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  shape: BoxShape.circle),
                              child: Icon(CupertinoIcons.person,
                                  color: Colors.grey.shade400),
                            ),
                          )
                        : Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(
                                      state.user!.picture!,
                                    ),
                                    fit: BoxFit.cover)),
                          ),
                    const SizedBox(width: 10),
                    Text("Welcome ${state.user!.name}")
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  context.read<SignInBloc>().add(const SignOutRequired());
                },
                icon: Icon(
                  CupertinoIcons.square_arrow_right,
                  color: Theme.of(context).colorScheme.surface,
                ))
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'What would you like to check?',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary, fontSize: 25.0),
            ),
            const Padding(padding: EdgeInsets.only(top: 50.0)),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 1 / 10,
                width: MediaQuery.of(context).size.width * 3 / 5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.tertiary,
                      ]),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text(""),
                    const Text(
                      "Incomes",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => GetIncCategoriesBloc(
                                  incomeRepository: context
                                      .read<GetIncomesBloc>()
                                      .incomeRepository)
                                ..add(GetIncCategories()),
                              child: const IncomeHomeScreen(),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: const Icon(
                          Icons.arrow_right_alt_outlined,
                          size: 25.0,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 1 / 10,
                width: MediaQuery.of(context).size.width * 3 / 5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.tertiary,
                      ]),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text(""),
                    const Text(
                      "Expenses",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => GetCategoriesBloc(
                                  expenseRepository: context
                                      .read<GetExpensesBloc>()
                                      .expenseRepository)
                                ..add(GetCategories()),
                              child: const ExpenseHomeScreen(),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: const Icon(
                          Icons.arrow_right_alt_outlined,
                          size: 25.0,
                          color: Colors.green,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 1 / 10,
                width: MediaQuery.of(context).size.width * 3 / 5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.tertiary,
                      ]),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text(""),
                    const Text(
                      "Notes",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: const Icon(
                          Icons.arrow_right_alt_outlined,
                          size: 25.0,
                          color: Colors.green,
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
