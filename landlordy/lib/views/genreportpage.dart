import 'package:flutter/material.dart';
import 'package:landlordy/models/user.dart';
import 'package:landlordy/shared/navbar.dart';
class GenReportPage extends StatefulWidget {
  final User userdata;
  const GenReportPage({super.key, required this.userdata});

  @override
  State<GenReportPage> createState() => _GenReportPageState();
}

class _GenReportPageState extends State<GenReportPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final int _selectedIndex = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: NavBar(
        userdata: widget.userdata,
        selectedIndex: _selectedIndex,
      ),
      appBar: AppBar(
        title: const Text("Generate Report",
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
      ),
    );
  }
}
