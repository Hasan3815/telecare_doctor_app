import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoCallService {
  VideoCallService({
    FirebaseFirestore? firestore,
  }) : _firestore =
            firestore ??
                FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  RTCPeerConnection? _peerConnection;

  MediaStream? _localStream;

  final RTCVideoRenderer localRenderer =
      RTCVideoRenderer();

  final RTCVideoRenderer remoteRenderer =
      RTCVideoRenderer();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    await localRenderer.initialize();

    await remoteRenderer.initialize();

    _isInitialized = true;
  }

  Future<void> startLocalMedia() async {
    await initialize();

    _localStream =
        await navigator.mediaDevices.getUserMedia(
      {
        'audio': true,
        'video': {
          'facingMode': 'user',
          'width': 1280,
          'height': 720,
        },
      },
    );

    localRenderer.srcObject =
        _localStream;
  }

  Future<void> createCall({
    required String callId,
    required String doctorId,
  }) async {
    await startLocalMedia();

    await _createPeerConnection();

    final callReference =
        _firestore
            .collection('video_calls')
            .doc(callId);

    final offer =
        await _peerConnection!
            .createOffer();

    await _peerConnection!
        .setLocalDescription(
      offer,
    );

    await callReference.set({
      'callId': callId,
      'doctorId': doctorId,
      'status': 'calling',
      'createdAt':
          FieldValue.serverTimestamp(),
      'offer': {
        'type': offer.type,
        'sdp': offer.sdp,
      },
    });

    _peerConnection!
        .onIceCandidate = (
      candidate,
    ) {
      if (candidate.candidate ==
          null) {
        return;
      }

      callReference
          .collection(
            'doctor_candidates',
          )
          .add({
        'candidate':
            candidate.candidate,
        'sdpMid':
            candidate.sdpMid,
        'sdpMLineIndex':
            candidate.sdpMLineIndex,
      });
    };

    callReference
        .snapshots()
        .listen(
      (
        snapshot,
      ) async {
        final data =
            snapshot.data();

        if (data == null) {
          return;
        }

        final answer =
            data['answer'];

        if (answer == null) {
          return;
        }

        final remoteDescription =
            RTCSessionDescription(
          answer['sdp'] as String,
          answer['type'] as String,
        );

        final currentRemoteDescription =
            await _peerConnection!
                .getRemoteDescription();

        if (currentRemoteDescription ==
            null) {
          await _peerConnection!
              .setRemoteDescription(
            remoteDescription,
          );
        }
      },
    );

    callReference
        .collection(
          'patient_candidates',
        )
        .snapshots()
        .listen(
      (
        snapshot,
      ) {
        for (
          final change
              in snapshot.docChanges
        ) {
          if (change.type !=
              DocumentChangeType.added) {
            continue;
          }

          final data =
              change.doc.data();

          if (data == null) {
            continue;
          }

          _peerConnection!
              .addCandidate(
            RTCIceCandidate(
              data['candidate']
                  as String?,
              data['sdpMid']
                  as String?,
              data['sdpMLineIndex']
                  as int?,
            ),
          );
        }
      },
    );
  }

  Future<void> joinCall({
    required String callId,
  }) async {
    await startLocalMedia();

    await _createPeerConnection();

    final callReference =
        _firestore
            .collection('video_calls')
            .doc(callId);

    final callSnapshot =
        await callReference.get();

    final callData =
        callSnapshot.data();

    if (callData == null) {
      throw Exception(
        'Video call not found',
      );
    }

    final offer =
        callData['offer'];

    if (offer == null) {
      throw Exception(
        'Video call offer not found',
      );
    }

    await _peerConnection!
        .setRemoteDescription(
      RTCSessionDescription(
        offer['sdp'] as String,
        offer['type'] as String,
      ),
    );

    final answer =
        await _peerConnection!
            .createAnswer();

    await _peerConnection!
        .setLocalDescription(
      answer,
    );

    await callReference.update({
      'status': 'connected',
      'answer': {
        'type': answer.type,
        'sdp': answer.sdp,
      },
    });

    _peerConnection!
        .onIceCandidate = (
      candidate,
    ) {
      if (candidate.candidate ==
          null) {
        return;
      }

      callReference
          .collection(
            'patient_candidates',
          )
          .add({
        'candidate':
            candidate.candidate,
        'sdpMid':
            candidate.sdpMid,
        'sdpMLineIndex':
            candidate.sdpMLineIndex,
      });
    };

    callReference
        .collection(
          'doctor_candidates',
        )
        .snapshots()
        .listen(
      (
        snapshot,
      ) {
        for (
          final change
              in snapshot.docChanges
        ) {
          if (change.type !=
              DocumentChangeType.added) {
            continue;
          }

          final data =
              change.doc.data();

          if (data == null) {
            continue;
          }

          _peerConnection!
              .addCandidate(
            RTCIceCandidate(
              data['candidate']
                  as String?,
              data['sdpMid']
                  as String?,
              data['sdpMLineIndex']
                  as int?,
            ),
          );
        }
      },
    );
  }

  Future<void> _createPeerConnection() async {
    final configuration = {
      'iceServers': [
        {
          'urls': [
            'stun:stun.l.google.com:19302',
            'stun:stun1.l.google.com:19302',
          ],
        },
      ],
    };

    _peerConnection =
        await createPeerConnection(
      configuration,
    );

    for (
      final track
          in _localStream!
              .getTracks()
    ) {
      await _peerConnection!
          .addTrack(
        track,
        _localStream!,
      );
    }

    _peerConnection!
        .onTrack = (
      event,
    ) {
      if (event.streams.isEmpty) {
        return;
      }

      remoteRenderer.srcObject =
          event.streams.first;
    };
  }

  void toggleMicrophone() {
    final audioTracks =
        _localStream
            ?.getAudioTracks() ??
            [];

    for (
      final track
          in audioTracks
    ) {
      track.enabled =
          !track.enabled;
    }
  }

  void toggleCamera() {
    final videoTracks =
        _localStream
            ?.getVideoTracks() ??
            [];

    for (
      final track
          in videoTracks
    ) {
      track.enabled =
          !track.enabled;
    }
  }

  Future<void> switchCamera() async {
    final videoTracks =
        _localStream
            ?.getVideoTracks() ??
            [];

    if (videoTracks.isEmpty) {
      return;
    }

    await Helper.switchCamera(
      videoTracks.first,
    );
  }

  Future<void> endCall({
    required String callId,
  }) async {
    await _firestore
        .collection(
          'video_calls',
        )
        .doc(
          callId,
        )
        .update({
      'status': 'ended',
      'endedAt':
          FieldValue.serverTimestamp(),
    });

    await dispose();
  }

  Future<void> dispose() async {
    final localTracks =
        _localStream
            ?.getTracks() ??
            [];

    for (
      final track
          in localTracks
    ) {
      track.stop();
    }

    await _peerConnection?.close();

    await localRenderer.dispose();

    await remoteRenderer.dispose();

    _localStream = null;

    _peerConnection = null;

    _isInitialized = false;
  }
}