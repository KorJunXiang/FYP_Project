// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:landlordy/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:landlordy/shared/myserverconfig.dart';

class AddPropertyPage extends StatefulWidget {
  final User userdata;
  const AddPropertyPage({super.key, required this.userdata});

  @override
  State<AddPropertyPage> createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
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
  bool _isPropertyNameValid = true;
  bool _isAddressValid = true;
  bool _isStateValid = true;
  bool _isRentalPriceValid = true;
  bool _isTenantNameValid = true;
  bool _isEmailValid = true;
  bool _isAgeValid = true;
  bool _isPhoneValid = true;
  bool _gotTenant = false;
  List<String> propertytype = ['Landed', 'Highrise', 'Room'];
  List<String> gender = ['Male', 'Female'];
  List<String> category = ['Single', 'Family', 'Commercial'];
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
      backgroundColor: Colors.lightBlue.shade100,
      appBar: AppBar(
        title: const Text(
          'Add Property',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                                  image:
                                      AssetImage("assets/images/add-photo.png"),
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
                                controller: _propertynameEditingController,
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
                                  Expanded(
                                    child: DropdownMenu<String>(
                                      expandedInsets: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
                                      controller:
                                          _propertytypeEditingController,
                                      trailingIcon: const Icon(
                                          Icons.arrow_drop_down_rounded,
                                          color: Colors.black,
                                          size: 30),
                                      selectedTrailingIcon: const Icon(
                                          Icons.arrow_drop_up_rounded,
                                          color: Colors.black,
                                          size: 30),
                                      label: const Text(
                                        'Type',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      inputDecorationTheme:
                                          const InputDecorationTheme(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                      ),
                                      dropdownMenuEntries:
                                          propertytype.map((String items) {
                                        return DropdownMenuEntry<String>(
                                          value: items,
                                          label: items,
                                        );
                                      }).toList(),
                                      onSelected: (String? newValue) {
                                        setState(() {
                                          _propertytypeEditingController.text =
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
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                                  keyboardType: TextInputType.emailAddress,
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
                                    Expanded(
                                      flex: 5,
                                      child: DropdownMenu<String>(
                                        expandedInsets:
                                            const EdgeInsets.fromLTRB(
                                                16, 0, 10, 0),
                                        controller: _genderEditingController,
                                        trailingIcon: const Icon(
                                            Icons.arrow_drop_down_rounded,
                                            color: Colors.black,
                                            size: 30),
                                        selectedTrailingIcon: const Icon(
                                            Icons.arrow_drop_up_rounded,
                                            color: Colors.black,
                                            size: 30),
                                        label: const Text(
                                          'Gender',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        inputDecorationTheme:
                                            const InputDecorationTheme(
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        dropdownMenuEntries:
                                            gender.map((String items) {
                                          return DropdownMenuEntry<String>(
                                            value: items,
                                            label: items,
                                          );
                                        }).toList(),
                                        onSelected: (String? newValue) {
                                          setState(() {
                                            _genderEditingController.text =
                                                newValue!;
                                          });
                                        },
                                      ),
                                    ),
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
                                    Expanded(
                                      flex: 5,
                                      child: DropdownMenu<String>(
                                        expandedInsets:
                                            const EdgeInsets.fromLTRB(
                                                16, 0, 0, 0),
                                        controller: _categoryEditingController,
                                        trailingIcon: const Icon(
                                            Icons.arrow_drop_down_rounded,
                                            color: Colors.black,
                                            size: 30),
                                        selectedTrailingIcon: const Icon(
                                            Icons.arrow_drop_up_rounded,
                                            color: Colors.black,
                                            size: 30),
                                        label: const Text(
                                          'Category',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        inputDecorationTheme:
                                            const InputDecorationTheme(
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        dropdownMenuEntries:
                                            category.map((String items) {
                                          return DropdownMenuEntry<String>(
                                            value: items,
                                            label: items,
                                          );
                                        }).toList(),
                                        onSelected: (String? newValue) {
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
      ));
      return;
    }
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please take picture",
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
                  "Insert New Property?",
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
                        insertProperty();
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

  void insertProperty() {
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
            "${MyServerConfig.server}/landlordy/php/property/insert_property.php"),
        body: {
          "userid": widget.userdata.userid.toString(),
          "propertyname": propertyname,
          "address": address,
          "state": state,
          "type": type,
          "rentalprice": rentalprice,
          "status": status,
          "numofimages": _imageList.length.toString(),
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
                  "Discard Adding Property?",
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
