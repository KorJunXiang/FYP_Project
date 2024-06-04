import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:landlordy/models/maintenance.dart';
import 'package:landlordy/models/propertytenant.dart';
import 'package:http/http.dart' as http;
import 'package:landlordy/models/user.dart';
import 'package:landlordy/shared/myserverconfig.dart';

class EditMaintenancePage extends StatefulWidget {
  final User userdata;
  final Maintenance maintenancedetail;
  final List<PropertyTenant> propertytenant;
  const EditMaintenancePage(
      {super.key,
      required this.userdata,
      required this.maintenancedetail,
      required this.propertytenant});

  @override
  State<EditMaintenancePage> createState() => _EditMaintenancePageState();
}

class _EditMaintenancePageState extends State<EditMaintenancePage> {
  final TextEditingController _propertynameEditingController =
      TextEditingController();
  final TextEditingController _maintenancetypeEditingController =
      TextEditingController();
  final TextEditingController _maintenancedescEditingController =
      TextEditingController();
  final TextEditingController _costEditingController = TextEditingController();
  String tenantname = "";
  String propertyid = "";
  String tenantid = "";
  bool _isPropertyValid = true;
  bool _isMaintenanceValid = true;
  final _formKey = GlobalKey<FormState>();
  bool _isMaintenanceDescValid = true;
  bool _isCostValid = true;
  late double screenWidth, screenHeight;
  List<String> propertyname = [];
  Set<String> uniquePropertyNames = {};
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

  @override
  void initState() {
    super.initState();
    _propertynameEditingController.text =
        widget.maintenancedetail.propertyName.toString();
    _maintenancetypeEditingController.text =
        widget.maintenancedetail.maintenanceType.toString();
    _maintenancedescEditingController.text =
        widget.maintenancedetail.maintenanceDesc.toString();
    _costEditingController.text =
        widget.maintenancedetail.maintenanceCost.toString();
    tenantname = widget.maintenancedetail.tenantName.toString();
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
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: const Text(
          'Edit Maintenance',
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
                              const Text(
                                "Reference ID - ",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${widget.maintenancedetail.referenceId}",
                                style: const TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
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
                                'Property Name',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DropdownButtonFormField2<String>(
                            value: _propertynameEditingController.text,
                            style: TextStyle(
                              fontSize: 17,
                              color:
                                  _isPropertyValid ? Colors.black : Colors.red,
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
                                'Property Name',
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
                                'Maintenance Type',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DropdownButtonFormField2<String>(
                            value: _maintenancetypeEditingController.text,
                            style: TextStyle(
                              fontSize: 17,
                              color: _isMaintenanceValid
                                  ? Colors.black
                                  : Colors.red,
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
                                'Maintenance Type',
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
                            items: maintenancetype.map((String items) {
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
                                return 'Select maintenance type';
                              } else {
                                setState(() {
                                  _isMaintenanceValid = true;
                                });
                                return null;
                              }
                            },
                            onChanged: (newValue) {
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
                          updateDialog();
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
                          'Update',
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
    // log("Property names populated: $propertyname");
  }

  void updateDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Check your input",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
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
                  "Update Maintenance?",
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
                        updateMaintenance();
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

  void updateMaintenance() {
    String propertyname = _propertynameEditingController.text;
    String maintenancetype = _maintenancetypeEditingController.text;
    String maintenancedesc = _maintenancedescEditingController.text;
    String cost = _costEditingController.text;
    http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/maintenance/update_maintenance.php"),
        body: {
          "userid": widget.userdata.userid.toString(),
          "referenceid": widget.maintenancedetail.referenceId.toString(),
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
            content: Text("Update Success",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ));
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Update Failed",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Update Failed",
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
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
                  "Discard Update Maintenance?",
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
