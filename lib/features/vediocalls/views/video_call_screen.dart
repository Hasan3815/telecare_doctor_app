

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

  
  static const int appID = AppSecrets.zegoAppId;

  
  static const String appSign = AppSecrets.zegoAppSign;

  @override
  Widget build(BuildContext context) {
    
    final String roomID = 'appointment_$appointmentId';

    
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