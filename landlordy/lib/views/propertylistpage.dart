import 'package:flutter/material.dart';
import 'package:landlordy/models/user.dart';

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
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [Text(widget.userdata.username.toString())],
        ),
      ),
    );
  }
}
