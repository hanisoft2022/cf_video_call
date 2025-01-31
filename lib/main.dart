import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_call/home/s_home.dart';

void main() {
  runApp(
    ProviderScope(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'NotoSans'),
      home: const SHome(),
    )),
  );
}
