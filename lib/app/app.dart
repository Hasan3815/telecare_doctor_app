import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../core/widgets/loading_widget.dart';
import '../features/appointments/views/doctor_dashboard.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/auth/views/login_screen.dart';

class TeleCareDoctorApp extends StatelessWidget {
  const TeleCareDoctorApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return MaterialApp(
      title: 'TeleCare Doctor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor:
            AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
      ),
      home: const AuthStateHandler(),
    );
  }
}

class AuthStateHandler extends StatelessWidget {
  const AuthStateHandler({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return StreamBuilder<User?>(
      stream: context
          .read<AuthProvider>()
          .authStateChanges,
      builder: (
        context,
        snapshot,
      ) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Scaffold(
            body: LoadingWidget(
              message:
                  'Checking login...',
            ),
          );
        }

        if (snapshot.hasData) {
          WidgetsBinding.instance
              .addPostFrameCallback(
            (_) {
              context
                  .read<AuthProvider>()
                  .loadCurrentDoctor();
            },
          );

          return const DoctorDashboard();
        }

        return const LoginScreen();
      },
    );
  }
}