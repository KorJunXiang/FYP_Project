import 'dart:convert';
import 'dart:developer';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:landlordy/models/maintenance.dart';
import 'package:landlordy/models/property.dart';
import 'package:landlordy/models/rentalpayment.dart';
import 'package:landlordy/models/tenant.dart';
import 'package:landlordy/models/user.dart';
import 'package:landlordy/shared/loadingindicatorwidget.dart';
import 'package:landlordy/shared/myserverconfig.dart';
import 'package:landlordy/shared/navbar.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class GenReportPage extends StatefulWidget {
  final User userdata;
  const GenReportPage({super.key, required this.userdata});

  @override
  State<GenReportPage> createState() => _GenReportPageState();
}

class _GenReportPageState extends State<GenReportPage> {
  final TextEditingController _datatypeEditingController =
      TextEditingController();
  final TextEditingController _fromEditingController = TextEditingController();
  final TextEditingController _toEditingController = TextEditingController();
  final TextEditingController _propertyEditingController =
      TextEditingController();
  final TextEditingController _tenantEditingController =
      TextEditingController();
  final TextEditingController _paymentEditingController =
      TextEditingController();
  final TextEditingController _maintenanceEditingController =
      TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final int _selectedIndex = 5;
  late double screenWidth, screenHeight;
  List<Maintenance> maintenanceList = <Maintenance>[];
  List<Property> propertyList = <Property>[];
  List<Tenant> tenantList = <Tenant>[];
  List<RentalPayment> paymentList = <RentalPayment>[];
  List<PropertyStatus> Properties = [];
  Set<String> uniquePropertyNames = {"All"};
  Set<String> uniqueTenantNames = {"All"};
  Set<String> uniquePaymentNames = {"All"};
  Set<String> uniqueMaintenanceNames = {"All"};
  List<String> propertyname = [];
  List<String> tenantname = [];
  List<String> paymentname = [];
  List<String> maintenancename = [];
  List<String> datatype = [
    "Property",
    "Tenant",
    "Rental Payment",
    "Maintenance",
  ];
  bool isLoading = true;
  bool _isDataTypeValid = true;
  bool _isFromValid = true;
  bool _isToValid = true;
  bool _isPropertyValid = true;
  bool _isTenantValid = true;
  bool _isPaymentValid = true;
  bool _isMaintenanceValid = true;
  bool _isPropertyVisible = false;
  bool _isTenantVisible = false;
  bool _isPaymentVisible = false;
  bool _isMaintenanceVisible = false;

  @override
  void initState() {
    super.initState();
    loadDataList();
  }

