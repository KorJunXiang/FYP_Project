import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:landlordy/models/user.dart';
import 'package:landlordy/shared/myserverconfig.dart';
import 'package:landlordy/views/propertylistpage.dart';
import 'package:landlordy/views/signuppage.dart';
import 'package:http/http.dart' as http;

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
                            decoration: const InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                icon: Icon(Icons.email_rounded),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                errorStyle: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16)),
                            validator: (val) => val!.isEmpty ||
                                    !val.contains("@") ||
                                    !val.contains(".")
                                ? "Enter a valid email"
                                : null,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                              controller: _passEditingController,
                              validator: (val) =>
                                  val!.isEmpty ? "Enter your password" : null,
                              obscureText: _passwordVisible,
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
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                      icon: Icon(
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      )),
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
                                          setState(() {
                                            _isChecked = value!;
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
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: _loginUser,
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
                        Navigator.push(
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

  void _loginUser() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    String email = _emailEditingController.text;
    String pass = _passEditingController.text;

    http.post(
        Uri.parse("${MyServerConfig.server}/landlordy/php/user/login_user.php"),
        body: {"email": email, "password": pass}).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          User user = User.fromJson(data['data']);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Success",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.green,
          ));
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (content) => PropertyListPage(userdata: user)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Failed",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }

  void saveremovepref(bool bool) {}
}