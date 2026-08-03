// import 'package:flutter/material.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// import '../../../core/config/zego_config.dart';

// class VideoCallScreen extends StatelessWidget {
//   const VideoCallScreen({
//     super.key,
//     required this.appointmentId,
//     required this.patientName,
//   });

//   final String appointmentId;
//   final String patientName;

//   @override
//   Widget build(BuildContext context) {
//     final roomId = 'appointment_$appointmentId';

//     final userId =
//         'doctor_${DateTime.now().millisecondsSinceEpoch}';

//     final userName = 'Dr. User';

//     return Scaffold(
//       body: SafeArea(
//         child: ZegoUIKitPrebuiltCall(
//           appID: ZegoConfig.appId,
//           appSign: ZegoConfig.appSign,
//           userID: userId,
//           userName: userName,
//           callID: roomId,
//           config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// import '../../../core/config/zego_config.dart';

// class VideoCallScreen extends StatelessWidget {
//   const VideoCallScreen({
//     super.key,
//     required this.appointmentId,
//     required this.patientName,
//     required this.isDoctor,
//   });

//   final String appointmentId;
//   final String patientName;
//   final bool isDoctor;

//   @override
//   Widget build(BuildContext context) {
//     final roomId = 'appointment_$appointmentId';

//     final userId = isDoctor
//         ? 'doctor_101'
//         : 'patient_101';

//     final userName = isDoctor
//         ? 'Dr. User'
//         : patientName;

//     return Scaffold(
//       body: SafeArea(
//         child: ZegoUIKitPrebuiltCall(
//           appID: ZegoConfig.appId,
//           appSign: ZegoConfig.appSign,
//           userID: userId,
//           userName: userName,
//           callID: roomId,
//           config:
//               ZegoUIKitPrebuiltCallConfig
//                   .oneOnOneVideoCall(),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:telecare_doctor_app/core/config/app_secrets.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class VideoCallScreen extends StatelessWidget {
  const VideoCallScreen({
    super.key,
    required this.appointmentId,
    required this.patientName,
  });

  final String appointmentId;
  final String patientName;

  // Paste your ZEGO AppID here.
  static const int appID = AppSecrets.zegoAppId;

  // Paste your ZEGO AppSign here.
  static const String appSign = AppSecrets.zegoAppSign;

  @override
  Widget build(BuildContext context) {
    // Same appointment = same video-call room.
    final String roomID = 'appointment_$appointmentId';

    // For testing, every app instance needs a unique user ID.
    final String userID =
        'doctor_${DateTime.now().millisecondsSinceEpoch}';

    return Scaffold(
      body: SafeArea(
        child: ZegoUIKitPrebuiltCall(
          appID: appID,
          appSign: appSign,
          userID: userID,
          userName: 'Doctor',
          callID: roomID,
          config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
        ),
      ),
    );
  }
}