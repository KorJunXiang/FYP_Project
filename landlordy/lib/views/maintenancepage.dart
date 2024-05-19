import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:landlordy/insert_data/addmaintenancepage.dart';
import 'package:landlordy/insert_data/addpropertypage.dart';
import 'package:landlordy/models/maintenance.dart';
import 'package:landlordy/models/property.dart';
import 'package:landlordy/models/propertytenant.dart';
import 'package:landlordy/models/user.dart';
import 'package:landlordy/shared/myserverconfig.dart';
import 'package:landlordy/shared/navbar.dart';
import 'package:http/http.dart' as http;
import 'package:landlordy/views/maintenancedetailpage.dart';

class MaintenancePage extends StatefulWidget {
  final User userdata;
  const MaintenancePage({super.key, required this.userdata});

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final int _selectedIndex = 3;
  late double screenWidth, screenHeight;
  bool isLoading = true;
  List<Maintenance> maintenanceList = <Maintenance>[];
  List<Property> propertyList = <Property>[];
  List<PropertyTenant> propertytenant = <PropertyTenant>[];

  @override
  void initState() {
    super.initState();
    loadPropertiesAndMaintenances();
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
          title: const Text("Maintenance",
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
        body: Center(
          child: RefreshIndicator(
              onRefresh: _refresh,
              child: isLoading
                  ? Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showSearchDialog();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    'assets/icons/search_icon.png',
                                    scale: 18,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddPropertyPage(
                                            userdata: widget.userdata),
                                      ));
                                  loadPropertiesAndMaintenances();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    'assets/icons/add_icon.png',
                                    scale: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 100),
                          const CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    )
                  : (propertyList.isEmpty)
                      ? Column(
                          children: [
                            Row(
                              children: [
                                Card(
                                  elevation: 4,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    child: Text(
                                      "${maintenanceList.length} Records",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          showSearchDialog();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Image.asset(
                                            'assets/icons/search_icon.png',
                                            scale: 18,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddPropertyPage(
                                                      userdata:
                                                          widget.userdata),
                                            ),
                                          );
                                          loadPropertiesAndMaintenances();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Image.asset(
                                            'assets/icons/add_icon.png',
                                            scale: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Expanded(
                              child: ListView(
                                children: [
                                  Center(
                                    child: Column(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                height: screenHeight * 0.05),
                                            const Text(
                                              'No Properties',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            const Text(
                                              'You don\'t have any properties yet.',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: screenHeight * 0.05),
                                        ElevatedButton.icon(
                                          onPressed: () async {
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddPropertyPage(
                                                          userdata:
                                                              widget.userdata),
                                                ));
                                            loadPropertiesAndMaintenances();
                                          },
                                          icon: Image.asset(
                                            'assets/icons/add_icon.png',
                                            scale: 18,
                                          ),
                                          label: const Text("Add Property",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor:
                                                const Color.fromARGB(
                                                    200, 0, 0, 139),
                                            backgroundColor: Colors.white,
                                            elevation: 5,
                                            fixedSize:
                                                Size(screenWidth * 0.40, 50),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              side: const BorderSide(
                                                  width: 2,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 139)),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      : (propertytenant.isEmpty)
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    Card(
                                      elevation: 4,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 5, 10, 5),
                                        child: Text(
                                          "${maintenanceList.length} Records",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              showSearchDialog();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Image.asset(
                                                'assets/icons/search_icon.png',
                                                scale: 18,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddPropertyPage(
                                                          userdata:
                                                              widget.userdata),
                                                ),
                                              );
                                              loadPropertiesAndMaintenances();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Image.asset(
                                                'assets/icons/add_icon.png',
                                                scale: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: ListView(
                                    children: [
                                      Center(
                                        child: Column(
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                    height:
                                                        screenHeight * 0.05),
                                                const Text(
                                                  'No Properties With Tenant Details',
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                ),
                                                const Text(
                                                  'You don\'t have any properties with tenant details yet.',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                                height: screenHeight * 0.05),
                                            ElevatedButton.icon(
                                              onPressed: () async {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddPropertyPage(
                                                            userdata: widget
                                                                .userdata),
                                                  ),
                                                );
                                                loadPropertiesAndMaintenances();
                                              },
                                              icon: Image.asset(
                                                'assets/icons/add_icon.png',
                                                scale: 18,
                                              ),
                                              label: const Text("Add Property",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor:
                                                    const Color.fromARGB(
                                                        200, 0, 0, 139),
                                                backgroundColor: Colors.white,
                                                elevation: 5,
                                                fixedSize: Size(
                                                    screenWidth * 0.40, 50),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  side: const BorderSide(
                                                      width: 2,
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 139)),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          : (maintenanceList.isEmpty)
                              ? Column(
                                  children: [
                                    Row(
                                      children: [
                                        Card(
                                          elevation: 4,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 5, 10, 5),
                                            child: Text(
                                              "${maintenanceList.length} Records",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  showSearchDialog();
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Image.asset(
                                                    'assets/icons/search_icon.png',
                                                    scale: 18,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddPropertyPage(
                                                              userdata: widget
                                                                  .userdata),
                                                    ),
                                                  );
                                                  loadPropertiesAndMaintenances();
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Image.asset(
                                                    'assets/icons/add_icon.png',
                                                    scale: 18,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Expanded(
                                      child: ListView(
                                        children: [
                                          Center(
                                            child: Column(
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                        height: screenHeight *
                                                            0.05),
                                                    const Text(
                                                      'No Maintenances',
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.w900),
                                                    ),
                                                    const Text(
                                                      'You don\'t have any maintenances yet.',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height:
                                                        screenHeight * 0.05),
                                                ElevatedButton.icon(
                                                  onPressed: () async {
                                                    await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddMaintenancePage(
                                                            userdata:
                                                                widget.userdata,
                                                            propertytenant:
                                                                propertytenant,
                                                          ),
                                                        ));
                                                    loadPropertiesAndMaintenances();
                                                  },
                                                  icon: Image.asset(
                                                    'assets/icons/add_icon.png',
                                                    scale: 18,
                                                  ),
                                                  label: const Text(
                                                      "Add Maintenance",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    foregroundColor:
                                                        const Color.fromARGB(
                                                            200, 0, 0, 139),
                                                    backgroundColor:
                                                        Colors.white,
                                                    elevation: 5,
                                                    fixedSize: Size(
                                                        screenWidth * 0.45, 50),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      side: const BorderSide(
                                                          width: 2,
                                                          color: Color.fromARGB(
                                                              255, 0, 0, 139)),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              : Column(
                                  children: [
                                    Row(
                                      children: [
                                        Card(
                                          elevation: 4,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 5, 10, 5),
                                            child: Text(
                                              "${maintenanceList.length} Records",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  showSearchDialog();
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Image.asset(
                                                    'assets/icons/search_icon.png',
                                                    scale: 18,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddPropertyPage(
                                                              userdata: widget
                                                                  .userdata),
                                                    ),
                                                  );
                                                  loadPropertiesAndMaintenances();
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Image.asset(
                                                    'assets/icons/add_icon.png',
                                                    scale: 18,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[350],
                                          border: const Border.symmetric(
                                              horizontal: BorderSide(
                                                  color: Colors.black,
                                                  width: 2))),
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              flex: 4,
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/icons/id_icon.png',
                                                    scale: 15,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  const Text(
                                                    "Reference ID",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 25),
                                                  ),
                                                ],
                                              )),
                                          Expanded(
                                              flex: 3,
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/icons/cost_icon.png',
                                                    scale: 15,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  const Text(
                                                    "Cost",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 25),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: ListView.builder(
                                      itemCount: maintenanceList.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                            decoration: BoxDecoration(
                                                color: Colors.blue.shade100,
                                                border: const Border(
                                                    bottom: BorderSide(
                                                        color: Colors.black,
                                                        width: 2))),
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 5, 10, 5),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex: 4,
                                                    child: Text(
                                                      maintenanceList[index]
                                                          .referenceId
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      "RM ${maintenanceList[index].maintenanceCost}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    )),
                                                Expanded(
                                                    flex: 1,
                                                    child: GestureDetector(
                                                        onTap: () async {
                                                          Maintenance
                                                              singleMaintenance =
                                                              maintenanceList[
                                                                  index];
                                                          await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        MaintenanceDetailPage(
                                                                          userdata:
                                                                              widget.userdata,
                                                                          maintenancedetail:
                                                                              singleMaintenance,
                                                                          propertytenant:
                                                                              propertytenant,
                                                                        )),
                                                          );
                                                          loadPropertiesAndMaintenances();
                                                        },
                                                        child: Image.asset(
                                                          'assets/icons/next_icon.png',
                                                          scale: 18,
                                                        ))),
                                              ],
                                            ));
                                      },
                                    )),
                                  ],
                                )),
        ));
  }

  void showSearchDialog() {
    TextEditingController searchController = TextEditingController();
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
                  TextFormField(
                      controller: searchController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          labelText: 'Search Property Name / Reference ID',
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.0),
                          ))),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          String search = searchController.text;
                          searchPropertyName(search);
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(10),
                          fixedSize: Size.fromWidth(screenWidth * 0.3),
                          backgroundColor: Colors.blue,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Search\nProperty Name',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          String search = searchController.text;
                          searchReferenceID(search);
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(10),
                          fixedSize: Size.fromWidth(screenWidth * 0.3),
                          backgroundColor: Colors.blue,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Search\nReference ID',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        );
      },
    );
  }

  Future<void> searchPropertyName(String search) async {
    setState(() {
      isLoading = true;
    });
    await http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/maintenance/load_maintenance.php"),
        body: {
          "propertyname": search,
          "userId": widget.userdata.userid
        }).then((response) {
      log(response.body);
      maintenanceList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          jsondata['data']['maintenances'].forEach((v) {
            maintenanceList.add(Maintenance.fromJson(v));
          });
        }
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<void> searchReferenceID(String search) async {
    setState(() {
      isLoading = true;
    });
    await http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/maintenance/load_maintenance.php"),
        body: {
          "referenceID": search,
          "userId": widget.userdata.userid
        }).then((response) {
      log(response.body);
      maintenanceList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          jsondata['data']['maintenances'].forEach((v) {
            maintenanceList.add(Maintenance.fromJson(v));
          });
        }
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<void> loadPropertiesAndMaintenances() async {
    final responseProperties = await http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/property/load_property.php"),
        body: {"userid": widget.userdata.userid});
    final responseMaintenances = await http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/maintenance/load_maintenance.php"),
        body: {"userid": widget.userdata.userid});
    // log(responseProperties.body);
    // log(responseMaintenances.body);
    if (responseProperties.statusCode == 200 &&
        responseMaintenances.statusCode == 200) {
      var jsondataproperty = jsonDecode(responseProperties.body);
      var jsondatamaintenance = jsonDecode(responseMaintenances.body);
      if (jsondataproperty['status'] == "success" &&
          jsondatamaintenance['status'] == "success") {
        propertyList.clear();
        maintenanceList.clear();
        jsondataproperty['data']['properties'].forEach((v) {
          propertyList.add(Property.fromJson(v));
          if (v['tenant_id'] != null) {
            propertytenant.add(PropertyTenant.fromJson(v));
          }
        });
        jsondatamaintenance['data']['maintenances'].forEach((v) {
          maintenanceList.add(Maintenance.fromJson(v));
        });
      }
      isLoading = false;
      setState(() {});
    }
  }

  Future<void> _refresh() async {
    return Future.delayed(
      const Duration(seconds: 3),
      () {
        loadPropertiesAndMaintenances();
        setState(() {});
      },
    );
  }
}
