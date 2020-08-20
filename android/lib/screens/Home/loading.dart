import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white38,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
