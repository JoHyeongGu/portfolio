import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: CircularProgressIndicator(
          color: Colors.brown,
        ),
      ),
    );
  }
}
