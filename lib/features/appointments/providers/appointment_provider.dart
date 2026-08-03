
import 'package:flutter/material.dart';

import '../models/appointment_model.dart';

class AppointmentProvider
    extends ChangeNotifier {
  AppointmentModel _appointment =
      AppointmentModel(
    id:
        'APT-2026-001',
    patientName:
        'Sarah Johnson',
    patientId:
        'PAT-100245',
    age:
        32,
    phoneNumber:
        '+1 202-555-0147',
    appointmentDateTime:
        DateTime.now().add(
      const Duration(
        hours: 2,
      ),
    ),
    status:
        AppointmentStatus.confirmed,
  );

  AppointmentModel
      get appointment =>
          _appointment;

  void cancelAppointment() {
    _appointment =
        _appointment.copyWith(
      status:
          AppointmentStatus
              .cancelled,
    );

    notifyListeners();
  }

  void setStatus(
    AppointmentStatus status,
  ) {
    _appointment =
        _appointment.copyWith(
      status:
          status,
    );

    notifyListeners();
  }
}

