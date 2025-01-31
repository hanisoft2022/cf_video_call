import 'package:flutter/material.dart';
import 'package:video_call/home/s_home.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'NotoSans'),
      home: const SHome(),
    ),
  );
}
