import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:video_call/common/const/agora_config.dart';

class AgoraState {
  final RtcEngine? engine;
  final bool localUserJoined;
  final int? remoteUid;
  final String? errorMessage;

  AgoraState({
    this.engine,
    this.localUserJoined = false,
    this.remoteUid,
    this.errorMessage,
  });

  AgoraState copyWith({
    RtcEngine? engine,
    bool? localUserJoined,
    int? remoteUid,
    String? errorMessage,
  }) {
    return AgoraState(
      engine: engine ?? this.engine,
      localUserJoined: localUserJoined ?? this.localUserJoined,
      remoteUid: remoteUid ?? this.remoteUid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final agoraProvider = StateNotifierProvider.autoDispose<AgoraController, AgoraState>((ref) => AgoraController());

class AgoraController extends StateNotifier<AgoraState> {
  AgoraController() : super(AgoraState());

  Future<void> initAgora() async {
    try {
      // Request permissions
      final permissionStatus = await [Permission.microphone, Permission.camera].request();

      if (permissionStatus[Permission.camera] != PermissionStatus.granted || permissionStatus[Permission.microphone] != PermissionStatus.granted) {
        state = state.copyWith(errorMessage: '카메라 또는 마이크 권한이 없습니다.');
        return;
      }

      // Initialize Agora engine
      final engine = createAgoraRtcEngine();
      await engine.initialize(
        const RtcEngineContext(
          appId: appId,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      // Register event handlers
      engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            state = state.copyWith(localUserJoined: true);
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            state = state.copyWith(remoteUid: remoteUid);
          },
          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
            state = state.copyWith(remoteUid: null);
          },
        ),
      );

      // Configure channel options and join channel
      const channelMediaOptions = ChannelMediaOptions(
        autoSubscribeVideo: true,
        autoSubscribeAudio: true,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      );

      await engine.enableVideo();
      await engine.startPreview();
      await engine.joinChannel(
          token: token,
          channelId: channel,
          uid: 0, // Local user ID
          options: channelMediaOptions);

      // Update state with initialized engine
      state = state.copyWith(engine: engine);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> disposeAgora() async {
    await state.engine?.leaveChannel();
    await state.engine?.stopPreview();
    await state.engine?.release();
    state = AgoraState();
  }
}
