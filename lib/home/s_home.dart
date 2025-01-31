import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:video_call/camera/s_cam.dart';
import 'package:video_call/home/widget/w_enter_button.dart';
import 'package:video_call/home/widget/w_image.dart';
import 'package:video_call/home/widget/w_logo.dart';

class SHome extends StatefulWidget {
  const SHome({super.key});

  @override
  State<SHome> createState() => _SHomeState();
}

class _SHomeState extends State<SHome> {
  _onEnterButtonPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SCam(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(child: WLogo()),
            const Gap(30),
            const Expanded(child: WImage()),
            Expanded(child: WEnterButton(onEnterButtonPressed: _onEnterButtonPressed)),
          ],
        ),
      ),
    );
  }
}
