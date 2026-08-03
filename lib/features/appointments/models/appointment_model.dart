
enum AppointmentStatus {
  confirmed,
  unconfirmed,
  cancelled,
}

class AppointmentModel {
  final String id;
  final String patientName;
  final String patientId;
  final int age;
  final String phoneNumber;
  final DateTime appointmentDateTime;
  final AppointmentStatus status;

  const AppointmentModel({
    required this.id,
    required this.patientName,
    required this.patientId,
    required this.age,
    required this.phoneNumber,
    required this.appointmentDateTime,
    required this.status,
  });

  String get statusText {
    switch (status) {
      case AppointmentStatus.confirmed:
        return 'Confirmed';

      case AppointmentStatus.unconfirmed:
        return 'Unconfirmed';

      case AppointmentStatus.cancelled:
        return 'Cancelled';
    }
  }

  AppointmentModel copyWith({
    String? id,
    String? patientName,
    String? patientId,
    int? age,
    String? phoneNumber,
    DateTime? appointmentDateTime,
    AppointmentStatus? status,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      patientName:
          patientName ??
              this.patientName,
      patientId:
          patientId ??
              this.patientId,
      age: age ?? this.age,
      phoneNumber:
          phoneNumber ??
              this.phoneNumber,
      appointmentDateTime:
          appointmentDateTime ??
              this.appointmentDateTime,
      status:
          status ??
              this.status,
    );
  }
}

