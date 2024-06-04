// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:landlordy/shared/myserverconfig.dart';
import 'package:landlordy/views/passwordresetpage.dart';
import 'package:pinput/pinput.dart';
import 'package:landlordy/views/signuppage.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

class PasswordForgotPage extends StatefulWidget {
  const PasswordForgotPage({super.key});

  @override
  State<PasswordForgotPage> createState() => _PasswordForgotPageState();
}

class _PasswordForgotPageState extends State<PasswordForgotPage> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _otpEditingController = TextEditingController();
  late double screenWidth, screenHeight;
  bool _isEmailValid = true;
  bool _isOTPValid = true;
  final _formKeyEmail = GlobalKey<FormState>();
  final _formKeyOTP = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailEditingController.dispose();
    _otpEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    final defaultPinTheme = PinTheme(
      width: screenWidth * 0.12,
      height: 56,
      textStyle: TextStyle(
        color: _isOTPValid ? Colors.black : Colors.red,
      ),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue.shade100),
    );
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      appBar: AppBar(
        title: const Text(
          "Forgot Password",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              'assets/icons/back_icon.png',
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const Text(
                          'Forgot Your Password?',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          'Please enter your registered email address\nto receive 6-Digit OTP and enter it below.',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * 0.05),
                        Form(
                          key: _formKeyEmail,
                          child: TextFormField(
                            controller: _emailEditingController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                              color: _isEmailValid ? Colors.black : Colors.red,
                            ),
                            decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'Enter email',
                                hintStyle: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                prefixIcon: Image.asset(
                                  'assets/icons/email_icon.png',
                                  scale: 15,
                                ),
                                suffixIcon: TextButton(
                                    onPressed: _sendOTP,
                                    child: const Text(
                                      "Send OTP",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                errorStyle: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16)),
                            validator: (val) {
                              if (val!.isEmpty ||
                                  !val.contains("@") ||
                                  !val.contains(".")) {
                                setState(() {
                                  _isEmailValid = false;
                                });
                                return "Enter a valid email";
                              } else {
                                setState(() {
                                  _isEmailValid = true;
                                });
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Form(
                              key: _formKeyOTP,
                              child: Pinput(
                                length: 6,
                                controller: _otpEditingController,
                                defaultPinTheme: defaultPinTheme,
                                focusedPinTheme:
                                    defaultPinTheme.copyDecorationWith(
                                  border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 2),
                                ),
                                errorPinTheme:
                                    defaultPinTheme.copyDecorationWith(
                                  border:
                                      Border.all(color: Colors.red, width: 2),
                                ),
                                errorTextStyle: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16),
                                validator: (value) {
                                  if (value!.length != 6) {
                                    setState(() {
                                      _isOTPValid = false;
                                    });
                                    return "Enter 6-Digit OTP";
                                  } else {
                                    setState(() {
                                      _isOTPValid = true;
                                    });
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        ElevatedButton(
                          onPressed: _navigateReset,
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(screenWidth * 0.35, 45),
                            backgroundColor: Colors.blue,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Verify',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ));
                      },
                      child: const Text(
                        'Sign Up Now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                          decorationColor: Color.fromARGB(255, 1, 8, 220),
                          color: Color.fromARGB(255, 1, 8, 220),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendOTP() async {
    if (!_formKeyEmail.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Check your input',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
      return;
    }
    String email = _emailEditingController.text;
    final response = await http.post(
        Uri.parse("${MyServerConfig.server}/landlordy/php/user/send_otp.php"),
        body: {"email": email});
    log(response.body);
    if (response.statusCode == 200) {
      emailDialog(email);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("OTP Succcessfully Sent",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ));
    }
  }

  void emailDialog(String email) {
    QuickAlert.show(
      borderRadius: 10,
      context: context,
      confirmBtnColor: Theme.of(context).colorScheme.primary,
      animType: QuickAlertAnimType.slideInUp,
      title: 'OTP Send Successfully',
      type: QuickAlertType.success,
      text: 'An OTP Code Has Been Send To $email',
    );
  }

  Future<void> _navigateReset() async {
    if (!_formKeyOTP.currentState!.validate() ||
        !_formKeyEmail.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Check your input',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
      return;
    }
    String otp = _otpEditingController.text;
    String email = _emailEditingController.text;
    final responseUser = await http.post(
        Uri.parse("${MyServerConfig.server}/landlordy/php/user/verify_otp.php"),
        body: {"email": email, "otp": otp});
    log(responseUser.body);
    if (responseUser.statusCode == 200) {
      var jsondatauser = jsonDecode(responseUser.body);
      if (jsondatauser['status'] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(jsondatauser['message'],
              style: const TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ));
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PasswordResetPage(email: email),
            ));
      } else {
        String message = jsondatauser['message'] ?? 'Invalid OTP';
        if (message == 'No OTP found or it has already been used' ||
            message == 'OTP has expired') {
          message += '\nPlease resend OTP';
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            message,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Error verifying OTP\nPlease try again',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
    }
  }
}
