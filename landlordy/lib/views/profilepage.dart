import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:landlordy/edit_data/editprofilepage.dart';
import 'package:landlordy/models/user.dart';
import 'package:landlordy/shared/myserverconfig.dart';
import 'package:landlordy/shared/navbar.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  User userdata;
  ProfilePage({super.key, required this.userdata});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late double screenWidth, screenHeight;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final int _selectedIndex = 6;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      drawer: NavBar(
        userdata: widget.userdata,
        selectedIndex: _selectedIndex,
      ),
      appBar: AppBar(
        title: const Text("Profile",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            )),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            scaffoldKey.currentState?.openDrawer();
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              'assets/icons/menu_icon.png',
              scale: 15,
            ),
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(
                    userdata: widget.userdata,
                  ),
                ),
              );
              updateUserProfile();
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                'assets/icons/edit_icon.png',
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              height: screenHeight * 0.3,
              child: ClipOval(
                child: Image.network(
                  "${MyServerConfig.server}/landlordy/assets/profiles/${widget.userdata.userid}.png",
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      double progress = loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1);
                      return Center(
                          child: CircularProgressIndicator(
                        value: progress,
                        color: Colors.blue,
                      ));
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/images/user.png');
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/name_icon.png',
                        scale: 8,
                      ),
                      Expanded(
                        child: Container(
                          height: 80,
                          margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue.shade100,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Text(
                                widget.userdata.username.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/email_icon.png',
                        scale: 8,
                      ),
                      Expanded(
                        child: Container(
                          height: 80,
                          margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue.shade100,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Text(
                                widget.userdata.useremail.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(screenWidth * 0.6, 60),
                      backgroundColor: Colors.blue,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: Image.asset(
                      'assets/icons/reset_password_icon.png',
                      scale: 15,
                    ),
                    label: const Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateUserProfile() async {
    final responseUser = await http.post(
        Uri.parse("${MyServerConfig.server}/landlordy/php/user/load_user.php"),
        body: {"userid": widget.userdata.userid});
    log(responseUser.body);
    if (responseUser.statusCode == 200) {
      var jsondatauser = jsonDecode(responseUser.body);
      if (jsondatauser['status'] == "success") {
        User updatedUser = User.fromJson(jsondatauser['data']);
        setState(() {
          widget.userdata = updatedUser;
        });
      }
    }
  }
}
