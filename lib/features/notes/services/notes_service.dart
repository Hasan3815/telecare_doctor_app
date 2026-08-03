import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/session_note_model.dart';

class NotesService {
  NotesService({
    FirebaseFirestore? firestore,
  }) : _firestore =
            firestore ??
                FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>>
      get _notesCollection {
    return _firestore.collection(
      'session_notes',
    );
  }

  Stream<List<SessionNoteModel>> getNotes({
    required String appointmentId,
  }) {
    return _notesCollection
        .where(
          'appointmentId',
          isEqualTo: appointmentId,
        )
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs
            .map(
              SessionNoteModel
                  .fromFirestore,
            )
            .toList();
      },
    );
  }

  Future<void> addNote({
    required String appointmentId,
    required String doctorId,
    required String note,
  }) async {
    final document =
        _notesCollection.doc();

    await document
        .set({
          'appointmentId':
              appointmentId,
          'doctorId':
              doctorId,
          'note':
              note.trim(),

          // Use a normal DateTime instead of
          // FieldValue.serverTimestamp().
          'createdAt':
              Timestamp.now(),
        })
        .timeout(
          const Duration(
            seconds: 15,
          ),
        );
  }

  Future<void> deleteNote({
  required String noteId,
}) async {
  await _notesCollection
      .doc(noteId)
      .delete();
}
}