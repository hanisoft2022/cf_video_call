import 'package:flutter_riverpod/flutter_riverpod.dart';

class CameraState {
  final bool isFront;

  CameraState({this.isFront = true});

  CameraState copyWith({bool? isFront}) {
    return CameraState(isFront: isFront ?? this.isFront);
  }
}

final cameraProvider = StateNotifierProvider((ref) => CameraNotifier());

class CameraNotifier extends StateNotifier<CameraState> {
  CameraNotifier() : super(CameraState());

  void toggleCamera() {
    state = state.copyWith(isFront: !state.isFront);
  }
}
