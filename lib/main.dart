
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telecare_doctor_app/features/notes/providers/notes_provider.dart';
import 'package:telecare_doctor_app/features/vediocalls/providers/video_call_provider.dart';

import 'app/app.dart';
import 'features/appointments/providers/appointment_provider.dart';
import 'features/auth/providers/auth_provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized();

  await Firebase
      .initializeApp(
    options:
        DefaultFirebaseOptions
            .currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) =>
                  AuthProvider(),
        ),
        ChangeNotifierProvider(
          create:
              (_) =>
                  AppointmentProvider(),
        ),
        ChangeNotifierProvider(
      create: (_) => NotesProvider(),
    ),
    ChangeNotifierProvider(
  create: (_) =>
      VideoCallProvider(),
),
      ],
      child:
          const TeleCareDoctorApp(),
    ),
  );
}

