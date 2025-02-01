// UI Widget

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_call/camera/provider/cam_provider.dart';
import 'package:video_call/common/const/agora_config.dart';

class FRemoteVideo extends ConsumerWidget {
  const FRemoteVideo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agoraState = ref.watch(agoraProvider);
    if (agoraState.remoteUid == null) {
      return const Text('상대방이 아직 접속하지 않았습니다. 기다려주세요!', textAlign: TextAlign.center);
    } else {
      return AgoraVideoView(
          controller: VideoViewController.remote(
              rtcEngine: agoraState.engine!, canvas: VideoCanvas(uid: agoraState.remoteUid), connection: const RtcConnection(channelId: channel)));
    }
  }
}
