// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:landlordy/models/property.dart';
import 'package:landlordy/models/tenant.dart';
import 'package:landlordy/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:landlordy/shared/loadingindicatorwidget.dart';
import 'package:landlordy/shared/myserverconfig.dart';
import 'package:path_provider/path_provider.dart';

class EditPropertyPage extends StatefulWidget {
  final User userdata;
  final Property propertydetail;
  final Tenant tenantdetail;
  const EditPropertyPage(
      {super.key,
      required this.userdata,
      required this.propertydetail,
      required this.tenantdetail});

  @override
  State<EditPropertyPage> createState() => _EditPropertyPageState();
}

class _EditPropertyPageState extends State<EditPropertyPage> {
  final TextEditingController _propertynameEditingController =
      TextEditingController();
  final TextEditingController _addressEditingController =
      TextEditingController();
  final TextEditingController _stateEditingController = TextEditingController();
  final TextEditingController _propertytypeEditingController =
      TextEditingController();
  final TextEditingController _rentalpriceEditingController =
      TextEditingController();
  final TextEditingController _tenantnameEditingController =
      TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _genderEditingController =
      TextEditingController();
  final TextEditingController _ageEditingController = TextEditingController();
  final TextEditingController _categoryEditingController =
      TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  late double screenWidth, screenHeight;
  File? _image;
  final List<File> _imageList = [];
  final _formKey = GlobalKey<FormState>();
  bool _isGenderValid = true;
  bool _isCategoryValid = true;
  bool _isTypeValid = true;
  bool _isPropertyNameValid = true;
  bool _isAddressValid = true;
  bool _isStateValid = true;
  bool _isRentalPriceValid = true;
  bool _isTenantNameValid = true;
  bool _isEmailValid = true;
  bool _isAgeValid = true;
  bool _isPhoneValid = true;
  bool _gotTenant = false;
  String selectedgender = "";
  String selectedcategory = "";
  var propertytype = ['Landed', 'Highrise', 'Room'];
  var gender = ['Male', 'Female'];
  var category = ['Single', 'Family', 'Commercial'];
  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  @override
  void initState() {
    super.initState();
    loadImageList();
    loadText();
  }

