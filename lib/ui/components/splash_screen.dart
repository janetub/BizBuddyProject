import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../main.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 6), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainCanvas()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(right: 25.0),
        child: Center(
          child: Lottie.asset('animations/handshake.json'),
        ),
      ),
    );
  }
}