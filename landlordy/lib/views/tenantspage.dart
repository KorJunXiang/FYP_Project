import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:landlordy/insert_data/addpropertypage.dart';
import 'package:landlordy/models/tenant.dart';
import 'package:landlordy/models/user.dart';
import 'package:landlordy/shared/loadingindicatorwidget.dart';
import 'package:landlordy/shared/myserverconfig.dart';
import 'package:landlordy/shared/navbar.dart';
import 'package:landlordy/views/tenantdetailpage.dart';

class TenantsPage extends StatefulWidget {
  final User userdata;
  const TenantsPage({super.key, required this.userdata});

  @override
  State<TenantsPage> createState() => _TenantsPageState();
}

class _TenantsPageState extends State<TenantsPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  late double screenWidth, screenHeight;
  List<Tenant> tenantList = <Tenant>[];
  final int _selectedIndex = 1;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTenants();
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
        title: const Text("Tenants",
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
        onRefresh: () => _refresh(),
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
                      ],
                    ),
                    const SizedBox(height: 100),
                    const LoadingIndicatorWidget(type: 1),
                  ],
                ),
              )
            : tenantList.isEmpty
                ? Column(
                    children: [
                      Row(
                        children: [
                          Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            color: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Text(
                                "${tenantList.length} Records",
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: screenHeight * 0.05),
                                      const Text(
                                        'No Tenants',
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      const Text(
                                        'You don\'t have any properties with tenants yet.',
                                        style: TextStyle(
                                            fontSize: 16,
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
                                                    userdata: widget.userdata),
                                          ));
                                      loadTenants();
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
                                          const Color.fromARGB(200, 0, 0, 139),
                                      backgroundColor: Colors.white,
                                      elevation: 5,
                                      fixedSize: Size(screenWidth * 0.40, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: const BorderSide(
                                            width: 2,
                                            color:
                                                Color.fromARGB(255, 0, 0, 139)),
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
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            color: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Text(
                                "${tenantList.length} Records",
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
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[350],
                            border: const Border.symmetric(
                                horizontal:
                                    BorderSide(color: Colors.black, width: 2))),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            const Expanded(flex: 1, child: SizedBox()),
                            Expanded(
                                flex: 4,
                                child: Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    Image.asset(
                                      'assets/icons/tenant_name_icon.png',
                                      scale: 15,
                                    ),
                                    const SizedBox(width: 5),
                                    const Flexible(
                                      child: Text(
                                        "Name",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 25),
                                      ),
                                    ),
                                  ],
                                )),
                            Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/gender_icon.png',
                                      scale: 15,
                                    ),
                                    const SizedBox(width: 5),
                                    const Flexible(
                                      child: Text(
                                        "Gender",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 25),
                                      ),
                                    ),
                                  ],
                                )),
                            Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/age_icon.png',
                                      scale: 15,
                                    ),
                                    const SizedBox(width: 5),
                                    const Flexible(
                                      child: Text(
                                        "Age",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 25),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      Expanded(
                          child: CupertinoScrollbar(
                        radius: const Radius.circular(10),
                        thickness: 8,
                        child: ListView.builder(
                          itemCount: tenantList.length,
                          itemBuilder: (context, index) {
                            return Container(
                                height: screenHeight * 0.1,
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    border: const Border(
                                        bottom: BorderSide(
                                            color: Colors.black, width: 2))),
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: CircleAvatar(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        foregroundColor: Colors.white,
                                        child: Text(
                                          "${index + 1}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 4,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            tenantList[index]
                                                .tenantName
                                                .toString(),
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                        )),
                                    Expanded(
                                        flex: 3,
                                        child: Text(
                                          tenantList[index]
                                              .tenantGender
                                              .toString(),
                                          style: const TextStyle(fontSize: 20),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          tenantList[index]
                                              .tenantAge
                                              .toString(),
                                          style: const TextStyle(fontSize: 20),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                            onTap: () async {
                                              Tenant singleTenant =
                                                  tenantList[index];
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      TenantDetailPage(
                                                    userdata: widget.userdata,
                                                    tenantdetail: singleTenant,
                                                  ),
                                                ),
                                              );
                                              loadTenants();
                                            },
                                            child: Image.asset(
                                              'assets/icons/next_icon.png',
                                              scale: 18,
                                            ))),
                                  ],
                                ));
                          },
                        ),
                      )),
                    ],
                  ),
      ),
    );
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
                          labelText: 'Search Tenant Name',
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.0),
                          ))),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      String search = searchController.text;
                      searchTenant(search);
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
                      'Search',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }

  Future<void> searchTenant(String search) async {
    setState(() {
      isLoading = true;
    });
    await http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/tenant/load_tenant.php"),
        body: {
          "search": search,
          "userId": widget.userdata.userid
        }).then((response) {
      log(response.body);
      tenantList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          jsondata['data']['tenants'].forEach((v) {
            tenantList.add(Tenant.fromJson(v));
          });
        }
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<void> loadTenants() async {
    final responseTenants = await http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/tenant/load_tenant.php"),
        body: {"userid": widget.userdata.userid});
    // log(responseTenants.body);
    if (responseTenants.statusCode == 200) {
      var jsondatatenant = jsonDecode(responseTenants.body);
      if (jsondatatenant['status'] == "success") {
        tenantList.clear();
        jsondatatenant['data']['tenants'].forEach((v) {
          tenantList.add(Tenant.fromJson(v));
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
        loadTenants();
        setState(() {});
      },
    );
  }
}
