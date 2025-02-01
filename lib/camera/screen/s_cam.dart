// UI Widget
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_call/camera/provider/cam_provider.dart';
import 'package:video_call/camera/screen/f_remote_video.dart';

class SCam extends ConsumerStatefulWidget {
  const SCam({super.key});

  @override
  SCamState createState() => SCamState();
}

class SCamState extends ConsumerState<SCam> {
  @override
  void initState() {
    super.initState();
    ref.read(agoraProvider.notifier).initAgora();
  }

  @override
  Widget build(BuildContext context) {
    final agoraState = ref.watch(agoraProvider);
    final agoraController = ref.read(agoraProvider.notifier);

    return Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          backgroundColor: Colors.transparent, title: const Text('LIVE'), centerTitle: true, automaticallyImplyLeading: false, // 기본 뒤로가기 버튼 비활성화
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await agoraController.disposeAgora();
              if (context.mounted) {
                context.pop();
              }
            },
          ),
        ),
        body: Stack(children: [
          Center(
            child: Builder(
              builder: (context) {
                if (agoraState.engine == null) {
                  return Text(agoraState.errorMessage ?? '설정중...');
                }
                if (!agoraState.localUserJoined) {
                  return const Text('상대방이 아직 접속하지 않았습니다.');
                }
                return const FRemoteVideo();
              },
            ),
          ),
          Positioned(
              top: 10,
              left: 20,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue[200]!,
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      )
                    ],
                    color: Colors.white),
                width: 100,
                height: 150,
                child: Center(
                    child: agoraState.localUserJoined
                        ? AgoraVideoView(
                            controller: VideoViewController(
                              rtcEngine: agoraState.engine!,
                              canvas: const VideoCanvas(uid: 0), // Local user ID is always `0`
                            ),
                          )
                        : SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.blue[200]))),
              )),
          Positioned(
              bottom: 30,
              left: 10,
              right: 10,
              child: ElevatedButton(
                  onPressed: () async {
                    await agoraController.disposeAgora();
                    if (context.mounted) {
                      context.pop();
                    }
                  },
                  child: Text('나가기', style: TextStyle(color: Colors.blue[800]))))
        ]));
  }
}
