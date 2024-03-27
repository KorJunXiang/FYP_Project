import 'package:flutter/material.dart';
import 'package:landlordy/models/user.dart';
import 'package:landlordy/views/welcomepage.dart';

class PropertyListPage extends StatefulWidget {
  final User userdata;
  const PropertyListPage({super.key, required this.userdata});

  @override
  State<PropertyListPage> createState() => _PropertyListPageState();
}

class _PropertyListPageState extends State<PropertyListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Properties"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.userdata.username.toString()),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomePage(),
                      ));
                },
                child: const Text("Logout"))
          ],
        ),
      ),
    );
  }
}