  @override
  void dispose() {
    _datatypeEditingController.dispose();
    _fromEditingController.dispose();
    _toEditingController.dispose();
    _propertyEditingController.dispose();
    _tenantEditingController.dispose();
    _paymentEditingController.dispose();
    _maintenanceEditingController.dispose();
    super.dispose();
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
        title: const Text('Report',
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
      body: Form(
        child: Center(
          child: RefreshIndicator(
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
                : Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: ListView(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Select Data Type",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 4),
                              DropdownButtonFormField2<String>(
                                style: TextStyle(
                                  fontSize: 17,
                                  color: _isDataTypeValid
                                      ? Colors.black
                                      : Colors.red,
                                ),
                                isExpanded: true,
                                menuItemStyleData: const MenuItemStyleData(
                                  padding: EdgeInsets.only(left: 10),
                                ),
                                iconStyleData: const IconStyleData(
                                    openMenuIcon: Icon(
                                        Icons.arrow_drop_up_rounded,
                                        color: Colors.black),
                                    icon: Icon(Icons.arrow_drop_down_rounded,
                                        color: Colors.black),
                                    iconSize: 30),
                                dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                decoration: InputDecoration(
                                  label: const Text(
                                    'Data Type',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  errorStyle: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                items: datatype.map((String items) {
                                  return DropdownMenuItem<String>(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                validator: (value) {
                                  if (value == null) {
                                    setState(() {
                                      _isDataTypeValid = false;
                                    });
                                    return 'Select data type';
                                  } else {
                                    setState(() {
                                      _isDataTypeValid = true;
                                    });
                                    return null;
                                  }
                                },
                                onChanged: (newValue) async {
                                  await visible(newValue!);
                                  setState(() {});
                                },
                              ),
                              const SizedBox(height: 10),
                              Visibility(
                                  visible: _isPropertyVisible,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Select Property",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      const SizedBox(height: 4),
                                      DropdownButtonFormField2<String>(
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: _isPropertyValid
                                              ? Colors.black
                                              : Colors.red,
                                        ),
                                        isExpanded: true,
                                        menuItemStyleData:
                                            const MenuItemStyleData(
                                          padding: EdgeInsets.only(left: 10),
                                        ),
                                        iconStyleData: const IconStyleData(
                                            openMenuIcon: Icon(
                                                Icons.arrow_drop_up_rounded,
                                                color: Colors.black),
                                            icon: Icon(
                                                Icons.arrow_drop_down_rounded,
                                                color: Colors.black),
                                            iconSize: 30),
                                        dropdownStyleData: DropdownStyleData(
                                          maxHeight: 200,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        decoration: InputDecoration(
                                          label: const Text(
                                            'Property',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          errorStyle: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 16),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        items: propertyname.map((String items) {
                                          return DropdownMenuItem<String>(
                                            value: items,
                                            child: Text(items),
                                          );
                                        }).toList(),
                                        validator: (value) {
                                          if (value == null) {
                                            setState(() {
                                              _isPropertyValid = false;
                                            });
                                            return 'Select property';
                                          } else {
                                            setState(() {
                                              _isPropertyValid = true;
                                            });
                                            return null;
                                          }
                                        },
                                        onChanged: (newValue) {
                                          setState(() {
                                            _propertyEditingController.text =
                                                newValue!;
                                          });
                                        },
                                      ),
                                    ],
                                  )),
                              Visibility(
                                  visible: _isTenantVisible,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Select Tenant",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      const SizedBox(height: 4),
                                      DropdownButtonFormField2<String>(
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: _isTenantValid
                                              ? Colors.black
                                              : Colors.red,
                                        ),
                                        isExpanded: true,
                                        menuItemStyleData:
                                            const MenuItemStyleData(
                                          padding: EdgeInsets.only(left: 10),
                                        ),
                                        iconStyleData: const IconStyleData(
                                            openMenuIcon: Icon(
                                                Icons.arrow_drop_up_rounded,
                                                color: Colors.black),
                                            icon: Icon(
                                                Icons.arrow_drop_down_rounded,
                                                color: Colors.black),
                                            iconSize: 30),
                                        dropdownStyleData: DropdownStyleData(
                                          maxHeight: 200,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        decoration: InputDecoration(
                                          label: const Text(
                                            'Tenant',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          errorStyle: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 16),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        items: tenantname.map((String items) {
                                          return DropdownMenuItem<String>(
                                            value: items,
                                            child: Text(items),
                                          );
                                        }).toList(),
                                        validator: (value) {
                                          if (value == null) {
                                            setState(() {
                                              _isTenantValid = false;
                                            });
                                            return 'Select tenant';
                                          } else {
                                            setState(() {
                                              _isTenantValid = true;
                                            });
                                            return null;
                                          }
                                        },
                                        onChanged: (newValue) {
                                          setState(() {
                                            _tenantEditingController.text =
                                                newValue!;
                                          });
                                        },
                                      ),
                                    ],
                                  )),
                              Visibility(
                                  visible: _isPaymentVisible,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Select Rental Payment",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      const SizedBox(height: 4),
                                      DropdownButtonFormField2<String>(
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: _isPaymentValid
                                              ? Colors.black
                                              : Colors.red,
                                        ),
                                        isExpanded: true,
                                        menuItemStyleData:
                                            const MenuItemStyleData(
                                          padding: EdgeInsets.only(left: 10),
                                        ),
                                        iconStyleData: const IconStyleData(
                                            openMenuIcon: Icon(
                                                Icons.arrow_drop_up_rounded,
                                                color: Colors.black),
                                            icon: Icon(
                                                Icons.arrow_drop_down_rounded,
                                                color: Colors.black),
                                            iconSize: 30),
                                        dropdownStyleData: DropdownStyleData(
                                          maxHeight: 200,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        decoration: InputDecoration(
                                          label: const Text(
                                            'Rental Payment',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          errorStyle: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 16),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        items: paymentname.map((String items) {
                                          return DropdownMenuItem<String>(
                                            value: items,
                                            child: Text(items),
                                          );
                                        }).toList(),
                                        validator: (value) {
                                          if (value == null) {
                                            setState(() {
                                              _isPaymentValid = false;
                                            });
                                            return 'Select rental payment';
                                          } else {
                                            setState(() {
                                              _isPaymentValid = true;
                                            });
                                            return null;
                                          }
                                        },
                                        onChanged: (newValue) {
                                          setState(() {
                                            _paymentEditingController.text =
                                                newValue!;
                                          });
                                        },
                                      ),
                                    ],
                                  )),
                              Visibility(
                                  visible: _isMaintenanceVisible,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Select Maintenance",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      const SizedBox(height: 4),
                                      DropdownButtonFormField2<String>(
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: _isMaintenanceValid
                                              ? Colors.black
                                              : Colors.red,
                                        ),
                                        isExpanded: true,
                                        menuItemStyleData:
                                            const MenuItemStyleData(
                                          padding: EdgeInsets.only(left: 10),
                                        ),
                                        iconStyleData: const IconStyleData(
                                            openMenuIcon: Icon(
                                                Icons.arrow_drop_up_rounded,
                                                color: Colors.black),
                                            icon: Icon(
                                                Icons.arrow_drop_down_rounded,
                                                color: Colors.black),
                                            iconSize: 30),
                                        dropdownStyleData: DropdownStyleData(
                                          maxHeight: 200,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        decoration: InputDecoration(
                                          label: const Text(
                                            'Maintenance',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          errorStyle: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 16),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        items:
                                            maintenancename.map((String items) {
                                          return DropdownMenuItem<String>(
                                            value: items,
                                            child: Text(items),
                                          );
                                        }).toList(),
                                        validator: (value) {
                                          if (value == null) {
                                            setState(() {
                                              _isMaintenanceValid = false;
                                            });
                                            return 'Select maintenance';
                                          } else {
                                            setState(() {
                                              _isMaintenanceValid = true;
                                            });
                                            return null;
                                          }
                                        },
                                        onChanged: (newValue) {
                                          setState(() {
                                            _maintenanceEditingController.text =
                                                newValue!;
                                          });
                                        },
                                      ),
                                    ],
                                  )),
                              Visibility(
                                visible: _isPaymentVisible,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 10,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "From",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          const SizedBox(height: 4),
                                          DropdownButtonFormField2<String>(
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: _isFromValid
                                                  ? Colors.black
                                                  : Colors.red,
                                            ),
                                            isExpanded: true,
                                            menuItemStyleData:
                                                const MenuItemStyleData(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                            ),
                                            iconStyleData: const IconStyleData(
                                                openMenuIcon: Icon(
                                                    Icons.arrow_drop_up_rounded,
                                                    color: Colors.black),
                                                icon: Icon(
                                                    Icons
                                                        .arrow_drop_down_rounded,
                                                    color: Colors.black),
                                                iconSize: 30),
                                            dropdownStyleData:
                                                DropdownStyleData(
                                              maxHeight: 200,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            decoration: InputDecoration(
                                              label: const Text(
                                                'Month & Year',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              errorStyle: const TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 16),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            items: propertyname
                                                .map((String items) {
                                              return DropdownMenuItem<String>(
                                                value: items,
                                                child: Text(items),
                                              );
                                            }).toList(),
                                            validator: (value) {
                                              if (value == null) {
                                                setState(() {
                                                  _isFromValid = false;
                                                });
                                                return 'Select month & year from';
                                              } else {
                                                setState(() {
                                                  _isFromValid = true;
                                                });
                                                return null;
                                              }
                                            },
                                            onChanged: (newValue) {
                                              setState(() {
                                                _fromEditingController.text =
                                                    newValue!;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(flex: 1),
                                    Expanded(
                                      flex: 10,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "To",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          const SizedBox(height: 4),
                                          DropdownButtonFormField2<String>(
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: _isToValid
                                                  ? Colors.black
                                                  : Colors.red,
                                            ),
                                            isExpanded: true,
                                            menuItemStyleData:
                                                const MenuItemStyleData(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                            ),
                                            iconStyleData: const IconStyleData(
                                                openMenuIcon: Icon(
                                                    Icons.arrow_drop_up_rounded,
                                                    color: Colors.black),
                                                icon: Icon(
                                                    Icons
                                                        .arrow_drop_down_rounded,
                                                    color: Colors.black),
                                                iconSize: 30),
                                            dropdownStyleData:
                                                DropdownStyleData(
                                              maxHeight: 200,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            decoration: InputDecoration(
                                              label: const Text(
                                                'Month & Year',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              errorStyle: const TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 16),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            items: propertyname
                                                .map((String items) {
                                              return DropdownMenuItem<String>(
                                                value: items,
                                                child: Text(items),
                                              );
                                            }).toList(),
                                            validator: (value) {
                                              if (value == null) {
                                                setState(() {
                                                  _isToValid = false;
                                                });
                                                return 'Select month & year to';
                                              } else {
                                                setState(() {
                                                  _isToValid = true;
                                                });
                                                return null;
                                              }
                                            },
                                            onChanged: (newValue) {
                                              setState(() {
                                                _toEditingController.text =
                                                    newValue!;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      late String data1, data2, data3;
                                      if (_isPropertyVisible) {
                                        data1 = _propertyEditingController.text;
                                        data2 = "";
                                        data3 = "";
                                        _tenantEditingController.clear();
                                      } else if (_isTenantVisible) {
                                        data1 = _tenantEditingController.text;
                                        data2 = "";
                                        data3 = "";
                                      } else if (_isPaymentVisible) {
                                        data1 = _paymentEditingController.text;
                                        data2 = _fromEditingController.text;
                                        data3 = _toEditingController.text;
                                      } else if (_isMaintenanceVisible) {
                                        data1 =
                                            _maintenanceEditingController.text;
                                        data2 = "";
                                        data3 = "";
                                      }
                                      if (!_formKey.currentState!.validate()) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                            'Check your input',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 2),
                                        ));
                                        return;
                                      }
                                      findData(data1, data2, data3);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(screenWidth * 0.35, 45),
                                      backgroundColor: Colors.blue,
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'Submit',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Visibility(
                                visible: _isPropertyVisible,
                                child: SfCircularChart(
                                  legend: const Legend(
                                    isVisible: true,
                                    overflowMode: LegendItemOverflowMode.wrap,
                                  ),
                                  series: <CircularSeries>[
                                    DoughnutSeries<PropertyStatus, String>(
                                      dataSource: Properties,
                                      xValueMapper: (PropertyStatus data, _) =>
                                          data.propertyName,
                                      yValueMapper: (PropertyStatus data, _) =>
                                          data.quantity,
                                      dataLabelSettings:
                                          const DataLabelSettings(
                                        isVisible: true,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> visible(String value) async {
    if (value == "Property") {
      _isPropertyVisible = true;
      _isTenantVisible = false;
      _isPaymentVisible = false;
      _isMaintenanceVisible = false;
    } else if (value == "Tenant") {
      _isPropertyVisible = false;
      _isTenantVisible = true;
      _isPaymentVisible = false;
      _isMaintenanceVisible = false;
    } else if (value == "Rental Payment") {
      _isPropertyVisible = false;
      _isTenantVisible = false;
      _isPaymentVisible = true;
      _isMaintenanceVisible = false;
    } else if (value == "Maintenance") {
      _isPropertyVisible = false;
      _isTenantVisible = false;
      _isPaymentVisible = false;
      _isMaintenanceVisible = true;
    }
  }

  void populateNameLists() {
    propertyname.clear();
    tenantname.clear();
    paymentname.clear();
    maintenancename.clear();
    for (Property property in propertyList) {
      uniquePropertyNames.add(property.propertyName!);
    }
    for (Tenant tenant in tenantList) {
      uniqueTenantNames.add(tenant.tenantName!);
    }
    for (RentalPayment payment in paymentList) {
      uniquePaymentNames.add(payment.tenantName!);
    }
    for (Maintenance maintenance in maintenanceList) {
      uniqueMaintenanceNames.add(maintenance.propertyName!);
    }
    propertyname = uniquePropertyNames.toList();
    tenantname = uniqueTenantNames.toList();
    paymentname = uniquePaymentNames.toList();
    maintenancename = uniqueMaintenanceNames.toList();
    // log("Property names populated: $propertyname");
  }

  Future<void> loadDataList() async {
    final responseProperties = await http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/property/load_property.php"),
        body: {
          "userid": widget.userdata.userid,
          "type": "all",
        });
    final responseTenants = await http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/tenant/load_tenant.php"),
        body: {
          "userid": widget.userdata.userid,
        });
    final responseMaintenances = await http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/maintenance/load_maintenance.php"),
        body: {
          "userid": widget.userdata.userid,
        });
    final responsePayments = await http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/rentalpayment/load_payment.php"),
        body: {
          "userid": widget.userdata.userid,
        });
    // log(responseProperties.body);
    // log(responseTenants.body);
    // log(responseMaintenances.body);
    // log(responsePayments.body);
    if (responseProperties.statusCode == 200) {
      var jsondataproperty = jsonDecode(responseProperties.body);
      if (jsondataproperty['status'] == "success") {
        propertyList.clear();
        jsondataproperty['data']['properties'].forEach((v) {
          propertyList.add(Property.fromJson(v));
        });
      }
    }
    if (responseTenants.statusCode == 200) {
      var jsondatatenant = jsonDecode(responseTenants.body);
      if (jsondatatenant['status'] == "success") {
        tenantList.clear();
        jsondatatenant['data']['tenants'].forEach((v) {
          tenantList.add(Tenant.fromJson(v));
        });
      }
    }
    if (responseMaintenances.statusCode == 200) {
      var jsondatamaintenance = jsonDecode(responseMaintenances.body);
      if (jsondatamaintenance['status'] == "success") {
        maintenanceList.clear();
        jsondatamaintenance['data']['maintenances'].forEach((v) {
          maintenanceList.add(Maintenance.fromJson(v));
        });
      }
    }
    if (responsePayments.statusCode == 200) {
      var jsondatapayment = jsonDecode(responsePayments.body);
      if (jsondatapayment['status'] == "success") {
        paymentList.clear();
        jsondatapayment['data']['payments'].forEach((v) {
          paymentList.add(RentalPayment.fromJson(v));
        });
      }
    }
    populateNameLists();
    isLoading = false;
    setState(() {});
  }

  void findData(String data1, String data2, String data3) async {
    log(data1);
    log(data2);
    log(data3);
    if (_isPropertyVisible) {
      for (var property in propertyList) {
        PropertyStatus propertyStatus = PropertyStatus(
          propertyName: property.propertyName,
          quantity: 1,
        );
        Properties.add(propertyStatus);
      }
    } else {}
    for (var property in Properties) {
      print(
          'Property Name: ${property.propertyName}, Quantity: ${property.quantity}');
    }
  }

  Future<void> _refresh() async {
    return Future.delayed(
      const Duration(seconds: 3),
      () {
        loadDataList();
        propertyname.clear();
        tenantname.clear();
        paymentname.clear();
        maintenancename.clear();
        setState(() {});
      },
    );
  }
}

class PropertyStatus {
  String? propertyName;
  int? quantity;

  PropertyStatus({this.propertyName, this.quantity});

  PropertyStatus.fromJson(Map<String, dynamic> json) {
    propertyName = json['property_name'];
    quantity = 1; // Set the quantity to 1 for each property
  }

  Map<String, dynamic> toJson() {
    return {
      'property_name': propertyName,
      'quantity': quantity,
    };
  }
}