  @override
  void dispose() {
    _propertynameEditingController.dispose();
    _addressEditingController.dispose();
    _stateEditingController.dispose();
    _propertytypeEditingController.dispose();
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
          'Edit Property',
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
      body: _imageList.isEmpty
          ? const Center(
              child: LoadingIndicatorWidget(type: 1),
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.3,
                      child: PageView.builder(
                        itemCount: _imageList.length + 1,
                        controller: PageController(viewportFraction: 0.8),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == _imageList.length) {
                            return Padding(
                                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: const BorderSide(
                                          color: Colors.black, width: 2)),
                                  elevation: 5,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(15),
                                    splashFactory: InkRipple.splashFactory,
                                    onTap: () {
                                      _selectImageDialog(index);
                                    },
                                    child: Container(
                                        decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/add-photo.png"),
                                        scale: 2.5,
                                      ),
                                    )),
                                  ),
                                ));
                          } else {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: const BorderSide(
                                        color: Colors.black, width: 2)),
                                elevation: 5,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(15),
                                  splashFactory: InkRipple.splashFactory,
                                  onTap: () {
                                    _selectImageDialog(index);
                                  },
                                  child: Ink.image(
                                    image: FileImage(_imageList[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 4, 15, 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "1. Property Detail",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller:
                                          _propertynameEditingController,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(
                                        color: _isPropertyNameValid
                                            ? Colors.black
                                            : Colors.red,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Property Name',
                                        labelStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        icon: Image.asset(
                                          'assets/icons/property_name_icon.png',
                                          scale: 22,
                                          alignment: Alignment.centerLeft,
                                        ),
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        errorStyle: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                            fontSize: 16),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          setState(() {
                                            _isPropertyNameValid = false;
                                          });
                                          return "Enter property name";
                                        } else {
                                          setState(() {
                                            _isPropertyNameValid = true;
                                          });
                                          return null;
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: _addressEditingController,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(
                                        color: _isAddressValid
                                            ? Colors.black
                                            : Colors.red,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Address',
                                        labelStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        icon: Image.asset(
                                          'assets/icons/address_icon.png',
                                          scale: 22,
                                          alignment: Alignment.centerLeft,
                                        ),
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        errorStyle: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                            fontSize: 16),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          setState(() {
                                            _isAddressValid = false;
                                          });
                                          return "Enter property address";
                                        } else {
                                          setState(() {
                                            _isAddressValid = true;
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
                                        SizedBox(
                                          width: screenWidth * 0.4,
                                          child: TextFormField(
                                            controller: _stateEditingController,
                                            keyboardType: TextInputType.text,
                                            style: TextStyle(
                                              color: _isStateValid
                                                  ? Colors.black
                                                  : Colors.red,
                                            ),
                                            decoration: InputDecoration(
                                              labelText: 'State',
                                              labelStyle: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              icon: Image.asset(
                                                'assets/icons/state_icon.png',
                                                scale: 22,
                                                alignment: Alignment.centerLeft,
                                              ),
                                              border: const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              errorStyle: const TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 16),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                setState(() {
                                                  _isStateValid = false;
                                                });
                                                return "Enter state";
                                              } else {
                                                setState(() {
                                                  _isStateValid = true;
                                                });
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Image.asset(
                                          'assets/icons/property_type_icon.png',
                                          scale: 22,
                                          alignment: Alignment.centerLeft,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child:
                                              DropdownButtonFormField2<String>(
                                            value:
                                                _propertytypeEditingController
                                                    .text,
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: _isTypeValid
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
                                                'Type',
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
                                            items: propertytype
                                                .map((String items) {
                                              return DropdownMenuItem<String>(
                                                value: items,
                                                child: Text(items),
                                              );
                                            }).toList(),
                                            validator: (value) {
                                              if (value == null) {
                                                setState(() {
                                                  _isTypeValid = false;
                                                });
                                                return 'Select type';
                                              } else {
                                                setState(() {
                                                  _isTypeValid = true;
                                                });
                                                return null;
                                              }
                                            },
                                            onChanged: (newValue) {
                                              setState(() {
                                                _propertytypeEditingController
                                                    .text = newValue!;
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
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "2. Tenant Detail",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Switch(
                                  value: _gotTenant,
                                  thumbIcon: thumbIcon,
                                  onChanged: (value) {
                                    setState(() {
                                      _gotTenant = value;
                                    });
                                  },
                                )
                              ],
                            ),
                            Visibility(
                              visible: _gotTenant,
                              child: Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller:
                                            _tenantnameEditingController,
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
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
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
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        style: TextStyle(
                                          color: _isEmailValid
                                              ? Colors.black
                                              : Colors.red,
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
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
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
                                              child: DropdownButtonFormField2<
                                                  String>(
                                                value: selectedgender,
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  color: _isGenderValid
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
                                                        Icons
                                                            .arrow_drop_up_rounded,
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
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                decoration: InputDecoration(
                                                  label: const Text(
                                                    'Gender',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  errorStyle: const TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 16),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                items:
                                                    gender.map((String items) {
                                                  return DropdownMenuItem<
                                                      String>(
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
                                                    _genderEditingController
                                                        .text = newValue!;
                                                  });
                                                },
                                              )),
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
                                              keyboardType:
                                                  TextInputType.number,
                                              style: TextStyle(
                                                color: _isAgeValid
                                                    ? Colors.black
                                                    : Colors.red,
                                              ),
                                              decoration: const InputDecoration(
                                                labelText: 'Age',
                                                labelStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
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
                                            child: DropdownButtonFormField2<
                                                String>(
                                              value: selectedcategory,
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: _isCategoryValid
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
                                                      Icons
                                                          .arrow_drop_up_rounded,
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
                                                  'Category',
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
                                              items:
                                                  category.map((String items) {
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
                                                  _categoryEditingController
                                                      .text = newValue!;
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
                                          color: _isPhoneValid
                                              ? Colors.black
                                              : Colors.red,
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
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
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
                                    ],
                                  ),
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
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  void _selectImageDialog(int num) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: const Text(
              "Select from",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              width: screenWidth * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(screenWidth / 4, screenHeight / 7)),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_library_rounded),
                        SizedBox(height: 10),
                        Text('Gallery'),
                      ],
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _selectfromGallery(num);
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(screenWidth / 4, screenHeight / 7)),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera),
                        SizedBox(height: 10),
                        Text('Camera'),
                      ],
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _selectFromCamera(num);
                    },
                  ),
                ],
              ),
            ));
      },
    );
  }

  Future<void> _selectfromGallery(int num) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1200,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage(num);
    } else {
      print('No image selected.');
    }
  }

  Future<void> _selectFromCamera(int num) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1200,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage(num);
    } else {
      print('No image selected.');
    }
  }

  Future<void> cropImage(int num) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        // CropAspectRatioPreset.ratio7x5,
        // CropAspectRatioPreset.ratio3x2,
        // CropAspectRatioPreset.ratio5x4,
        // CropAspectRatioPreset.ratio5x3,
        // CropAspectRatioPreset.ratio4x3,
        // CropAspectRatioPreset.ratio16x9
        //// CropAspectRatioPreset.original,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: Colors.blue,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      if (_imageList.length > num) {
        _imageList[num] = _image!;
      } else {
        _imageList.add(_image!);
      }
      setState(() {});
    }
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
                  "Update Property?",
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
                        updateProperty();
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

  Future<void> loadImageList() async {
    int numofimages = int.parse(widget.propertydetail.imageNum ?? '0');
    for (int i = 1; i <= numofimages; i++) {
      String imageUrl =
          "${MyServerConfig.server}/landlordy/assets/properties/${widget.propertydetail.propertyId}_$i.png";
      File imageFile = await urlToFile(imageUrl);
      _imageList.add(imageFile);
    }
    setState(() {});
  }

  Future<File> urlToFile(String imageUrl) async {
    var rng = Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = File('$tempPath${rng.nextInt(100)}.png');
    http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  Future<void> loadText() async {
    _propertynameEditingController.text =
        widget.propertydetail.propertyName.toString();
    _addressEditingController.text =
        widget.propertydetail.propertyAddress.toString();
    _stateEditingController.text =
        widget.propertydetail.propertyState.toString();
    _propertytypeEditingController.text =
        widget.propertydetail.propertyType.toString();
    _rentalpriceEditingController.text =
        widget.propertydetail.rentalPrice.toString();
    if (widget.tenantdetail.tenantId != null) {
      _tenantnameEditingController.text =
          widget.tenantdetail.tenantName.toString();
      _emailEditingController.text = widget.tenantdetail.tenantEmail.toString();
      _genderEditingController.text =
          widget.tenantdetail.tenantGender.toString();
      _ageEditingController.text = widget.tenantdetail.tenantAge.toString();
      _categoryEditingController.text =
          widget.tenantdetail.tenantCategory.toString();
      _phoneEditingController.text = widget.tenantdetail.tenantPhone.toString();
      _gotTenant = true;
    }
    if (_gotTenant) {
      selectedgender = widget.tenantdetail.tenantGender.toString();
      selectedcategory = widget.tenantdetail.tenantCategory.toString();
    } else {
      selectedgender = "Male";
      selectedcategory = "Single";
    }
    setState(() {});
  }

  void updateProperty() {
    String propertyname = _propertynameEditingController.text;
    String address = _addressEditingController.text;
    String state = _stateEditingController.text;
    String type = _propertytypeEditingController.text;
    String rentalprice = _rentalpriceEditingController.text;
    String rentalstatus;
    String status;
    String tenantname;
    String email;
    String gender;
    String age;
    String category;
    String phone;
    if (_gotTenant) {
      status = "Not Available";
      rentalstatus = "Rented";
      tenantname = _tenantnameEditingController.text;
      email = _emailEditingController.text;
      gender = _genderEditingController.text;
      age = _ageEditingController.text;
      category = _categoryEditingController.text;
      phone = _phoneEditingController.text;
    } else {
      status = "Available";
      rentalstatus = "Not Rented";
      tenantname = "N/A";
      email = "N/A";
      gender = "N/A";
      age = "N/A";
      category = "N/A";
      phone = "N/A";
    }
    List<String> base64Images = [];
    for (int x = 0; x < _imageList.length; x++) {
      base64Images.add(base64Encode(_imageList[x].readAsBytesSync()));
    }
    String images = json.encode(base64Images);
    http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/property/update_property.php"),
        body: {
          "userid": widget.userdata.userid.toString(),
          "propertyid": widget.propertydetail.propertyId.toString(),
          "tenantid": widget.tenantdetail.tenantId.toString(),
          "propertyname": propertyname,
          "address": address,
          "state": state,
          "type": type,
          "rentalprice": rentalprice,
          "status": status,
          "oldnumofimages": widget.propertydetail.imageNum.toString(),
          "newnumofimages": _imageList.length.toString(),
          "tenantname": tenantname,
          "email": email,
          "gender": gender,
          "age": age,
          "category": category,
          "phone": phone,
          "rentalstatus": rentalstatus,
          "image": images,
        }).then((response) {
      print(response.body);
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
                  "Discard Update Property?",
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
