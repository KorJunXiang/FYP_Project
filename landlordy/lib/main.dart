import 'package:flutter/material.dart';
import 'package:landlordy/shared/color_scheme.dart';
import 'package:landlordy/views/splashpage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LandLordy',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      home: const SplashPage(),
    );
  }
}
