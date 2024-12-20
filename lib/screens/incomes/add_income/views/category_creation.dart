
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:income_repository/income_repository.dart';
import 'package:uuid/uuid.dart';
import '../blocs/icategories_bloc/bloc/icategories_bloc.dart';

Future getCategoryCreation(BuildContext context) {
  List<String> myCategoriesIcons = [
    'bank',
    'briefcase',
    'dividend',
    'freelance',
    'gift',
    'handshake',
    'interest',
    'paycheck',
    'pension',
    'rent',
    'royalty',
    'shop',
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
        IncCategory category = IncCategory.empty('');

        return BlocProvider.value(
          value: context.read<IncCategoriesBloc>(),
          child: StatefulBuilder(builder: (ctx, setState) {
            return BlocListener<IncCategoriesBloc, IncCategoriesState>(
              listener: (context, state) {
                if (state.status == IncCategoriesOverviewStatus.success) {
                  Navigator.pop(ctx);
                } else if (state.status == IncCategoriesOverviewStatus.loading) {
                  setState(() {
                    isLoading = true;
                  });
                } else if (state.status == IncCategoriesOverviewStatus.failure) {
                  setState(() {
                    isLoading = false; // Hide loading indicator
                  });
                  // Show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to create income'),
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
                                                  'assets/incomes/${myCategoriesIcons[i]}.png',
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
                                  onPressed: () {     // create category object
                                    setState(() {
                                      category = IncCategory(
                                          totalIncomes: 0,
                                          userId: FirebaseAuth
                                              .instance.currentUser!.uid,
                                          categoryId: const Uuid().v1(),
                                          name: categoryNameController.text,
                                          icon: iconSelected,
                                          color: categoryColor.value);
                                    });
                                    context
                                        .read<IncCategoriesBloc>()
                                        .add(CreateIncCategory(category));
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
