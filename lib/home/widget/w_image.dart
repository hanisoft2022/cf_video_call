import 'package:flutter/material.dart';

class WImage extends StatelessWidget {
  const WImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: Image.asset('asset/img/home_img.png'));
  }
}
