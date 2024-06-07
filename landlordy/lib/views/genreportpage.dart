import 'dart:convert';
import 'dart:developer';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:landlordy/models/maintenance.dart';
import 'package:landlordy/models/property.dart';
import 'package:landlordy/models/rentalpayment.dart';
import 'package:landlordy/models/tenant.dart';
import 'package:landlordy/models/tenantpayment.dart';
import 'package:landlordy/models/user.dart';
import 'package:landlordy/shared/loadingindicatorwidget.dart';
import 'package:landlordy/shared/myserverconfig.dart';
import 'package:landlordy/shared/navbar.dart';
import 'package:http/http.dart' as http;
import 'package:landlordy/views/genchartpage.dart';

class GenReportPage extends StatefulWidget {
  final User userdata;
  const GenReportPage({super.key, required this.userdata});

  @override
  State<GenReportPage> createState() => _GenReportPageState();
}

class _GenReportPageState extends State<GenReportPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final int _selectedIndex = 5;
  late double screenWidth, screenHeight;
  String? data1, data2, data3;
  String? datatypeValue,
      propertyValue,
      propertyDataValue,
      tenantValue,
      tenantDataValue,
      paymentValue,
      maintenanceValue,
      maintenanceDataValue,
      fromValue,
      toValue;
  List<Maintenance> maintenanceList = <Maintenance>[];
  List<Property> propertyList = <Property>[];
  List<Tenant> tenantList = <Tenant>[];
  List<RentalPayment> paymentList = <RentalPayment>[];
  Map<String, List<TenantPayment>> tenantPaymentMap = {};
  Map<String, int> propertyStateQuantity = {};
  Map<String, int> propertyTypeQuantity = {};
  Map<String, int> propertyTenantQuantity = {};
  Map<String, int> propertyStatusQuantity = {};
  Map<String, int> propertyPriceQuantity = {};
  Map<String, int> tenantAgeQuantity = {};
  Map<String, int> tenantGenderQuantity = {};
  Map<String, int> tenantCategoryQuantity = {};
  Map<String, int> tenantStatusQuantity = {};
  Map<String, int> tenantPriceQuantity = {};
  Map<String, int> maintenanceTypeQuantity = {};
  Map<String, int> maintenanceTypeCost = {};
  Map<String, int> maintenancePropertyQuantity = {};
  Map<String, int> maintenancePropertyCost = {};
  Map<String, int> maintenanceTenantQuantity = {};
  Map<String, int> maintenanceTenantCost = {};
  Map<String, int> maintenanceCostQuantity = {};
  List<List<TenantPayment>>? tenantPaymentsList = [];
  Set<String> uniquePropertyNames = {"All"};
  Set<String> uniqueTenantNames = {"All"};
  Set<String> uniquePaymentNames = {"All"};
  Set<String> uniqueMaintenanceNames = {"All"};
  Set<String> uniquePropertyName = {};
  Set<String> uniqueTenantName = {};
  Set<String> uniquePaymentName = {};
  Set<String> uniqueMaintenanceName = {};
  late List<String> tenantNames = [];
  List<String> propertyname = [];
  List<String> tenantname = [];
  List<String> paymentname = [];
  List<String> maintenancename = [];
  Set<int> uniqueYears = {};
  List<String> monthYearList = [];
  List<String> datatype = [
    "Property",
    "Tenant",
    "Rental Payment",
    "Maintenance",
  ];
  List<String> propertydata = [
    "Property State",
    "Property Type",
    "Property Tenant",
    "Property Status",
    "Rental Price",
  ];
  List<String> tenantdata = [
    "Tenant Age",
    "Tenant Gender",
    "Tenant Category",
    "Tenant Status",
    "Rental Price",
  ];
  List<String> maintenancedata = [
    "Maintenance Type Quantity",
    "Maintenance Type Cost",
    "Maintenance Property Quantity",
    "Maintenance Property Cost",
    "Maintenance Tenant Quantity",
    "Maintenance Tenant Cost",
    "Maintenance Cost"
  ];
  bool isLoading = true;
  bool isFound = false;
  bool _isDataTypeValid = true;
  bool _isFromValid = true;
  bool _isToValid = true;
  // bool _isPropertyValid = true;
  bool _isPropertyDataValid = true;
  // bool _isTenantValid = true;
  bool _isTenantDataValid = true;
  bool _isPaymentValid = true;
  // bool _isMaintenanceValid = true;
  bool _isMaintenanceDataValid = true;
  bool _isPropertyVisible = false;
  bool _isTenantVisible = false;
  bool _isPaymentVisible = false;
  bool _isMaintenanceVisible = false;

  @override
  void initState() {
    loadDataList();
    super.initState();
  }

  @override
  void dispose() {
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
                          _buildDropdowns(),
                          _buildSubmitButton(),
                          _buildResultsContainer(),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdowns() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Data Type",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField2<String>(
          value: datatypeValue,
          style: TextStyle(
            fontSize: 17,
            color: _isDataTypeValid ? Colors.black : Colors.red,
          ),
          isExpanded: true,
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.only(left: 10),
          ),
          iconStyleData: const IconStyleData(
              openMenuIcon:
                  Icon(Icons.arrow_drop_up_rounded, color: Colors.black),
              icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.black),
              iconSize: 30),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          decoration: InputDecoration(
            label: const Text(
              'Data Type',
              style: TextStyle(fontWeight: FontWeight.bold),
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
            await visible(newValue);
            setState(() {
              isFound = false;
              propertyValue = propertyDataValue = tenantValue =
                  tenantDataValue = paymentValue = maintenanceValue =
                      maintenanceDataValue = fromValue = toValue = null;
              datatypeValue = newValue;
            });
          },
        ),
        const SizedBox(height: 10),
        // Visibility(
        //   visible: _isPropertyVisible,
        //   child: _buildPropertyDropdown(),
        // ),
        Visibility(
          visible: _isPropertyVisible,
          child: _buildPropertyDataDropdown(),
        ),
        // Visibility(
        //   visible: _isTenantVisible,
        //   child: _buildTenantDropdown(),
        // ),
        Visibility(
          visible: _isTenantVisible,
          child: _buildTenantDataDropdown(),
        ),
        Visibility(
          visible: _isPaymentVisible,
          child: _buildPaymentDropdown(),
        ),
        // Visibility(
        //   visible: _isMaintenanceVisible,
        //   child: _buildMaintenanceDropdown(),
        // ),
        Visibility(
          visible: _isMaintenanceVisible,
          child: _buildMaintenanceDataDropdown(),
        ),
        Visibility(
          visible: _isPaymentVisible,
          child: _buildDateRangeSelector(),
        ),
      ],
    );
  }

  // Widget _buildPropertyDropdown() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         "Select Property",
  //         style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
  //       ),
  //       const SizedBox(height: 4),
  //       DropdownButtonFormField2<String>(
  //         value: propertyValue,
  //         style: TextStyle(
  //           fontSize: 17,
  //           color: _isPropertyValid ? Colors.black : Colors.red,
  //         ),
  //         isExpanded: true,
  //         menuItemStyleData: const MenuItemStyleData(
  //           padding: EdgeInsets.only(left: 10),
  //         ),
  //         iconStyleData: const IconStyleData(
  //             openMenuIcon:
  //                 Icon(Icons.arrow_drop_up_rounded, color: Colors.black),
  //             icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.black),
  //             iconSize: 30),
  //         dropdownStyleData: DropdownStyleData(
  //           maxHeight: 200,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //         ),
  //         decoration: InputDecoration(
  //           label: const Text(
  //             'Property',
  //             style: TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //           errorStyle: const TextStyle(
  //               color: Colors.red,
  //               fontWeight: FontWeight.bold,
  //               fontStyle: FontStyle.italic,
  //               fontSize: 16),
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //         ),
  //         items: propertyname.map((String items) {
  //           return DropdownMenuItem<String>(
  //             value: items,
  //             child: Text(items),
  //           );
  //         }).toList(),
  //         validator: (value) {
  //           if (value == null) {
  //             setState(() {
  //               _isPropertyValid = false;
  //             });
  //             return 'Select property';
  //           } else {
  //             setState(() {
  //               _isPropertyValid = true;
  //             });
  //             return null;
  //           }
  //         },
  //         onChanged: (newValue) {
  //           setState(() {
  //             propertyValue = newValue;
  //           });
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget _buildPropertyDataDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Data",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField2<String>(
          value: propertyDataValue,
          style: TextStyle(
            fontSize: 17,
            color: _isPropertyDataValid ? Colors.black : Colors.red,
          ),
          isExpanded: true,
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.only(left: 10),
          ),
          iconStyleData: const IconStyleData(
              openMenuIcon:
                  Icon(Icons.arrow_drop_up_rounded, color: Colors.black),
              icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.black),
              iconSize: 30),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          decoration: InputDecoration(
            label: const Text(
              'Data',
              style: TextStyle(fontWeight: FontWeight.bold),
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
          items: propertydata.map((String items) {
            return DropdownMenuItem<String>(
              value: items,
              child: Text(items),
            );
          }).toList(),
          validator: (value) {
            if (value == null) {
              setState(() {
                _isPropertyDataValid = false;
              });
              return 'Select Data';
            } else {
              setState(() {
                _isPropertyDataValid = true;
              });
              return null;
            }
          },
          onChanged: (newValue) {
            setState(() {
              propertyDataValue = newValue;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTenantDataDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Data",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField2<String>(
          value: tenantDataValue,
          style: TextStyle(
            fontSize: 17,
            color: _isTenantDataValid ? Colors.black : Colors.red,
          ),
          isExpanded: true,
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.only(left: 10),
          ),
          iconStyleData: const IconStyleData(
              openMenuIcon:
                  Icon(Icons.arrow_drop_up_rounded, color: Colors.black),
              icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.black),
              iconSize: 30),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          decoration: InputDecoration(
            label: const Text(
              'Data',
              style: TextStyle(fontWeight: FontWeight.bold),
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
          items: tenantdata.map((String items) {
            return DropdownMenuItem<String>(
              value: items,
              child: Text(items),
            );
          }).toList(),
          validator: (value) {
            if (value == null) {
              setState(() {
                _isTenantDataValid = false;
              });
              return 'Select Data';
            } else {
              setState(() {
                _isTenantDataValid = true;
              });
              return null;
            }
          },
          onChanged: (newValue) {
            setState(() {
              tenantDataValue = newValue;
            });
          },
        ),
      ],
    );
  }

  // Widget _buildTenantDropdown() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         "Select Tenant",
  //         style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
  //       ),
  //       const SizedBox(height: 4),
  //       DropdownButtonFormField2<String>(
  //         value: tenantValue,
  //         style: TextStyle(
  //           fontSize: 17,
  //           color: _isTenantValid ? Colors.black : Colors.red,
  //         ),
  //         isExpanded: true,
  //         menuItemStyleData: const MenuItemStyleData(
  //           padding: EdgeInsets.only(left: 10),
  //         ),
  //         iconStyleData: const IconStyleData(
  //             openMenuIcon:
  //                 Icon(Icons.arrow_drop_up_rounded, color: Colors.black),
  //             icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.black),
  //             iconSize: 30),
  //         dropdownStyleData: DropdownStyleData(
  //           maxHeight: 200,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //         ),
  //         decoration: InputDecoration(
  //           label: const Text(
  //             'Tenant',
  //             style: TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //           errorStyle: const TextStyle(
  //               color: Colors.red,
  //               fontWeight: FontWeight.bold,
  //               fontStyle: FontStyle.italic,
  //               fontSize: 16),
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //         ),
  //         items: tenantname.map((String items) {
  //           return DropdownMenuItem<String>(
  //             value: items,
  //             child: Text(items),
  //           );
  //         }).toList(),
  //         validator: (value) {
  //           if (value == null) {
  //             setState(() {
  //               _isTenantValid = false;
  //             });
  //             return 'Select tenant';
  //           } else {
  //             setState(() {
  //               _isTenantValid = true;
  //             });
  //             return null;
  //           }
  //         },
  //         onChanged: (newValue) {
  //           setState(() {
  //             tenantValue = newValue;
  //           });
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget _buildPaymentDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Tenant",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField2<String>(
          value: paymentValue,
          style: TextStyle(
            fontSize: 17,
            color: _isPaymentValid ? Colors.black : Colors.red,
          ),
          isExpanded: true,
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.only(left: 10),
          ),
          iconStyleData: const IconStyleData(
              openMenuIcon:
                  Icon(Icons.arrow_drop_up_rounded, color: Colors.black),
              icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.black),
              iconSize: 30),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          decoration: InputDecoration(
            label: const Text(
              'Tenant',
              style: TextStyle(fontWeight: FontWeight.bold),
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
              return 'Select tenant';
            } else {
              setState(() {
                _isPaymentValid = true;
              });
              return null;
            }
          },
          onChanged: (newValue) {
            setState(() {
              paymentValue = newValue;
            });
          },
        ),
      ],
    );
  }

  // Widget _buildMaintenanceDropdown() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         "Select Maintenance",
  //         style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
  //       ),
  //       const SizedBox(height: 4),
  //       DropdownButtonFormField2<String>(
  //         value: maintenanceValue,
  //         style: TextStyle(
  //           fontSize: 17,
  //           color: _isMaintenanceValid ? Colors.black : Colors.red,
  //         ),
  //         isExpanded: true,
  //         menuItemStyleData: const MenuItemStyleData(
  //           padding: EdgeInsets.only(left: 10),
  //         ),
  //         iconStyleData: const IconStyleData(
  //             openMenuIcon:
  //                 Icon(Icons.arrow_drop_up_rounded, color: Colors.black),
  //             icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.black),
  //             iconSize: 30),
  //         dropdownStyleData: DropdownStyleData(
  //           maxHeight: 200,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //         ),
  //         decoration: InputDecoration(
  //           label: const Text(
  //             'Maintenance',
  //             style: TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //           errorStyle: const TextStyle(
  //               color: Colors.red,
  //               fontWeight: FontWeight.bold,
  //               fontStyle: FontStyle.italic,
  //               fontSize: 16),
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //         ),
  //         items: maintenancename.map((String items) {
  //           return DropdownMenuItem<String>(
  //             value: items,
  //             child: Text(items),
  //           );
  //         }).toList(),
  //         validator: (value) {
  //           if (value == null) {
  //             setState(() {
  //               _isMaintenanceValid = false;
  //             });
  //             return 'Select maintenance';
  //           } else {
  //             setState(() {
  //               _isMaintenanceValid = true;
  //             });
  //             return null;
  //           }
  //         },
  //         onChanged: (newValue) {
  //           setState(() {
  //             maintenanceValue = newValue;
  //           });
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget _buildMaintenanceDataDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Data",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField2<String>(
          value: maintenanceDataValue,
          style: TextStyle(
            fontSize: 17,
            color: _isMaintenanceDataValid ? Colors.black : Colors.red,
          ),
          isExpanded: true,
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.only(left: 10),
          ),
          iconStyleData: const IconStyleData(
              openMenuIcon:
                  Icon(Icons.arrow_drop_up_rounded, color: Colors.black),
              icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.black),
              iconSize: 30),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          decoration: InputDecoration(
            label: const Text(
              'Data',
              style: TextStyle(fontWeight: FontWeight.bold),
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
          items: maintenancedata.map((String items) {
            return DropdownMenuItem<String>(
              value: items,
              child: Text(items),
            );
          }).toList(),
          validator: (value) {
            if (value == null) {
              setState(() {
                _isMaintenanceDataValid = false;
              });
              return 'Select Data';
            } else {
              setState(() {
                _isMaintenanceDataValid = true;
              });
              return null;
            }
          },
          onChanged: (newValue) {
            setState(() {
              maintenanceDataValue = newValue;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDateRangeSelector() {
    return Column(
      children: [
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              flex: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "From",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  DropdownButtonFormField2<String>(
                    value: fromValue,
                    style: TextStyle(
                      fontSize: 17,
                      color: _isFromValid ? Colors.black : Colors.red,
                    ),
                    isExpanded: true,
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    iconStyleData: const IconStyleData(
                        openMenuIcon: Icon(Icons.arrow_drop_up_rounded,
                            color: Colors.black),
                        icon: Icon(Icons.arrow_drop_down_rounded,
                            color: Colors.black),
                        iconSize: 30),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    decoration: InputDecoration(
                      label: const Text(
                        'Month & Year',
                        style: TextStyle(fontWeight: FontWeight.bold),
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
                    items: monthYearList.map((String items) {
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
                        fromValue = newValue;
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "To",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  DropdownButtonFormField2<String>(
                    value: toValue,
                    style: TextStyle(
                      fontSize: 17,
                      color: _isToValid ? Colors.black : Colors.red,
                    ),
                    isExpanded: true,
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    iconStyleData: const IconStyleData(
                        openMenuIcon: Icon(Icons.arrow_drop_up_rounded,
                            color: Colors.black),
                        icon: Icon(Icons.arrow_drop_down_rounded,
                            color: Colors.black),
                        iconSize: 30),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    decoration: InputDecoration(
                      label: const Text(
                        'Month & Year',
                        style: TextStyle(fontWeight: FontWeight.bold),
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
                    items: monthYearList.map((String items) {
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
                        toValue = newValue;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Column(
      children: [
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                if (_isPropertyVisible) {
                  data1 = propertyValue;
                  data2 = propertyDataValue;
                  data3 = null;
                } else if (_isTenantVisible) {
                  data1 = tenantValue;
                  data2 = tenantDataValue;
                  data3 = null;
                } else if (_isPaymentVisible) {
                  data1 = paymentValue;
                  data2 = fromValue;
                  data3 = toValue;
                } else if (_isMaintenanceVisible) {
                  data1 = maintenanceValue;
                  data2 = maintenanceDataValue;
                  data3 = null;
                }
                if (!_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                      'Check your input',
                      style: TextStyle(fontWeight: FontWeight.bold),
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
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildResultsContainer() {
    return Visibility(
      visible: isFound,
      child: (_isPropertyVisible && propertyDataValue != null)
          ? Column(
              children: [
                Container(
                  height: screenHeight * 0.45,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade200,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text.rich(
                              TextSpan(
                                text: 'Data: ',
                                style: const TextStyle(fontSize: 25),
                                children: [
                                  TextSpan(
                                    text: '$propertyDataValue',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) => const Divider(
                            thickness: 2,
                            color: Colors.grey,
                          ),
                          itemCount: () {
                            if (propertyDataValue == "Property State") {
                              return propertyStateQuantity.length;
                            } else if (propertyDataValue == "Property Type") {
                              return propertyTypeQuantity.length;
                            } else if (propertyDataValue == "Property Tenant") {
                              return propertyTenantQuantity.length;
                            } else if (propertyDataValue == "Property Status") {
                              return propertyStatusQuantity.length;
                            } else if (propertyDataValue == "Rental Price") {
                              return propertyPriceQuantity.length;
                            } else {
                              return 0;
                            }
                          }(),
                          itemBuilder: (context, index) {
                            String key;
                            int quantity;
                            int? flex1, flex2;
                            if (propertyDataValue == "Property State") {
                              key = propertyStateQuantity.keys.elementAt(index);
                              quantity = propertyStateQuantity[key]!;
                            } else if (propertyDataValue == "Property Type") {
                              key = propertyTypeQuantity.keys.elementAt(index);
                              quantity = propertyTypeQuantity[key]!;
                            } else if (propertyDataValue == "Property Tenant") {
                              key =
                                  propertyTenantQuantity.keys.elementAt(index);
                              quantity = propertyTenantQuantity[key]!;
                              flex1 = 9;
                              flex2 = 1;
                            } else if (propertyDataValue == "Property Status") {
                              key =
                                  propertyStatusQuantity.keys.elementAt(index);
                              quantity = propertyStatusQuantity[key]!;
                            } else if (propertyDataValue == "Rental Price") {
                              key = propertyPriceQuantity.keys.elementAt(index);
                              quantity = propertyPriceQuantity[key]!;
                            } else {
                              key = '';
                              quantity = 0;
                            }
                            return Container(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: flex1 ?? 6,
                                        child: Text(
                                          key,
                                          style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                        flex: flex2 ?? 4,
                                        child: Text(
                                          quantity.toString(),
                                          style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                ElevatedButton(
                  onPressed: () {
                    Map<String, int> propertyQuantities = {};
                    if (propertyDataValue == "Property State") {
                      propertyQuantities = propertyStateQuantity;
                    } else if (propertyDataValue == "Property Type") {
                      propertyQuantities = propertyTypeQuantity;
                    } else if (propertyDataValue == "Property Tenant") {
                      propertyQuantities = propertyTenantQuantity;
                    } else if (propertyDataValue == "Property Status") {
                      propertyQuantities = propertyStatusQuantity;
                    } else if (propertyDataValue == "Rental Price") {
                      propertyQuantities = propertyPriceQuantity;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (content) => GenChartPage(
                          data: propertyDataValue,
                          mapQuantities: propertyQuantities,
                          datatype: datatypeValue,
                          tenantPaymentsList: null,
                          tenantNames: null,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(screenWidth * 0.35, 45),
                    backgroundColor: Colors.green,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Generate',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
              ],
            )
          : (_isTenantVisible && tenantDataValue != null)
              ? Column(
                  children: [
                    Container(
                      height: screenHeight * 0.45,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade200,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text.rich(
                                  TextSpan(
                                    text: 'Data: ',
                                    style: const TextStyle(fontSize: 25),
                                    children: [
                                      TextSpan(
                                        text: '$tenantDataValue',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                thickness: 2,
                                color: Colors.grey,
                              ),
                              itemCount: () {
                                if (tenantDataValue == "Tenant Age") {
                                  return tenantAgeQuantity.length;
                                } else if (tenantDataValue == "Tenant Gender") {
                                  return tenantGenderQuantity.length;
                                } else if (tenantDataValue ==
                                    "Tenant Category") {
                                  return tenantCategoryQuantity.length;
                                } else if (tenantDataValue == "Tenant Status") {
                                  return tenantStatusQuantity.length;
                                } else if (tenantDataValue == "Rental Price") {
                                  return tenantPriceQuantity.length;
                                } else {
                                  return 0;
                                }
                              }(),
                              itemBuilder: (context, index) {
                                String key;
                                int quantity;
                                if (tenantDataValue == "Tenant Age") {
                                  key = tenantAgeQuantity.keys.elementAt(index);
                                  quantity = tenantAgeQuantity[key]!;
                                } else if (tenantDataValue == "Tenant Gender") {
                                  key = tenantGenderQuantity.keys
                                      .elementAt(index);
                                  quantity = tenantGenderQuantity[key]!;
                                } else if (tenantDataValue ==
                                    "Tenant Category") {
                                  key = tenantCategoryQuantity.keys
                                      .elementAt(index);
                                  quantity = tenantCategoryQuantity[key]!;
                                } else if (tenantDataValue == "Tenant Status") {
                                  key = tenantStatusQuantity.keys
                                      .elementAt(index);
                                  quantity = tenantStatusQuantity[key]!;
                                } else if (tenantDataValue == "Rental Price") {
                                  key =
                                      tenantPriceQuantity.keys.elementAt(index);
                                  quantity = tenantPriceQuantity[key]!;
                                } else {
                                  key = '';
                                  quantity = 0;
                                }
                                return Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 6,
                                            child: Text(
                                              key,
                                              style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Text(
                                              quantity.toString(),
                                              style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: () {
                        Map<String, int> tenantQuantities = {};
                        if (tenantDataValue == "Tenant Age") {
                          tenantQuantities = tenantAgeQuantity;
                        } else if (tenantDataValue == "Tenant Gender") {
                          tenantQuantities = tenantGenderQuantity;
                        } else if (tenantDataValue == "Tenant Category") {
                          tenantQuantities = tenantCategoryQuantity;
                        } else if (tenantDataValue == "Tenant Status") {
                          tenantQuantities = tenantStatusQuantity;
                        } else if (tenantDataValue == "Rental Price") {
                          tenantQuantities = tenantPriceQuantity;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (content) => GenChartPage(
                              data: tenantDataValue,
                              mapQuantities: tenantQuantities,
                              datatype: datatypeValue,
                              tenantPaymentsList: null,
                              tenantNames: null,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(screenWidth * 0.35, 45),
                        backgroundColor: Colors.green,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Generate',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                )
              : (_isPaymentVisible && tenantPaymentsList != null)
                  ? Column(
                      children: [
                        Container(
                          height: screenHeight * 0.45,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade200,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: tenantPaymentsList!.length,
                                  separatorBuilder: (context, index) =>
                                      const Divider(
                                    color: Colors.black,
                                    thickness: 2,
                                  ),
                                  itemBuilder: (context, outerIndex) {
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text.rich(
                                                  TextSpan(
                                                    text: 'Tenant Name: ',
                                                    style: const TextStyle(
                                                        fontSize: 25),
                                                    children: [
                                                      TextSpan(
                                                        text: tenantNames[
                                                            outerIndex],
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          separatorBuilder: (context, index) =>
                                              const Divider(
                                            thickness: 2,
                                            color: Colors.grey,
                                          ),
                                          itemCount:
                                              tenantPaymentsList![outerIndex]
                                                  .length,
                                          itemBuilder: (context, innerIndex) {
                                            final payment =
                                                tenantPaymentsList![outerIndex]
                                                    [innerIndex];
                                            return Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 10),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 6,
                                                    child: Text(
                                                      payment.monthYear ?? '',
                                                      style: const TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 4,
                                                    child: Text(
                                                      payment.paymentAmount
                                                              ?.toString() ??
                                                          '',
                                                      style: const TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (content) => GenChartPage(
                                  data: null,
                                  mapQuantities: null,
                                  tenantPaymentsList: tenantPaymentsList!,
                                  datatype: datatypeValue,
                                  tenantNames: tenantNames,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(screenWidth * 0.35, 45),
                            backgroundColor: Colors.green,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Generate',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    )
                  : ((_isMaintenanceVisible && maintenanceDataValue != null))
                      ? Column(
                          children: [
                            Container(
                              height: screenHeight * 0.45,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade200,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text.rich(
                                          TextSpan(
                                            text: 'Data: ',
                                            style:
                                                const TextStyle(fontSize: 25),
                                            children: [
                                              TextSpan(
                                                text: '$maintenanceDataValue',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      separatorBuilder: (context, index) =>
                                          const Divider(
                                        thickness: 2,
                                        color: Colors.grey,
                                      ),
                                      itemCount: () {
                                        if (maintenanceDataValue ==
                                            "Maintenance Type Quantity") {
                                          return maintenanceTypeQuantity.length;
                                        } else if (maintenanceDataValue ==
                                            "Maintenance Type Cost") {
                                          return maintenanceTypeCost.length;
                                        } else if (maintenanceDataValue ==
                                            "Maintenance Property Quantity") {
                                          return maintenancePropertyQuantity
                                              .length;
                                        } else if (maintenanceDataValue ==
                                            "Maintenance Property Cost") {
                                          return maintenancePropertyCost.length;
                                        } else if (maintenanceDataValue ==
                                            "Maintenance Tenant Quantity") {
                                          return maintenanceTenantQuantity
                                              .length;
                                        } else if (maintenanceDataValue ==
                                            "Maintenance Tenant Cost") {
                                          return maintenanceTenantCost.length;
                                        } else if (maintenanceDataValue ==
                                            "Maintenance Cost") {
                                          return maintenanceCostQuantity.length;
                                        } else {
                                          return 0;
                                        }
                                      }(),
                                      itemBuilder: (context, index) {
                                        String key;
                                        int quantity;
                                        int? flex1, flex2;
                                        if (maintenanceDataValue ==
                                            "Maintenance Type Quantity") {
                                          key = maintenanceTypeQuantity.keys
                                              .elementAt(index);
                                          quantity =
                                              maintenanceTypeQuantity[key]!;
                                          flex1 = 9;
                                          flex2 = 1;
                                        } else if (maintenanceDataValue ==
                                            "Maintenance Type Cost") {
                                          key = maintenanceTypeCost.keys
                                              .elementAt(index);
                                          quantity = maintenanceTypeCost[key]!;
                                          flex1 = 9;
                                          flex2 = 1;
                                        } else if (maintenanceDataValue ==
                                            "Maintenance Property Quantity") {
                                          key = maintenancePropertyQuantity.keys
                                              .elementAt(index);
                                          quantity =
                                              maintenancePropertyQuantity[key]!;
                                          flex1 = 9;
                                          flex2 = 1;
                                        } else if (maintenanceDataValue ==
                                            "Maintenance Property Cost") {
                                          key = maintenancePropertyCost.keys
                                              .elementAt(index);
                                          quantity =
                                              maintenancePropertyCost[key]!;
                                          flex1 = 9;
                                          flex2 = 1;
                                        } else if (maintenanceDataValue ==
                                            "Maintenance Tenant Quantity") {
                                          key = maintenanceTenantQuantity.keys
                                              .elementAt(index);
                                          quantity =
                                              maintenanceTenantQuantity[key]!;
                                          flex1 = 9;
                                          flex2 = 1;
                                        } else if (maintenanceDataValue ==
                                            "Maintenance Tenant Cost") {
                                          key = maintenanceTenantCost.keys
                                              .elementAt(index);
                                          quantity =
                                              maintenanceTenantCost[key]!;
                                          flex1 = 9;
                                          flex2 = 1;
                                        } else if (maintenanceDataValue ==
                                            "Maintenance Cost") {
                                          key = maintenanceCostQuantity.keys
                                              .elementAt(index);
                                          quantity =
                                              maintenanceCostQuantity[key]!;
                                        } else {
                                          key = '';
                                          quantity = 0;
                                        }
                                        return Container(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: flex1 ?? 6,
                                                    child: Text(
                                                      key,
                                                      style: const TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: flex2 ?? 4,
                                                    child: Text(
                                                      quantity.toString(),
                                                      style: const TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            ElevatedButton(
                              onPressed: () {
                                Map<String, int> maintenanceQuantities = {};
                                if (maintenanceDataValue ==
                                    "Maintenance Type Quantity") {
                                  maintenanceQuantities =
                                      maintenanceTypeQuantity;
                                } else if (maintenanceDataValue ==
                                    "Maintenance Type Cost") {
                                  maintenanceQuantities = maintenanceTypeCost;
                                } else if (maintenanceDataValue ==
                                    "Maintenance Property Quantity") {
                                  maintenanceQuantities =
                                      maintenancePropertyQuantity;
                                } else if (maintenanceDataValue ==
                                    "Maintenance Property Cost") {
                                  maintenanceQuantities =
                                      maintenancePropertyCost;
                                } else if (maintenanceDataValue ==
                                    "Maintenance Tenant Quantity") {
                                  maintenanceQuantities =
                                      maintenanceTenantQuantity;
                                } else if (maintenanceDataValue ==
                                    "Maintenance Tenant Cost") {
                                  maintenanceQuantities = maintenanceTenantCost;
                                } else if (maintenanceDataValue ==
                                    "Maintenance Cost") {
                                  maintenanceQuantities =
                                      maintenanceCostQuantity;
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (content) => GenChartPage(
                                      data: maintenanceDataValue,
                                      mapQuantities: maintenanceQuantities,
                                      datatype: datatypeValue,
                                      tenantPaymentsList: null,
                                      tenantNames: null,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(screenWidth * 0.35, 45),
                                backgroundColor: Colors.green,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Generate',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade200,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Center(
                            child: Text(
                              "No Data Found",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
    );
  }

  Future<void> visible(String? value) async {
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
      uniquePropertyName.add(property.propertyName!);
    }
    for (Tenant tenant in tenantList) {
      uniqueTenantNames.add(tenant.tenantName!);
      uniqueTenantName.add(tenant.tenantName!);
    }
    for (RentalPayment payment in paymentList) {
      uniquePaymentNames.add(payment.tenantName!);
      uniquePaymentName.add(payment.tenantName!);
    }
    for (Maintenance maintenance in maintenanceList) {
      uniqueMaintenanceNames.add(maintenance.propertyName!);
      uniqueMaintenanceName.add(maintenance.propertyName!);
    }
    propertyname = uniquePropertyNames.toList();
    tenantname = uniqueTenantNames.toList();
    paymentname = uniquePaymentNames.toList();
    maintenancename = uniqueMaintenanceNames.toList();
  }

  List<String> generateMonthYearList(String currentYear, int latestYear) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final finalYear = latestYear;
    final startYear = int.parse(currentYear) - 5;
    List<String> monthYearList = [];

    for (int year = startYear; year <= finalYear + 5; year++) {
      for (String month in months) {
        monthYearList.add('$month $year');
      }
    }

    return monthYearList;
  }

  Future<void> loadDataList() async {
    String originalYear = formatYear(widget.userdata.userdatereg.toString());
    final responseProperties = await http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/property/load_property.php"),
        body: {"userid": widget.userdata.userid, "type": "all"});
    final responseTenants = await http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/tenant/load_tenant.php"),
        body: {"userid": widget.userdata.userid});
    final responseMaintenances = await http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/maintenance/load_maintenance.php"),
        body: {"userid": widget.userdata.userid});
    final responsePayments = await http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/rentalpayment/load_payment.php"),
        body: {"userid": widget.userdata.userid});

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
          int paymentYear = int.parse(v['year']);
          uniqueYears.add(paymentYear);
        });
      }
    }
    int latestYear =
        uniqueYears.reduce((current, next) => current > next ? current : next);
    monthYearList = generateMonthYearList(originalYear, latestYear);
    populateNameLists();
    isLoading = false;
    setState(() {});
  }

  void findData(String? data1, String? data2, String? data3) async {
    log("Data1: $data1 Data2: $data2 Data3: $data3");

    final Map<String, int> monthMap = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12
    };

    if (_isPropertyVisible) {
      propertyStateQuantity.clear();
      propertyTypeQuantity.clear();
      propertyTenantQuantity.clear();
      propertyStatusQuantity.clear();
      propertyPriceQuantity.clear();

      String getPriceRange(double price) {
        if (price >= 0 && price <= 1000) {
          return "RM0 - RM1000";
        } else if (price > 1000 && price <= 2500) {
          return "RM1001 - RM2500";
        } else if (price > 2500 && price <= 5000) {
          return "RM2501 - RM5000";
        } else if (price > 5000 && price <= 8000) {
          return "RM5001 - RM8000";
        } else {
          return "RM8001 & above";
        }
      }

      int getTenantQuantity(String propertyname) {
        int quantity = 0;
        for (var tenant in tenantList) {
          if (tenant.latestProperty != null &&
              tenant.latestProperty == propertyname) {
            quantity++;
          }
        }
        return quantity;
      }

      for (var property in propertyList) {
        if (property.propertyName != null) {
          int quantity = getTenantQuantity(property.propertyName!);
          propertyTenantQuantity.update(
              property.propertyName!, (value) => quantity,
              ifAbsent: () => quantity);
        }
        if (property.propertyState != null) {
          propertyStateQuantity.update(
              property.propertyState!, (value) => value + 1,
              ifAbsent: () => 1);
        }
        if (property.propertyType != null) {
          propertyTypeQuantity.update(
              property.propertyType!, (value) => value + 1,
              ifAbsent: () => 1);
        }
        if (property.propertyStatus != null) {
          propertyStatusQuantity.update(
              property.propertyStatus!, (value) => value + 1,
              ifAbsent: () => 1);
        }
        if (property.rentalPrice != null) {
          String priceRange =
              getPriceRange(double.parse(property.rentalPrice!));
          propertyPriceQuantity.update(priceRange, (value) => value + 1,
              ifAbsent: () => 1);
        }
      }

      // propertyStateQuantity.forEach((key, value) {
      //   log('State: $key, Quantity: $value');
      // });
      // propertyTypeQuantity.forEach((key, value) {
      //   log('Type: $key, Quantity: $value');
      // });
      // propertyStatusQuantity.forEach((key, quantity) {
      //   log('Status: $key, Quantity: $quantity');
      // });
      // propertyPriceQuantity.forEach((key, quantity) {
      //   log('Price: $key, Quantity: $quantity');
      // });
      setState(() {
        isFound = true;
      });
    }

    if (_isTenantVisible) {
      tenantAgeQuantity.clear();
      tenantCategoryQuantity.clear();
      tenantGenderQuantity.clear();
      tenantStatusQuantity.clear();
      tenantPriceQuantity.clear();

      String getPriceRange(double price) {
        if (price >= 0 && price <= 1000) {
          return "RM0 - RM1000";
        } else if (price > 1000 && price <= 2500) {
          return "RM1001 - RM2500";
        } else if (price > 2500 && price <= 5000) {
          return "RM2501 - RM5000";
        } else if (price > 5000 && price <= 8000) {
          return "RM5001 - RM8000";
        } else {
          return "RM8001 & above";
        }
      }

      String getAgeRange(int age) {
        if (age >= 0 && age <= 20) {
          return "0 - 20";
        } else if (age > 20 && age <= 30) {
          return "21 - 30";
        } else if (age > 30 && age <= 40) {
          return "31 - 40";
        } else if (age > 40 && age <= 50) {
          return "41 - 50";
        } else {
          return "51 & above";
        }
      }

      for (var tenant in tenantList) {
        if (tenant.tenantAge != null) {
          String ageRange = getAgeRange(int.parse(tenant.tenantAge!));
          tenantAgeQuantity.update(ageRange, (value) => value + 1,
              ifAbsent: () => 1);
        }
        if (tenant.tenantGender != null) {
          tenantGenderQuantity.update(
              tenant.tenantGender!, (value) => value + 1,
              ifAbsent: () => 1);
        }
        if (tenant.tenantCategory != null) {
          tenantCategoryQuantity.update(
              tenant.tenantCategory!, (value) => value + 1,
              ifAbsent: () => 1);
        }
        if (tenant.rentalStatus != null) {
          tenantStatusQuantity.update(
              tenant.rentalStatus!, (value) => value + 1,
              ifAbsent: () => 1);
        }
        if (tenant.rentalPrice != null) {
          String priceRange = getPriceRange(double.parse(tenant.rentalPrice!));
          tenantPriceQuantity.update(priceRange, (value) => value + 1,
              ifAbsent: () => 1);
        }
      }

      // tenantAgeQuantity.forEach((key, value) {
      //   log('Age: $key, Quantity: $value');
      // });
      // tenantGenderQuantity.forEach((key, value) {
      //   log('Gender: $key, Quantity: $value');
      // });
      // tenantCategoryQuantity.forEach((key, quantity) {
      //   log('Category: $key, Quantity: $quantity');
      // });
      // tennatStatusQuantity.forEach((key, value) {
      //   log('Status: $key, Quantity: $value');
      // });
      // tenantPriceQuantity.forEach((key, quantity) {
      //   log('Price: $key, Quantity: $quantity');
      // });
      setState(() {
        isFound = true;
      });
    }

    if (_isMaintenanceVisible) {
      maintenanceTypeQuantity.clear();
      maintenanceTypeCost.clear();
      maintenancePropertyQuantity.clear();
      maintenancePropertyCost.clear();
      maintenanceTenantQuantity.clear();
      maintenanceTenantCost.clear();
      maintenanceCostQuantity.clear();

      String getCostRange(double price) {
        if (price >= 0 && price <= 50) {
          return "RM0 - RM50";
        } else if (price > 50 && price <= 100) {
          return "RM51 - RM100";
        } else if (price > 100 && price <= 200) {
          return "RM1 - RM200";
        } else if (price > 200 && price <= 300) {
          return "RM201 - RM300";
        } else {
          return "RM301 & above";
        }
      }

      int getTotalCost(String data) {
        int totalCost = 0;
        for (var maintenance in maintenanceList) {
          if (maintenance.maintenanceType == data &&
              maintenance.maintenanceCost != null) {
            totalCost += int.parse(maintenance.maintenanceCost!);
          } else if (maintenance.propertyName == data &&
              maintenance.maintenanceCost != null) {
            totalCost += int.parse(maintenance.maintenanceCost!);
          } else if (maintenance.tenantName == data &&
              maintenance.maintenanceCost != null) {
            totalCost += int.parse(maintenance.maintenanceCost!);
          }
        }
        return totalCost;
      }

      for (var maintenance in maintenanceList) {
        if (maintenance.maintenanceType != null) {
          maintenanceTypeQuantity.update(
              maintenance.maintenanceType!, (value) => value + 1,
              ifAbsent: () => 1);
        }
        if (maintenance.maintenanceType != null) {
          int totalCost = getTotalCost(maintenance.maintenanceType!);
          maintenanceTypeCost.update(
              maintenance.maintenanceType!, (value) => totalCost,
              ifAbsent: () => totalCost);
        }
        if (maintenance.propertyName != null) {
          maintenancePropertyQuantity.update(
              maintenance.propertyName!, (value) => value + 1,
              ifAbsent: () => 1);
        }
        if (maintenance.propertyName != null) {
          int totalCost = getTotalCost(maintenance.propertyName!);
          maintenancePropertyCost.update(
              maintenance.propertyName!, (value) => totalCost,
              ifAbsent: () => totalCost);
        }
        if (maintenance.tenantName != null) {
          maintenanceTenantQuantity.update(
              maintenance.tenantName!, (value) => value + 1,
              ifAbsent: () => 1);
        }
        if (maintenance.tenantName != null) {
          int totalCost = getTotalCost(maintenance.tenantName!);
          maintenanceTenantCost.update(
              maintenance.tenantName!, (value) => totalCost,
              ifAbsent: () => totalCost);
        }
        if (maintenance.maintenanceCost != null) {
          String costRange =
              getCostRange(double.parse(maintenance.maintenanceCost!));
          maintenanceCostQuantity.update(costRange, (value) => value + 1,
              ifAbsent: () => 1);
        }
      }

      // maintenanceTypeQuantity.forEach((key, value) {
      //   log('Maintenance Type Quantity: $key, Quantity: $value');
      // });
      // maintenancePropertyQuantity.forEach((key, value) {
      //   log('Maintenance Property Quantity: $key, Quantity: $value');
      // });
      // maintenanceTenantQuantity.forEach((key, value) {
      //   log('Maintenance Tenant Quantity: $key, Quantity: $value');
      // });
      // maintenanceCostQuantity.forEach((key, value) {
      //   log('Maintenance Cost Quantity: $key, Quantity: $value');
      // });
      // propertyStatusQuantity.forEach((key, quantity) {
      //   log('Status: $key, Quantity: $quantity');
      // });
      // propertyPriceQuantity.forEach((key, quantity) {
      //   log('Price: $key, Quantity: $quantity');
      // });
      // propertyStatusQuantity.forEach((key, quantity) {
      //   log('Status: $key, Quantity: $quantity');
      // });
      setState(() {
        isFound = true;
      });
    }

    if (_isPaymentVisible) {
      DateTime parseMonthYear(String monthYear) {
        final parts = monthYear.split(' ');
        final month = parts[0];
        final year = int.parse(parts[1]);

        return DateTime(year, monthMap[month]!);
      }

      String formatMonthYear(DateTime date) {
        final monthNames = monthMap.keys.toList();
        final month = monthNames[date.month - 1];
        final year = date.year.toString();
        return "$month $year";
      }

      final startDate = parseMonthYear(data2!);
      final endDate = parseMonthYear(data3!);

      if ((data1 == "All")) {
        tenantNames = uniquePaymentName.toList();
      } else {
        tenantNames = [data1!];
      }

      for (var tenantName in tenantNames) {
        DateTime currentDate = startDate;
        tenantPaymentMap[tenantName] = [];

        while (!currentDate.isAfter(endDate)) {
          tenantPaymentMap[tenantName]?.add(TenantPayment(
            tenantName: tenantName,
            monthYear: formatMonthYear(currentDate),
            paymentAmount: "RM 0",
          ));
          currentDate = DateTime(currentDate.year, currentDate.month + 1);
        }
      }

      for (var v in paymentList) {
        final paymentDate = DateTime(int.parse(v.year!), monthMap[v.month]!);

        if ((paymentDate.isAfter(startDate) ||
                paymentDate.isAtSameMomentAs(startDate)) &&
            (paymentDate.isBefore(endDate) ||
                paymentDate.isAtSameMomentAs(endDate))) {
          String? tenantName = v.tenantName;
          if (tenantPaymentMap.containsKey(tenantName)) {
            int index = tenantPaymentMap[tenantName]!.indexWhere((entry) =>
                entry.monthYear == "${v.month} ${v.year}" &&
                entry.tenantName == tenantName);
            if (index != -1) {
              tenantPaymentMap[tenantName]![index] = TenantPayment(
                tenantName: v.tenantName,
                monthYear: "${v.month} ${v.year}",
                paymentAmount: "RM ${v.paymentAmount}",
              );
            }
          }
        }
      }
      if (data1 == "All") {
        tenantPaymentsList = [];

        tenantPaymentMap.forEach((key, value) {
          tenantPaymentsList?.add(value);
        });
      } else {
        tenantPaymentsList = [tenantPaymentMap[data1]!];
      }
      setState(() {
        isFound = true;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() {
      isLoading = true;
    });
    return Future.delayed(
      const Duration(seconds: 3),
      () {
        datatypeValue = null;
        loadDataList();
        propertyname.clear();
        tenantname.clear();
        paymentname.clear();
        maintenancename.clear();
        _isPropertyVisible = _isTenantVisible =
            _isPaymentVisible = _isMaintenanceVisible = isFound = false;
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  String formatYear(String date) {
    return date.substring(0, 4);
  }
}
