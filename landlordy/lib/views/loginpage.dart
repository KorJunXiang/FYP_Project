// ignore_for_file: use_build_context_synchronously, unused_local_variable, unused_import

import 'dart:convert';

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:landlordy/models/user.dart';
import 'package:landlordy/shared/myserverconfig.dart';
import 'package:landlordy/views/passwordforgotpage.dart';
import 'package:landlordy/views/propertiespage.dart';
import 'package:landlordy/views/signuppage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  bool _passwordVisible = true;
  late double screenWidth, screenHeight;
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  bool _isEmailValid = true;
  bool _isPassValid = true;

  @override
  void initState() {
    super.initState();
    loadpref();
  }

  @override
  void dispose() {
    _emailEditingController.dispose();
    _passEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      appBar: AppBar(
        title: const Text(
          'Login Page',
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
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/login.png',
                  scale: 2.5,
                  color: Colors.black,
                ),
                Form(
                  key: _formKey,
                  child: Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailEditingController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                              color: _isEmailValid ? Colors.black : Colors.red,
                            ),
                            decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                icon: Image.asset(
                                  'assets/icons/email_icon.png',
                                  scale: 15,
                                ),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
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
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                              controller: _passEditingController,
                              style: TextStyle(
                                color: _isPassValid ? Colors.black : Colors.red,
                              ),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  setState(() {
                                    _isPassValid = false;
                                  });
                                  return "Enter your password";
                                } else {
                                  setState(() {
                                    _isPassValid = true;
                                  });
                                  return null;
                                }
                              },
                              obscureText: _passwordVisible,
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  icon: Image.asset(
                                    'assets/icons/password_icon.png',
                                    scale: 15,
                                  ),
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                    icon: _passwordVisible
                                        ? Image.asset(
                                            'assets/icons/show_icon.png',
                                            scale: 18,
                                          )
                                        : Image.asset(
                                            'assets/icons/hide_icon.png',
                                            scale: 18,
                                          ),
                                  ),
                                  errorStyle: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16))),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Checkbox(
                                        value: _isChecked,
                                        onChanged: (bool? value) {
                                          if (!_formKey.currentState!
                                              .validate()) {
                                            return;
                                          }
                                          saveremovepref(value!);
                                          setState(() {
                                            _isChecked = value;
                                          });
                                        }),
                                    const Text(
                                      'Remember me',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    child: const Text(
                                      'Forgot Password',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        decorationColor:
                                            Color.fromARGB(255, 1, 8, 220),
                                        color: Color.fromARGB(255, 1, 8, 220),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const PasswordForgotPage(),
                                          ));
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: loginUser,
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(screenWidth * 0.35, 45),
                              backgroundColor: Colors.blue,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loginUser() async {
    if (!_formKey.currentState!.validate()) {
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = _emailEditingController.text;
    String password = _passEditingController.text;

    http.post(
        Uri.parse("${MyServerConfig.server}/landlordy/php/user/login_user.php"),
        body: {"email": email, "password": password}).then((response) async {
      // log(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          User user = User.fromJson(data['data']);
          if (user.status == 'Inactive') {
            final response = await http.post(
                Uri.parse(
                    "${MyServerConfig.server}/landlordy/php/user/register_user.php"),
                body: {"name": user.username, "email": email});
            // log(response.body);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                "Email Not Authorized\nPlease Check Your Email Again",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ));
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Success",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ));

          await prefs.setString('email', email);
          await prefs.setString('password', password);
          await prefs.setBool('login', true);
          Navigator.of(context).pop();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (content) => PropertiesPage(userdata: user)));
        } else {
          String message = data['message'];
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(message,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ));
        }
      }
    });
  }

  void saveremovepref(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    if (value) {
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      await prefs.setBool('checkbox', value);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Preferences Stored",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ));
    } else {
      await prefs.setString('email', '');
      await prefs.setString('password', '');
      await prefs.setBool('checkbox', false);
      _emailEditingController.text = '';
      _passEditingController.text = '';
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Preferences Removed",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
    }
  }

  Future<void> loadpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('password')) ?? '';
    _isChecked = (prefs.getBool('checkbox')) ?? false;
    if (_isChecked) {
      _emailEditingController.text = email;
      _passEditingController.text = password;
    }
    setState(() {});
  }
}
