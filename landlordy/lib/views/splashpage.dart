import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:landlordy/models/user.dart';
import 'package:landlordy/shared/loadingindicatorwidget.dart';
import 'package:landlordy/shared/myserverconfig.dart';
import 'package:landlordy/views/propertiespage.dart';
import 'package:landlordy/views/welcomepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Spacer(
            flex: 2,
          ),
          LoadingIndicatorWidget(type: 1),
          Spacer(
            flex: 3,
          ),
          Text("Version 2.1.0"),
          Spacer(
            flex: 1,
          )
        ],
      )),
    );
  }

  checkAndLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('password')) ?? '';
    bool login = (prefs.getBool('login')) ?? false;
    if (login) {
      http.post(
          Uri.parse(
              "${MyServerConfig.server}/landlordy/php/user/login_user.php"),
          body: {"email": email, "password": password}).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['status'] == "success") {
            User user = User.fromJson(data['data']);
            if (user.status == 'Active') {
              Timer(const Duration(seconds: 3), () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => PropertiesPage(userdata: user)));
              });
            } else {
              Timer(
                const Duration(seconds: 3),
                () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomePage(),
                      ));
                },
              );
            }
          } else {
            Timer(
              const Duration(seconds: 3),
              () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomePage(),
                    ));
              },
            );
          }
        }
      });
    } else {
      Timer(
        const Duration(seconds: 3),
        () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const WelcomePage(),
              ));
        },
      );
    }
  }
}
