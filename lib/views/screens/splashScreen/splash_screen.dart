import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_eats_seller_app/views/screens/authScreens/auth_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  initTimer() {
    Timer(const Duration(seconds: 3), () async {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AuthScreen()));
    });
  }

  @override
  void initState() {
    super.initState();

    initTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                'assets/images/sellers.webp',
                fit: BoxFit.cover,
              ),
            ),
            const Text(
              'Flutter Eats: Seller app',
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 3,
                fontSize: 26,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
