import 'package:flutter/material.dart';
import 'package:graduation_project/screens/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF3E2D8F), Color(0xFF9D52AC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Center(
              child: Image.asset(
                "assets/cloud_y.png",
                height: 220,
                width: 220,
              ),
            )),
            Expanded(
                child: Center(
              child: Text(
                "Weather Forecasts",
                style: TextStyle(color: Colors.white, fontSize: 55),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
