import 'package:flutter/material.dart';

class WEnterButton extends StatelessWidget {
  final VoidCallback onEnterButtonPressed;

  const WEnterButton({
    super.key,
    required this.onEnterButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onEnterButtonPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        child: const Text(
          '입장하기',
        ),
      ),
    );
  }
}
