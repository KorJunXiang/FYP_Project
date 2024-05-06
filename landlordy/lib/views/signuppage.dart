import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:landlordy/shared/myserverconfig.dart';
import 'package:landlordy/views/loginpage.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _pass1EditingController = TextEditingController();
  final TextEditingController _pass2EditingController = TextEditingController();
  bool _password1Visible = true;
  bool _password2Visible = true;
  late double screenWidth, screenHeight;
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  String eula = '';
  bool _isNameValid = true;
  bool _isEmailValid = true;
  bool _isPassValid = true;

  @override
  void dispose() {
    _nameEditingController.dispose();
    _emailEditingController.dispose();
    _pass1EditingController.dispose();
    _pass2EditingController.dispose();
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
          'Sign Up Page',
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
          child: Column(
            children: [
              Image.asset(
                'assets/images/register.png',
                height: screenHeight * 0.3,
                width: screenWidth,
                fit: BoxFit.cover,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Form(
                    key: _formKey,
                    child: Card(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameEditingController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color: _isNameValid ? Colors.black : Colors.red,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                icon: Image.asset(
                                  'assets/icons/name_icon.png',
                                  scale: 15,
                                ),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                errorStyle: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  setState(() {
                                    _isNameValid = false;
                                  });
                                  return "Enter your name";
                                } else {
                                  setState(() {
                                    _isNameValid = true;
                                  });
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _emailEditingController,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                color:
                                    _isEmailValid ? Colors.black : Colors.red,
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
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
                              height: 20,
                            ),
                            TextFormField(
                                controller: _pass1EditingController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  color:
                                      _isPassValid ? Colors.black : Colors.red,
                                ),
                                validator: (val) =>
                                    validatePassword(val.toString()),
                                obscureText: _password1Visible,
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
                                          _password1Visible =
                                              !_password1Visible;
                                        });
                                      },
                                      icon: _password1Visible
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
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                                controller: _pass2EditingController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  color:
                                      _isPassValid ? Colors.black : Colors.red,
                                ),
                                validator: (val) =>
                                    validatePassword(val.toString()),
                                obscureText: _password2Visible,
                                decoration: InputDecoration(
                                    labelText: 'Re-Enter Password',
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
                                          _password2Visible =
                                              !_password2Visible;
                                        });
                                      },
                                      icon: _password2Visible
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
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Checkbox(
                                    value: _isChecked,
                                    onChanged: (bool? value) {
                                      if (!_formKey.currentState!.validate()) {
                                        return;
                                      }
                                      setState(() {
                                        _isChecked = value!;
                                      });
                                    }),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'I have read and agree to the ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _showEULA,
                                  child: const Text(
                                    'Privacy Policy',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationColor:
                                          Color.fromARGB(255, 1, 8, 220),
                                      color: Color.fromARGB(255, 1, 8, 220),
                                    ),
                                  ),
                                ),
                                const Text(
                                  ' and ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _showEULA,
                                  child: const Text(
                                    'Term of Use',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationColor:
                                          Color.fromARGB(255, 1, 8, 220),
                                      color: Color.fromARGB(255, 1, 8, 220),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: _registerUserDialog,
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(screenWidth * 0.35, 45),
                                backgroundColor: Colors.green,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Sign Up',
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
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ));
                      },
                      child: const Text(
                        'Login',
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      setState(() {
        _isPassValid = false;
      });
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        setState(() {
          _isPassValid = false;
        });
        return 'Enter a valid password';
      } else {
        setState(() {
          _isPassValid = true;
        });
        return null;
      }
    }
  }

  void _registerUserDialog() {
    String pass1 = _pass1EditingController.text;
    String pass2 = _pass2EditingController.text;
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Check your input',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Please accept EULA",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (pass1 != pass2) {
      setState(() {
        _isPassValid = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Password does not match!\nPlease re-enter the password.",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      ));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 3),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Register New Account?",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _registerUser();
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(90, 40),
                        backgroundColor: Colors.green,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Registration Cancelled",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          backgroundColor: Colors.red,
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(90, 40),
                        backgroundColor: Colors.red,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'No',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  loadEula() async {
    eula = await rootBundle.loadString('assets/eula.txt');
  }

  void _showEULA() {
    loadEula();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "EULA",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                      child: RichText(
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        style:
                            const TextStyle(fontSize: 12, color: Colors.black),
                        text: eula),
                  )),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _registerUser() {
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String pass = _pass1EditingController.text;

    http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/user/register_user.php"),
        body: {
          "name": name,
          "email": email,
          "password": pass
        }).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Registration Success",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.green,
          ));
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => const LoginPage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Registration Failed",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
