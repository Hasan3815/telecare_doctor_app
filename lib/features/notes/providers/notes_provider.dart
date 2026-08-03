import 'dart:async';

import 'package:flutter/material.dart';
import 'package:telecare_doctor_app/features/notes/models/session_note_model.dart';

import '../../../core/utils/app_loggers.dart';
import '../services/notes_service.dart';

class NotesProvider extends ChangeNotifier {
  NotesProvider({
    NotesService? notesService,
  }) : _notesService = notesService ?? NotesService();

  final NotesService _notesService;

  bool _isSaving = false;

  String? _errorMessage;

  bool get isSaving => _isSaving;

  String? get errorMessage => _errorMessage;

  Stream<List<SessionNoteModel>> getNotes({
  required String appointmentId,
}) {
  return _notesService.getNotes(
    appointmentId: appointmentId,
  );
}

  Future<bool> addNote({
  required String appointmentId,
  required String doctorId,
  required String note,
}) async {
  if (note.trim().isEmpty) {
    _errorMessage =
        'Please enter a session note';

    notifyListeners();

    return false;
  }

  _isSaving = true;

  _errorMessage = null;

  notifyListeners();

  try {
    

    await _notesService.addNote(
      appointmentId:
          appointmentId,
      doctorId:
          doctorId,
      note:
          note.trim(),
    );

    

    return true;
  } catch (
    error,
    stackTrace
  ) {
    

    _errorMessage =
        error is TimeoutException
            ? 'The server did not respond. Please check your internet connection.'
            : 'Unable to save the note. Please try again.';

    AppLogger.error(
      'Session note save failed',
      error:
          error,
      stackTrace:
          stackTrace,
    );

    return false;
  } finally {
    _isSaving = false;

    notifyListeners();

    
  }
}
Future<bool> deleteNote({
  required String noteId,
}) async {
  try {
    await _notesService.deleteNote(
      noteId: noteId,
    );

    return true;
  } catch (error, stackTrace) {
    _errorMessage =
        'Unable to delete the note. Please try again.';

    AppLogger.error(
      'Session note delete failed',
      error: error,
      stackTrace: stackTrace,
    );

    notifyListeners();

    return false;
  }
}
}