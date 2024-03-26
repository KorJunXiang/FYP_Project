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
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
        ),
        backgroundColor: Colors.transparent,
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
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                icon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                errorStyle: TextStyle(
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
                              decoration: const InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  icon: Icon(Icons.email_rounded),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  errorStyle: TextStyle(
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
                                    icon: const Icon(Icons.lock),
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
                                        icon: Icon(
                                          _password1Visible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        )),
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
                                    icon: const Icon(Icons.lock),
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
                                        icon: Icon(
                                          _password2Visible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        )),
                                    errorStyle: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 16))),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                  ],
                                ),
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 5,
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
                                const Column(
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      ' and',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
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
                        Navigator.push(
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
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          title: const Text(
            "Register new account?",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
          ),
          content: const Text("Are you sure?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _registerUser();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                    "Registration Cancelled",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.red,
                ));
              },
            ),
          ],
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
          Navigator.push(context,
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
