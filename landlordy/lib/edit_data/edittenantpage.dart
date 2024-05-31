import 'dart:convert';
import 'dart:developer';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:landlordy/models/tenant.dart';
import 'package:landlordy/models/user.dart';
import 'package:landlordy/shared/myserverconfig.dart';

class EditTenantPage extends StatefulWidget {
  final User userdata;
  final Tenant tenantdetail;
  const EditTenantPage(
      {super.key, required this.userdata, required this.tenantdetail});

  @override
  State<EditTenantPage> createState() => _EditTenantPageState();
}

class _EditTenantPageState extends State<EditTenantPage> {
  final TextEditingController _rentalpriceEditingController =
      TextEditingController();
  final TextEditingController _tenantnameEditingController =
      TextEditingController();
  final TextEditingController _latestpropertyEditingController =
      TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _genderEditingController =
      TextEditingController();
  final TextEditingController _ageEditingController = TextEditingController();
  final TextEditingController _categoryEditingController =
      TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  late double screenWidth, screenHeight;
  final _formKey = GlobalKey<FormState>();
  bool _isGenderValid = true;
  bool _isCategoryValid = true;
  bool _isRentalPriceValid = true;
  bool _isTenantNameValid = true;
  bool _isLatestPropertyValid = true;
  bool _isEmailValid = true;
  bool _isAgeValid = true;
  bool _isPhoneValid = true;
  var gender = ['Male', 'Female'];
  var category = ['Single', 'Family', 'Commercial'];

  @override
  void initState() {
    super.initState();
    _latestpropertyEditingController.text =
        widget.tenantdetail.latestProperty.toString();
    _rentalpriceEditingController.text =
        widget.tenantdetail.rentalPrice.toString();
    _tenantnameEditingController.text =
        widget.tenantdetail.tenantName.toString();
    _emailEditingController.text = widget.tenantdetail.tenantEmail.toString();
    _genderEditingController.text = widget.tenantdetail.tenantGender.toString();
    _ageEditingController.text = widget.tenantdetail.tenantAge.toString();
    _categoryEditingController.text =
        widget.tenantdetail.tenantCategory.toString();
    _phoneEditingController.text = widget.tenantdetail.tenantPhone.toString();
  }

