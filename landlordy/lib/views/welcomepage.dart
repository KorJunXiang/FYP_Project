import 'package:flutter/material.dart';
import 'package:landlordy/views/loginpage.dart';
import 'package:landlordy/views/signuppage.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late double screenWidth, screenHeight;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Positioned(
              top: -screenHeight * 0.2,
              left: 0,
              right: 0,
              bottom: screenHeight * 0.1,
              child: Container(
                color: Theme.of(context).colorScheme.primary,
                child: Image.asset(
                  'assets/images/logo.png',
                  scale: 1,
                  alignment: Alignment.center,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: -50,
              right: -50,
              child: Container(
                height: screenHeight * 0.3,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(screenWidth),
                  ),
                ),
                child: Column(
                  children: [
                    const Spacer(
                      flex: 1,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(screenWidth * 0.5, 50),
                        backgroundColor: Colors.blue,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(
                        Icons.login_rounded,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const SignUpPage();
                          },
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(screenWidth * 0.5, 50),
                        backgroundColor: Colors.green,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(
                        Icons.app_registration_rounded,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
