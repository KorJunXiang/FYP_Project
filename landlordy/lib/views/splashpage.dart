import 'dart:async';

import 'package:flutter/material.dart';
import 'package:landlordy/views/welcomepage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    checkAndLogin();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Column(
        children: [
          Spacer(flex: 4),
          Image(image: AssetImage('assets/images/landlord.png')),
          Text(
            "Landlordy",
            style: TextStyle(fontSize:40, fontWeight: FontWeight.bold),
          ),
          Spacer(flex: 2,),
          CircularProgressIndicator(),
          Spacer(flex: 3,),
          Text("Version 0.1"),
          Spacer(flex: 1,)
        ],
      )),
    );
  }

  checkAndLogin() async {
    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainPage(),
            ));
      },
    );
  }
}
