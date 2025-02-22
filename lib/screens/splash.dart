import 'package:flutter/material.dart';

class SplashScreens extends StatelessWidget {
  const SplashScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlutterChat'),
      ),
      body: Center(
        child: Text('Loading...'),
      ),
    );
  }
}
