import 'dart:async';

import 'package:flutter/material.dart';
import 'package:listapp/islemler/shared_pref.dart';
import 'package:listapp/screens/anasayfa.dart';
import 'package:listapp/screens/kayitekrani.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AnaSayfa()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // color: Colors.white,
        child: Center(
            child: Container(
          margin: EdgeInsets.all(150),
          child: Image.asset(
            "assets/images/todo.png",
            fit: BoxFit.contain,
          ),
        )),
      ),
    );
  }
}
