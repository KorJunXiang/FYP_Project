import 'dart:convert';
// ignore: unused_import
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:landlordy/insert_data/addpropertypage.dart';
import 'package:landlordy/models/property.dart';
import 'package:landlordy/models/tenant.dart';
import 'package:landlordy/models/user.dart';
import 'package:landlordy/shared/loadingindicatorwidget.dart';
import 'package:landlordy/shared/myserverconfig.dart';
import 'package:landlordy/shared/navbar.dart';
import 'package:landlordy/views/rentalmonthlypage.dart';

class RentalPaymentPage extends StatefulWidget {
  final User userdata;
  const RentalPaymentPage({super.key, required this.userdata});

  @override
  State<RentalPaymentPage> createState() => _RentalPaymentPageState();
}

class _RentalPaymentPageState extends State<RentalPaymentPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  late double screenWidth, screenHeight;
  final int _selectedIndex = 2;
  List<Property> propertyList = <Property>[];
  List<Tenant> tenantList = <Tenant>[];
  String search = "";
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMore = true;
  bool isFabVisible = false;
  final scrollController = ScrollController();
  double previousScrollOffset = 0;
  int numberofresult = 0, resultperpage = 0, curpage = 1;

  @override
  void initState() {
    super.initState();
    propertyList.clear();
    scrollController.addListener(_scrollListener);
    loadPropertiesAndTenants();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: isFabVisible
          ? FloatingActionButton(
              onPressed: () {
                scrollController.animateTo(
                  scrollController.position.minScrollExtent,
                  duration: const Duration(seconds: 2),
                  curve: Curves.fastLinearToSlowEaseIn,
                );
              },
              shape: const CircleBorder(),
              child: Image.asset(
                'assets/icons/back_to_top_icon.png',
              ),
            )
          : null,
      key: scaffoldKey,
      drawer: NavBar(
        userdata: widget.userdata,
        selectedIndex: _selectedIndex,
      ),
      appBar: AppBar(
        title: const Text("Rental Payment",
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
            : (propertyList.isEmpty)
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
                                "$numberofresult Records",
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
                                        'No Properties',
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      const Text(
                                        'You don\'t have any properties yet.',
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
                                      _refresh();
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
                                "$numberofresult Records",
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
                        child: ListView.separated(
                          controller: scrollController,
                          itemCount: propertyList.length + 1,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            if (index < propertyList.length) {
                              return GestureDetector(
                                onTap: () async {
                                  Property singleProperty = propertyList[index];
                                  Tenant singleTenant = tenantList.firstWhere(
                                      (tenant) =>
                                          tenant.tenantId ==
                                          propertyList[index].tenantId,
                                      orElse: () => Tenant(
                                          tenantId: null,
                                          tenantName: "Not Available"));
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RentalMonthlyPage(
                                                  userdata: widget.userdata,
                                                  propertydetail:
                                                      singleProperty,
                                                  tenantdetail: singleTenant)));
                                  _refresh();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    border: const Border.symmetric(
                                        horizontal: BorderSide(
                                            color: Colors.black, width: 2)),
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  height: screenHeight * 0.16,
                                  child: Row(
                                    children: [
                                      Container(
                                        clipBehavior: Clip.antiAlias,
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 4, 0),
                                        width: screenWidth * 0.4,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: Colors.black, width: 2),
                                        ),
                                        child: Image.network(
                                          "${MyServerConfig.server}/landlordy/assets/properties/${propertyList[index].propertyId}_1.png",
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return const Center(
                                                child: LoadingIndicatorWidget(
                                                    type: 2),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const SizedBox(width: 10),
                                                  Flexible(
                                                    child: Text(
                                                      propertyList[index]
                                                          .propertyName
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 22,
                                                      ),
                                                      softWrap: false,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/icons/state_icon.png',
                                                    scale: 20,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Flexible(
                                                    child: Text(
                                                      "${propertyList[index].propertyState}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 20),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: false,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/icons/property_type_icon.png',
                                                    scale: 20,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Flexible(
                                                    child: Text(
                                                      "${propertyList[index].propertyType}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 20),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: false,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/icons/tenant_name_icon.png',
                                                    scale: 20,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Flexible(
                                                    child: Text(
                                                      "${tenantList.firstWhere(
                                                            (tenants) =>
                                                                tenants
                                                                    .tenantId ==
                                                                propertyList[
                                                                        index]
                                                                    .tenantId,
                                                            orElse: () => Tenant(
                                                                tenantName:
                                                                    'Not Available'),
                                                          ).tenantName}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: false,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      "RM${propertyList[index].rentalPrice}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 22,
                                                          fontStyle:
                                                              FontStyle.italic),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: false,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              if ((hasMore)) {
                                return const LoadingIndicatorWidget(type: 2);
                              } else {
                                return Container(
                                  color: Theme.of(context).colorScheme.primary,
                                  child: const Center(
                                    child: Text("You've Reached the End",
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18,
                                            color: Colors.white)),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ),
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
                        labelText: 'Search Property Name',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      search = searchController.text;
                      searchProperty(search);
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

  Future<void> searchProperty(String search) async {
    setState(() {
      isLoading = true;
    });
    await http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/property/load_property.php"),
        body: {
          "userid": widget.userdata.userid,
          "search": search,
        }).then((response) {
      // log(response.body);
      propertyList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          numberofresult = jsondata['numberofresult'];
          resultperpage = jsondata['resultperpage'];
          final List<Property> newPropertyList = <Property>[];
          jsondata['data']['properties'].forEach((v) {
            newPropertyList.add(Property.fromJson(v));
          });
          if (newPropertyList.length < resultperpage) {
            hasMore = false;
          }
          propertyList.addAll(newPropertyList);
        }
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<void> loadPropertiesAndTenants() async {
    final responseProperties = await http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/property/load_property.php"),
        body: {
          "userid": widget.userdata.userid,
          "pageno": curpage.toString(),
        });
    final responseTenants = await http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/tenant/load_tenant.php"),
        body: {
          "userid": widget.userdata.userid,
        });
    // log(responseProperties.body);
    // log(responseTenants.body);
    if (responseTenants.statusCode == 200) {
      var jsondatatenant = jsonDecode(responseTenants.body);
      if (jsondatatenant['status'] == "success") {
        tenantList.clear();
        jsondatatenant['data']['tenants'].forEach((v) {
          tenantList.add(Tenant.fromJson(v));
        });
      }
    }
    if (responseProperties.statusCode == 200) {
      var jsondataproperty = jsonDecode(responseProperties.body);
      if (jsondataproperty['status'] == "success") {
        numberofresult = jsondataproperty['numberofresult'];
        resultperpage = jsondataproperty['resultperpage'];
        final List<Property> newPropertyList = <Property>[];
        jsondataproperty['data']['properties'].forEach((v) {
          newPropertyList.add(Property.fromJson(v));
        });
        curpage++;
        if (newPropertyList.length < resultperpage) {
          hasMore = false;
        }
        propertyList.addAll(newPropertyList);
      }
      isLoading = false;
      setState(() {});
    }
  }

  Future<void> _refresh() async {
    return Future.delayed(
      const Duration(seconds: 1),
      () async {
        setState(() {
          isLoading = true;
        });
        propertyList.clear();
        isLoadingMore = false;
        hasMore = true;
        curpage = 1;
        await loadPropertiesAndTenants();
      },
    );
  }

  Future<void> _scrollListener() async {
    if (isLoadingMore) {
      return;
    }
    if (scrollController.offset > previousScrollOffset) {
      setState(() {
        isFabVisible = false;
      });
    } else {
      setState(() {
        isFabVisible = true;
      });
    }
    previousScrollOffset = scrollController.offset;
    if (scrollController.offset < 50) {
      setState(() {
        isFabVisible = false;
      });
    }
    if (scrollController.position.maxScrollExtent ==
        scrollController.position.pixels) {
      setState(() {
        isLoadingMore = true;
      });
      await loadPropertiesAndTenants();
      setState(() {
        isLoadingMore = false;
      });
    }
  }
}
