import 'package:flutter/material.dart';
import 'package:interviewprocess/tabs/firstpage/firstpagescreen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'file',
      home: Scaffold(
        body: SplashScreen(),
      ),
    ),
  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Firstpage();
  }
}
