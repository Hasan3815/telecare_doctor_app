import 'package:flutter/material.dart';

import '../services/video_call_service.dart';

class VideoCallProvider
    extends ChangeNotifier {
  VideoCallProvider({
    VideoCallService? service,
  }) : _service =
            service ??
                VideoCallService();

  final VideoCallService _service;

  bool _isLoading = false;

  bool _isMicEnabled = true;

  bool _isCameraEnabled = true;

  String? _errorMessage;

  bool get isLoading =>
      _isLoading;

  bool get isMicEnabled =>
      _isMicEnabled;

  bool get isCameraEnabled =>
      _isCameraEnabled;

  String? get errorMessage =>
      _errorMessage;

  VideoCallService get service =>
      _service;

  Future<void> startCall({
    required String callId,
    required String doctorId,
  }) async {
    _setLoading(true);

    try {
      await _service.createCall(
        callId: callId,
        doctorId: doctorId,
      );
    } catch (
      error
    ) {
      _errorMessage =
          error.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> joinCall({
    required String callId,
  }) async {
    _setLoading(true);

    try {
      await _service.joinCall(
        callId: callId,
      );
    } catch (
      error
    ) {
      _errorMessage =
          error.toString();
    } finally {
      _setLoading(false);
    }
  }

  void toggleMicrophone() {
    _service.toggleMicrophone();

    _isMicEnabled =
        !_isMicEnabled;

    notifyListeners();
  }

  void toggleCamera() {
    _service.toggleCamera();

    _isCameraEnabled =
        !_isCameraEnabled;

    notifyListeners();
  }

  Future<void> switchCamera() async {
    await _service.switchCamera();
  }

  Future<void> endCall({
    required String callId,
  }) async {
    await _service.endCall(
      callId: callId,
    );
  }

  void _setLoading(
    bool value,
  ) {
    _isLoading = value;

    notifyListeners();
  }
}