  @override
  void dispose() {
    _latestpropertyEditingController.dispose();
    _rentalpriceEditingController.dispose();
    _tenantnameEditingController.dispose();
    _emailEditingController.dispose();
    _ageEditingController.dispose();
    _genderEditingController.dispose();
    _categoryEditingController.dispose();
    _phoneEditingController.dispose();
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
          'Edit Tenant',
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  const Text(
                    "Tenant Detail",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _tenantnameEditingController,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: _isTenantNameValid
                                  ? Colors.black
                                  : Colors.red,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Tenant Name',
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              icon: Image.asset(
                                'assets/icons/tenant_name_icon.png',
                                scale: 22,
                                alignment: Alignment.centerLeft,
                              ),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              errorStyle: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 16),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                setState(() {
                                  _isTenantNameValid = false;
                                });
                                return "Enter tenant name";
                              } else {
                                setState(() {
                                  _isTenantNameValid = true;
                                });
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _emailEditingController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                              color: _isEmailValid ? Colors.black : Colors.red,
                            ),
                            decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                icon: Image.asset(
                                  'assets/icons/email_icon.png',
                                  scale: 22,
                                  alignment: Alignment.centerLeft,
                                ),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                errorStyle: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16)),
                            validator: (val) {
                              if (val!.isEmpty ||
                                  !val.contains("@") ||
                                  !val.contains(".")) {
                                setState(() {
                                  _isEmailValid = false;
                                });
                                return "Enter a valid tenant email";
                              } else {
                                setState(() {
                                  _isEmailValid = true;
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
                                'assets/icons/gender_icon.png',
                                scale: 22,
                                alignment: Alignment.centerLeft,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 5,
                                child: DropdownButtonFormField2<String>(
                                  value: _genderEditingController.text,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: _isGenderValid
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
                                    maxHeight: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  decoration: InputDecoration(
                                    label: const Text(
                                      'Gender',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                  items: gender.map((String items) {
                                    return DropdownMenuItem<String>(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  validator: (value) {
                                    if (value == null) {
                                      setState(() {
                                        _isGenderValid = false;
                                      });
                                      return 'Select gender';
                                    } else {
                                      setState(() {
                                        _isGenderValid = true;
                                      });
                                      return null;
                                    }
                                  },
                                  onChanged: (newValue) {
                                    setState(() {
                                      _genderEditingController.text = newValue!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Image.asset(
                                'assets/icons/age_icon.png',
                                scale: 22,
                                alignment: Alignment.centerLeft,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 4,
                                child: TextFormField(
                                  controller: _ageEditingController,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    color:
                                        _isAgeValid ? Colors.black : Colors.red,
                                  ),
                                  decoration: const InputDecoration(
                                    labelText: 'Age',
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    errorStyle: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 16),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      setState(() {
                                        _isAgeValid = false;
                                      });
                                      return "Enter age";
                                    } else {
                                      setState(() {
                                        _isAgeValid = true;
                                      });
                                      return null;
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/icons/category_icon.png',
                                scale: 22,
                                alignment: Alignment.centerLeft,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DropdownButtonFormField2<String>(
                                  value: _categoryEditingController.text,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: _isCategoryValid
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
                                    maxHeight: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  decoration: InputDecoration(
                                    label: const Text(
                                      'Category',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                  items: category.map((String items) {
                                    return DropdownMenuItem<String>(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  validator: (value) {
                                    if (value == null) {
                                      setState(() {
                                        _isCategoryValid = false;
                                      });
                                      return 'Select category';
                                    } else {
                                      setState(() {
                                        _isCategoryValid = true;
                                      });
                                      return null;
                                    }
                                  },
                                  onChanged: (newValue) {
                                    setState(() {
                                      _categoryEditingController.text =
                                          newValue!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _phoneEditingController,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(
                              color: _isPhoneValid ? Colors.black : Colors.red,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              icon: Image.asset(
                                'assets/icons/phone_icon.png',
                                scale: 22,
                                alignment: Alignment.centerLeft,
                              ),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              errorStyle: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 16),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                setState(() {
                                  _isPhoneValid = false;
                                });
                                return "Enter tenant phone number";
                              } else {
                                setState(() {
                                  _isPhoneValid = true;
                                });
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            enabled: false,
                            controller: _latestpropertyEditingController,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: _isLatestPropertyValid
                                  ? Colors.black
                                  : Colors.red,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Latest Property',
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              icon: Image.asset(
                                'assets/icons/property_name_icon.png',
                                scale: 22,
                                alignment: Alignment.centerLeft,
                              ),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              errorStyle: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 16),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                setState(() {
                                  _isLatestPropertyValid = false;
                                });
                                return "Enter Latest Property";
                              } else {
                                setState(() {
                                  _isLatestPropertyValid = true;
                                });
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _rentalpriceEditingController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: _isRentalPriceValid
                                  ? Colors.black
                                  : Colors.red,
                            ),
                            decoration: InputDecoration(
                              prefixText: 'RM ',
                              prefixStyle: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                              labelText: 'Rental Price',
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              icon: Image.asset(
                                'assets/icons/price_icon.png',
                                scale: 22,
                                alignment: Alignment.centerLeft,
                              ),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              errorStyle: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 16),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                setState(() {
                                  _isRentalPriceValid = false;
                                });
                                return "Enter property rental price";
                              } else {
                                setState(() {
                                  _isRentalPriceValid = true;
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
            )),
      ),
    );
  }

  void insertDialog() {
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
                  "Update Tenant?",
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
                        updateTenant();
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

  void updateTenant() {
    String rentalprice = _rentalpriceEditingController.text;
    String tenantname = _tenantnameEditingController.text;
    String email = _emailEditingController.text;
    String gender = _genderEditingController.text;
    String age = _ageEditingController.text;
    String category = _categoryEditingController.text;
    String phone = _phoneEditingController.text;
    http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/tenant/update_tenant.php"),
        body: {
          "tenantid": widget.tenantdetail.tenantId.toString(),
          "rentalprice": rentalprice,
          "tenantname": tenantname,
          "email": email,
          "gender": gender,
          "age": age,
          "category": category,
          "phone": phone,
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
                  "Discard Update Tenant?",
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
