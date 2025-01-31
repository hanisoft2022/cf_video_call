import 'package:go_router/go_router.dart';
import 'package:video_call/camera/s_cam.dart';
import 'package:video_call/home/screen/s_home.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SHome(),
    ),
    GoRoute(
      path: '/cam',
      builder: (context, state) => const SCam(),
    ),
  ],
);
