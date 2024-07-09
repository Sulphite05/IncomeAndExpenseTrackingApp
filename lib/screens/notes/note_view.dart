import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_repository/note_repository.dart';
import 'package:uuid/uuid.dart';

import 'blocs/notes_bloc/notes_bloc.dart';

class NoteViewScreen extends StatefulWidget {
  final Note? note;

  const NoteViewScreen({this.note, super.key});

  @override
  State<NoteViewScreen> createState() => _NoteViewScreenState();
}

class _NoteViewScreenState extends State<NoteViewScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.text ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    // Check if the note is being created or updated
    final isCreating = widget.note == null;

    if (_titleController.text.isNotEmpty ||
        _contentController.text.isNotEmpty) {
      Note note;
      if (isCreating) {
        // Creating a new note
        note = Note.empty('');
        note = note.copyWith(
          userId: FirebaseAuth.instance.currentUser!.uid,
          noteId: const Uuid().v1(),
          title: _titleController.text.isNotEmpty
              ? _titleController.text
              : _contentController.text.length > 12
                  ? _contentController.text.substring(0, 11)
                  : _contentController.text,
          text: _contentController.text,
        );
      } else {
        // Updating an existing note
        note = widget.note!.copyWith(
          title: _titleController.text.isNotEmpty
              ? _titleController.text
              : _contentController.text.substring(0, 12),
          text: _contentController.text,
          updatedAt: DateTime.now(),
        );
      }

      // Dispatch event to NotesBloc
      if (isCreating == true) {
        context.read<NotesBloc>().add(CreateNote(note));
      } else {
        context.read<NotesBloc>().add(UpdateNote(note));
      }

      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _saveNote,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ],
        ),
      ),
    );
  }
}
