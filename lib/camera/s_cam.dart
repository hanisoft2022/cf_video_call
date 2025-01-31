import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_call/const/agora_config.dart';

class SCam extends StatefulWidget {
  const SCam({super.key});

  @override
  SCamState createState() => SCamState();
}

class SCamState extends State<SCam> {
  // 인스턴스 변수
  final int _uid = 0;
  int? _remoteUid;
  RtcEngine? _engine;
  bool _localUserJoined = false;
  late Future<void> _initAgora;

  // 오버라이드된 메서드
  @override
  void initState() {
    super.initState();
    _initAgora = initAgora();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  // 커스텀 메서드
  Future<void> initAgora() async {
    final Map<Permission, PermissionStatus> permissionStatus =
        await [Permission.microphone, Permission.camera].request();

    final cameraPermission = permissionStatus[Permission.camera];
    final microphonePermission = permissionStatus[Permission.microphone];

    if (cameraPermission != PermissionStatus.granted ||
        microphonePermission != PermissionStatus.granted) {
      return Future.error('카메라 또는 마이크 권한이 없습니다.');
    }

    if (_engine == null) {
      _engine = createAgoraRtcEngine();

      await _engine!.initialize(
        const RtcEngineContext(
          appId: appId,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      _engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            print('-----------------');
            debugPrint('local user ${connection.localUid} joined');
            print('local user ${connection.localUid} joined');
            print('-----------------');

            setState(
              () => _localUserJoined = true,
            );
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            print("remote user $remoteUid joined");
            setState(
              () => _remoteUid = remoteUid,
            );
          },
          onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) {
            print("remote user $remoteUid left channel");
            setState(
              () {
                _remoteUid = null;
              },
            );
          },
        ),
      );

      const ChannelMediaOptions channelMediaOptions = ChannelMediaOptions(
        autoSubscribeVideo: true,
        autoSubscribeAudio: true,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      );

      await _engine!.enableVideo();
      await _engine!.startPreview();
      await _engine!.joinChannel(
        token: token,
        channelId: channel,
        uid: _uid,
        options: channelMediaOptions,
      );
    }
  }

  Future<void> _dispose() async {
    await _engine!.leaveChannel();
    await _engine!.release();
  }

  // 위젯 빌드 메서드

  Widget _remoteVideo() {
    if (_remoteUid == null) {
      return const Text(
        '상대방이 아직 접속하지 않았습니다. 기다려주세요!',
        textAlign: TextAlign.center,
      );
    } else {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine!,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: channel),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('LIVE'),
        centerTitle: true,
      ),
      body: FutureBuilder<void>(
        future: _initAgora,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue[200],
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }
          return Stack(
            children: [
              Center(
                child: _remoteVideo(),
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
                      ),
                    ],
                    color: Colors.white,
                  ),
                  width: 100,
                  height: 150,
                  child: Center(
                    child: _localUserJoined
                        ? AgoraVideoView(
                            controller: VideoViewController(
                              rtcEngine: _engine!,
                              canvas: VideoCanvas(uid: _uid),
                            ),
                          )
                        : SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.blue[200],
                            ),
                          ),
                  ),
                ),
              ),
              Positioned(
                bottom: 30,
                left: 10,
                right: 10,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    '나가기',
                    style: TextStyle(color: Colors.blue[800]),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
