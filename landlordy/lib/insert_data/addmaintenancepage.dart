import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:landlordy/models/propertytenant.dart';
import 'package:landlordy/models/user.dart';
import 'package:landlordy/shared/myserverconfig.dart';

class AddMaintenancePage extends StatefulWidget {
  final User userdata;
  final List<PropertyTenant> propertytenant;
  const AddMaintenancePage(
      {super.key, required this.userdata, required this.propertytenant});

  @override
  State<AddMaintenancePage> createState() => _AddMaintenancePageState();
}

class _AddMaintenancePageState extends State<AddMaintenancePage> {
  final TextEditingController _propertynameEditingController =
      TextEditingController();
  final TextEditingController _maintenancetypeEditingController =
      TextEditingController();
  final TextEditingController _maintenancedescEditingController =
      TextEditingController();
  final TextEditingController _costEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isMaintenanceDescValid = true;
  bool _isCostValid = true;
  late double screenWidth, screenHeight;
  Set<String> uniquePropertyNames = {};
  List<String> propertyname = [];
  List<String> maintenancetype = [
    'Plumbing',
    'Electrical',
    'HVAC (Heating,Ventilation,and Air Conditioning)',
    'Appliance Repair',
    'Carpentry',
    'Flooring',
    'Roofing',
    'Pest Control',
    'Landscaping/Gardening',
    'Cleaning',
    'Structural Repairs'
  ];
  late String tenantname;
  late String propertyid;
  late String tenantid;

  @override
  void initState() {
    super.initState();
    populatePropertyNames();
  }

  @override
  void dispose() {
    _propertynameEditingController.dispose();
    _maintenancetypeEditingController.dispose();
    _maintenancedescEditingController.dispose();
    _costEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade100,
      appBar: AppBar(
        title: const Text(
          'Add Maintenance',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            cancelDialog();
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              'assets/icons/no.png',
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 4, 15, 4),
              child: Column(
                children: [
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/icons/property_name_icon.png',
                                scale: 15,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'Select Property',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DropdownMenu<String>(
                            expandedInsets: EdgeInsets.zero,
                            controller: _propertynameEditingController,
                            trailingIcon: const Icon(
                                Icons.arrow_drop_down_rounded,
                                color: Colors.black,
                                size: 30),
                            selectedTrailingIcon: const Icon(
                                Icons.arrow_drop_up_rounded,
                                color: Colors.black,
                                size: 30),
                            label: const Text(
                              'Property Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            inputDecorationTheme: const InputDecorationTheme(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            dropdownMenuEntries:
                                propertyname.map((String items) {
                              return DropdownMenuEntry<String>(
                                value: items,
                                label: items,
                              );
                            }).toList(),
                            menuHeight: 200,
                            onSelected: (String? newValue) {
                              setState(() {
                                _propertynameEditingController.text = newValue!;
                                for (PropertyTenant tenant
                                    in widget.propertytenant) {
                                  if (tenant.propertyName == newValue) {
                                    tenantname = tenant.currentTenant!;
                                    propertyid = tenant.propertyId!;
                                    tenantid = tenant.tenantId!;
                                    break;
                                  }
                                }
                              });
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/icons/maintenance_icon.png',
                                scale: 15,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'Select Maintenance Type',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DropdownMenu<String>(
                            expandedInsets: EdgeInsets.zero,
                            controller: _maintenancetypeEditingController,
                            trailingIcon: const Icon(
                                Icons.arrow_drop_down_rounded,
                                color: Colors.black,
                                size: 30),
                            selectedTrailingIcon: const Icon(
                                Icons.arrow_drop_up_rounded,
                                color: Colors.black,
                                size: 30),
                            label: const Text(
                              'Maintenance Type',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            inputDecorationTheme: const InputDecorationTheme(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            dropdownMenuEntries:
                                maintenancetype.map((String items) {
                              return DropdownMenuEntry<String>(
                                value: items,
                                label: items,
                              );
                            }).toList(),
                            menuHeight: 200,
                            onSelected: (String? newValue) {
                              setState(() {
                                _maintenancetypeEditingController.text =
                                    newValue!;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/icons/maintenance_desc_icon.png',
                                scale: 15,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'Description',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _maintenancedescEditingController,
                            keyboardType: TextInputType.text,
                            maxLines: 5,
                            style: TextStyle(
                              color: _isMaintenanceDescValid
                                  ? Colors.black
                                  : Colors.red,
                            ),
                            decoration: const InputDecoration(
                              alignLabelWithHint: true,
                              labelText: 'Description',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              errorStyle: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 16),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                setState(() {
                                  _isMaintenanceDescValid = false;
                                });
                                return "Enter maintenance description";
                              } else {
                                setState(() {
                                  _isMaintenanceDescValid = true;
                                });
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/icons/cost_icon.png',
                                scale: 15,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'Maintenance Cost',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _costEditingController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: _isCostValid ? Colors.black : Colors.red,
                            ),
                            decoration: const InputDecoration(
                              prefixText: 'RM ',
                              prefixStyle: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                              labelText: 'Maintenance Cost',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              errorStyle: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 16),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                setState(() {
                                  _isCostValid = false;
                                });
                                return "Enter maintenance cost";
                              } else {
                                setState(() {
                                  _isCostValid = true;
                                });
                                return null;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          insertDialog();
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
                ],
              ),
            ),
          )),
    );
  }

  void populatePropertyNames() {
    propertyname.clear();
    for (PropertyTenant tenant in widget.propertytenant) {
      uniquePropertyNames.add(tenant.propertyName!);
    }
    propertyname = uniquePropertyNames.toList();
    log("Property names populated: $propertyname");
  }

  void insertDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Check your input",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red,
      ));
      return;
    }
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
                const Text(
                  "Insert New Maintenance?",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        insertMaintenance();
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(90, 40),
                        backgroundColor: Colors.green,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(90, 40),
                        backgroundColor: Colors.red,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'No',
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

  void insertMaintenance() {
    String propertyname = _propertynameEditingController.text;
    String maintenancetype = _maintenancetypeEditingController.text;
    String maintenancedesc = _maintenancedescEditingController.text;
    String cost = _costEditingController.text;
    http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/maintenance/insert_maintenance.php"),
        body: {
          "userid": widget.userdata.userid.toString(),
          "propertyid": propertyid,
          "propertyname": propertyname,
          "tenantid": tenantid,
          "tenantname": tenantname,
          "maintenancetype": maintenancetype,
          "maintenancedesc": maintenancedesc,
          "cost": cost,
        }).then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Insert Success",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.green,
          ));
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Insert Failed",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Insert Failed",
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.red,
        ));
      }
    });
  }

  void cancelDialog() {
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
                const Text(
                  "Discard Adding Maintenance?",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(90, 40),
                        backgroundColor: Colors.green,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(90, 40),
                        backgroundColor: Colors.red,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'No',
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
}
