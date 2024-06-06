import 'dart:convert';
// ignore: unused_import
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:landlordy/models/event.dart';
import 'package:landlordy/models/user.dart';
import 'package:landlordy/shared/loadingindicatorwidget.dart';
import 'package:landlordy/shared/myserverconfig.dart';
import 'package:landlordy/shared/navbar.dart';
import 'package:http/http.dart' as http;

class EventsPage extends StatefulWidget {
  final User userdata;
  const EventsPage({super.key, required this.userdata});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final int _selectedIndex = 4;
  late double screenWidth, screenHeight;
  List<Event> eventList = <Event>[];
  bool isLoading = true;

  @override
  void initState() {
    loadEvents();
    super.initState();
  }

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
          title: const Text("Events",
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
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: isLoading
              ? Center(
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.1),
                      const LoadingIndicatorWidget(type: 1),
                    ],
                  ),
                )
              : (eventList.isEmpty)
                  ? Center(
                      child: RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView(
                          children: [
                            Column(
                              children: [
                                SizedBox(height: screenHeight * 0.05),
                                Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: Colors.grey.shade300,
                                  child: Container(
                                    height: screenHeight * 0.15,
                                    width: screenWidth * 0.9,
                                    padding: const EdgeInsets.all(10),
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'No Events',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 25,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          'You don\'t have any event yet.',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                            child: CupertinoScrollbar(
                          radius: const Radius.circular(10),
                          thickness: 8,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(10),
                            itemCount: eventList.length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                height: screenHeight * 0.1,
                                child: Card(
                                  color: Colors.blue.shade100,
                                  child: ListTile(
                                    onTap: () {
                                      showEvent(eventList[index]);
                                    },
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      foregroundColor: Colors.white,
                                      child: Text(
                                        "${index + 1}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      eventList[index].title.toString(),
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      eventList[index].description.toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    trailing: Text(
                                      formatDate(eventList[index]
                                          .eventDate
                                          .toString()),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )),
                      ],
                    ),
        ));
  }

  void showEvent(Event event) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 3),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Container(
            width: screenWidth,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Card(
                      elevation: 4,
                      color: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          formatDate(event.eventDate.toString()),
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  event.title.toString(),
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          event.description.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size.fromHeight(40),
                        backgroundColor: Colors.blue,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Close',
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

  Future<void> loadEvents() async {
    setState(() {
      isLoading = true;
    });
    final responseEvents = await http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/event/load_event.php"),
        body: {"userid": widget.userdata.userid});
    // log(responseEvents.body);
    eventList.clear();
    if (responseEvents.statusCode == 200) {
      var jsondataevent = jsonDecode(responseEvents.body);
      if (jsondataevent['status'] == "success") {
        jsondataevent['data']['events'].forEach((v) {
          eventList.add(Event.fromJson(v));
        });
      }
      isLoading = false;
      setState(() {});
    }
  }

  String formatDate(String date) {
    return DateFormat('dd/MM/yyyy').format(DateTime.parse(date));
  }

  Future<void> _refresh() async {
    return Future.delayed(
      const Duration(seconds: 3),
      () {
        loadEvents();
        setState(() {});
      },
    );
  }
}
