import 'package:expense_repository/expense_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:uuid/uuid.dart';

import '../blocs/categories_bloc/bloc/categories_bloc.dart';

Future getCategoryCreation(BuildContext context) {
  List<String> myCategoriesIcons = [
    'entertainment',
    'food',
    'home',
    'pet',
    'shopping',
    'tech',
    'travel',
    'more',
  ];
  return showDialog(
      context: context,
      builder: (ctx) {
        bool isExpended = false;
        String iconSelected = '';
        Color categoryColor = Colors.pink;
        TextEditingController categoryNameController = TextEditingController();
        TextEditingController categoryIconController = TextEditingController();
        TextEditingController categoryColorController = TextEditingController();
        bool isLoading = false;
        ExpCategory category = ExpCategory.empty('');

        return BlocProvider.value(
          value: context.read<CategoriesBloc>(),
          child: StatefulBuilder(builder: (ctx, setState) {
            return BlocListener<CategoriesBloc, CategoriesState>(
              listener: (context, state) {
                if (state.status == CategoriesOverviewStatus.success) {
                  Navigator.pop(ctx);
                } else if (state.status == CategoriesOverviewStatus.loading) {
                  setState(() {
                    isLoading = true;
                  });
                } else if (state.status == CategoriesOverviewStatus.failure) {
                  setState(() {
                    isLoading = false; // Hide loading indicator
                  });
                  // Show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to create expense'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: StatefulBuilder(builder: (ctx, setState) {
                return AlertDialog(
                  title: const Text(
                    'Create a Category',
                  ),
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: categoryNameController,
                          decoration: InputDecoration(
                              hintText: 'Name',
                              isDense: true,
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              )),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: categoryIconController,
                          onTap: () {
                            setState(() {
                              isExpended = !isExpended;
                            });
                          },
                          readOnly: true,
                          decoration: InputDecoration(
                              isDense: true,
                              hintText: 'Icon',
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: const Icon(
                                CupertinoIcons.chevron_down,
                                size: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: isExpended
                                    ? const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      )
                                    : BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              )),
                        ),
                        isExpended
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                height: 200,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(12),
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 5,
                                        crossAxisSpacing: 5,
                                      ),
                                      itemCount: myCategoriesIcons.length,
                                      itemBuilder: (context, int i) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(
                                              () {
                                                iconSelected =
                                                    myCategoriesIcons[i];
                                              },
                                            );
                                          },
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 3,
                                                  color: iconSelected ==
                                                          myCategoriesIcons[i]
                                                      ? Colors.green
                                                      : Colors.grey,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                  'assets/expenses/${myCategoriesIcons[i]}.png',
                                                ))),
                                          ),
                                        );
                                      }),
                                ),
                              )
                            : Container(),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: categoryColorController,
                          readOnly: true,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (ctx2) {
                                  return AlertDialog(
                                    content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ColorPicker(
                                            pickerColor:
                                                categoryColor, // initial pointer to a colour
                                            onColorChanged: (value) {
                                              setState(() {
                                                categoryColor = value;
                                              });
                                            },
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              style: TextButton.styleFrom(
                                                  backgroundColor: Colors.black,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  )),
                                              child: const Text(
                                                'Save Color',
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )
                                        ]),
                                  );
                                });
                          },
                          decoration: InputDecoration(
                              isDense: true,
                              hintText: 'Color',
                              filled: true,
                              fillColor: categoryColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              )),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: kToolbarHeight,
                          child: isLoading == true
                              ? const Center(child: CircularProgressIndicator())
                              : TextButton(
                                  onPressed: () {
                                    setState(() {
                                      category = ExpCategory(
                                          totalExpenses: 0,
                                          userId: FirebaseAuth
                                              .instance.currentUser!.uid,
                                          categoryId: const Uuid().v1(),
                                          name: categoryNameController.text,
                                          icon: iconSelected,
                                          color: categoryColor.value);
                                    });
                                    context
                                        .read<CategoriesBloc>()
                                        .add(CreateCategory(category));
                                    // Navigator.of(context).pop();
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
                  ),
                );
              }),
            );
          }),
        );
      });
}
