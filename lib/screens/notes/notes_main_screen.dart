import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:note_repository/note_repository.dart';
import 'package:smart_ghr_wali/screens/notes/note_view.dart';
import 'blocs/notes_bloc/notes_bloc.dart';

class NotesMainScreen extends StatefulWidget {
  const NotesMainScreen({super.key});

  @override
  State<NotesMainScreen> createState() => _NotesMainScreenState();
}

class _NotesMainScreenState extends State<NotesMainScreen> {
  final List<int> _avatarColors = [
    0xFF00B2E7,
    0xFFE064F7,
    0xFFFF8D6C,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Welcome to Notes'),
            backgroundColor: const Color.fromARGB(255, 250, 102, 213),
          ),
          body: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.notes.length,
                      itemBuilder: (context, index) {
                        final note = state.notes[index];
                        final colorIndex = index % _avatarColors.length;
                        final color = _avatarColors[colorIndex];
                        return Dismissible(
                          key: ValueKey(note.noteId),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            context
                                .read<NotesBloc>()
                                .add(DeleteNote(note.noteId));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Note deleted'),
                              ),
                            );
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            leading: CircleAvatar(
                              backgroundColor: Color(color),
                              child: Text(
                                (index + 1).toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Text(
                              note.title,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            subtitle: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: DateFormat(
                                            "'At' HH:mm:ss 'on' dd-MM-yy")
                                        .format(note.updatedAt),
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.6),
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute<Note?>(
                                        builder: (BuildContext context) =>
                                            NewNoteScreen(
                                          note: note,
                                        ),
                                      ),
                                    );
                                    if (!context.mounted) return;
                                    context.read<NotesBloc>().add(GetNotes());
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute<Note?>(
                  builder: (BuildContext context) => const NewNoteScreen(),
                ),
              );
              if (!context.mounted) return;
              context.read<NotesBloc>().add(GetNotes());
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
        );
      },
    );
  }
}
