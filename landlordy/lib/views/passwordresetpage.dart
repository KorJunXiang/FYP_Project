import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:landlordy/shared/myserverconfig.dart';
import 'package:http/http.dart' as http;

class PasswordResetPage extends StatefulWidget {
  final String email;
  const PasswordResetPage({super.key, required this.email});

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final TextEditingController _pass1EditingController = TextEditingController();
  final TextEditingController _pass2EditingController = TextEditingController();
  bool _password1Visible = true;
  bool _password2Visible = true;
  bool _isPassValid = true;
  final _formKey = GlobalKey<FormState>();
  late double screenWidth, screenHeight;

  @override
  void dispose() {
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
          "Reset Password",
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
      body: Form(
        key: _formKey,
        child: Center(
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
                            'Create New Password',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: screenHeight * 0.05),
                          TextFormField(
                              controller: _pass1EditingController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color: _isPassValid ? Colors.black : Colors.red,
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
                                        _password1Visible = !_password1Visible;
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
                          SizedBox(height: screenHeight * 0.02),
                          TextFormField(
                              controller: _pass2EditingController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color: _isPassValid ? Colors.black : Colors.red,
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
                                        _password2Visible = !_password2Visible;
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
                          SizedBox(height: screenHeight * 0.02),
                          ElevatedButton(
                            onPressed: updatePasswordDialog,
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(screenWidth * 0.35, 45),
                              backgroundColor: Colors.green,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Update',
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).*$';
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
        return 'Enter a valid password\nPassword must contain at least\n- One uppercase letter\n- One lowercase letter \n- One digit';
      } else {
        setState(() {
          _isPassValid = true;
        });
        return null;
      }
    }
  }

  void updatePasswordDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Check your input",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
      return;
    }
    String pass1 = _pass1EditingController.text;
    String pass2 = _pass2EditingController.text;
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
        duration: Duration(seconds: 2),
      ));
      return;
    }
    showCupertinoModalPopup(
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
                  "Update Password?",
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
                      onPressed: _updatePassword,
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

  Future<void> _updatePassword() async {
    String pass = _pass1EditingController.text;
    await http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/user/update_password.php"),
        body: {"email": widget.email, "password": pass}).then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Update Success",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ));
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Update Failed",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ));
        }
      }
    });
  }
}
