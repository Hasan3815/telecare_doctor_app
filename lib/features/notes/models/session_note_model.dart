import 'package:cloud_firestore/cloud_firestore.dart';

class SessionNoteModel {
  final String id;
  final String appointmentId;
  final String doctorId;
  final String note;
  final DateTime createdAt;

  const SessionNoteModel({
    required this.id,
    required this.appointmentId,
    required this.doctorId,
    required this.note,
    required this.createdAt,
  });

  factory SessionNoteModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? {};

    final timestamp = data['createdAt'];

    return SessionNoteModel(
      id: document.id,
      appointmentId: data['appointmentId']?.toString() ?? '',
      doctorId: data['doctorId']?.toString() ?? '',
      note: data['note']?.toString() ?? '',
      createdAt: timestamp is Timestamp
          ? timestamp.toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'appointmentId': appointmentId,
      'doctorId': doctorId,
      'note': note,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}