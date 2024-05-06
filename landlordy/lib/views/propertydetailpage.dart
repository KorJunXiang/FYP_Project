import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:landlordy/edit_data/editpropertypage.dart';
import 'package:landlordy/models/property.dart';
import 'package:landlordy/models/tenant.dart';
import 'package:landlordy/models/user.dart';
import 'package:landlordy/shared/myserverconfig.dart';
import 'package:http/http.dart' as http;

class PropertyDetailPage extends StatefulWidget {
  final User userdata;
  final Property propertydetail;
  final Tenant tenantdetail;
  const PropertyDetailPage(
      {super.key,
      required this.userdata,
      required this.propertydetail,
      required this.tenantdetail});

  @override
  State<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {
  late double screenWidth, screenHeight;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    int numofimages = 0;
    String? imageNum = widget.propertydetail.imageNum;
    if (imageNum != null) {
      numofimages = int.parse(imageNum);
    } else {
      numofimages = 0;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              'assets/icons/back_icon.png',
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPropertyPage(
                    userdata: widget.userdata,
                    propertydetail: widget.propertydetail,
                    tenantdetail: widget.tenantdetail,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                'assets/icons/edit_icon.png',
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              deleteDialog();
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                'assets/icons/delete_icon.png',
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.3,
            child: PageView.builder(
              itemCount: numofimages,
              controller: PageController(viewportFraction: 0.9),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(color: Colors.black, width: 2)),
                    elevation: 5,
                    child: Image.network(
                      "${MyServerConfig.server}/landlordy/assets/properties/${widget.propertydetail.propertyId}_${index + 1}.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(10),
              color: Colors.lightBlue.shade100,
              elevation: 5,
              child: Container(
                padding: const EdgeInsets.fromLTRB(5, 4, 5, 4),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(3),
                          2: FlexColumnWidth(7),
                        },
                        children: [
                          TableRow(children: [
                            TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(5, 0, 15, 0),
                                  child: const Image(
                                    image: AssetImage(
                                      'assets/icons/property_name_icon.png',
                                    ),
                                    fit: BoxFit.scaleDown,
                                  ),
                                )),
                            const TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Text(
                                  "Property Name",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w900),
                                )),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Text(
                                widget.propertydetail.propertyName.toString(),
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w500),
                              ),
                            )
                          ]),
                          const TableRow(children: [
                            TableCell(child: SizedBox(height: 20)),
                            TableCell(child: SizedBox(height: 20)),
                            TableCell(child: SizedBox(height: 20))
                          ]),
                          TableRow(children: [
                            TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(5, 0, 15, 0),
                                  child: const Image(
                                    image: AssetImage(
                                      'assets/icons/address_icon.png',
                                    ),
                                    fit: BoxFit.scaleDown,
                                  ),
                                )),
                            const TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Text(
                                  "Address",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w900),
                                )),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Text(
                                widget.propertydetail.propertyAddress
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w500),
                              ),
                            )
                          ]),
                          const TableRow(children: [
                            TableCell(child: SizedBox(height: 20)),
                            TableCell(child: SizedBox(height: 20)),
                            TableCell(child: SizedBox(height: 20))
                          ]),
                          TableRow(children: [
                            TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(5, 0, 15, 0),
                                  child: const Image(
                                    image: AssetImage(
                                      'assets/icons/state_icon.png',
                                    ),
                                    fit: BoxFit.scaleDown,
                                  ),
                                )),
                            const TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Text(
                                  "State",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w900),
                                )),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Text(
                                widget.propertydetail.propertyName.toString(),
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w500),
                              ),
                            )
                          ]),
                          const TableRow(children: [
                            TableCell(child: SizedBox(height: 20)),
                            TableCell(child: SizedBox(height: 20)),
                            TableCell(child: SizedBox(height: 20))
                          ]),
                          TableRow(children: [
                            TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(5, 0, 15, 0),
                                  child: const Image(
                                    image: AssetImage(
                                      'assets/icons/property_type_icon.png',
                                    ),
                                    fit: BoxFit.scaleDown,
                                  ),
                                )),
                            const TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Text(
                                  "Type",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w900),
                                )),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Text(
                                widget.propertydetail.propertyType.toString(),
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w500),
                              ),
                            )
                          ]),
                          const TableRow(children: [
                            TableCell(child: SizedBox(height: 20)),
                            TableCell(child: SizedBox(height: 20)),
                            TableCell(child: SizedBox(height: 20))
                          ]),
                          TableRow(children: [
                            TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(5, 0, 15, 0),
                                  child: const Image(
                                    image: AssetImage(
                                      'assets/icons/price_icon.png',
                                    ),
                                    fit: BoxFit.scaleDown,
                                  ),
                                )),
                            const TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Text(
                                  "Rental Price",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w900),
                                )),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Text(
                                "RM ${widget.propertydetail.rentalPrice}",
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w500),
                              ),
                            )
                          ]),
                          const TableRow(children: [
                            TableCell(child: SizedBox(height: 20)),
                            TableCell(child: SizedBox(height: 20)),
                            TableCell(child: SizedBox(height: 20))
                          ]),
                          TableRow(children: [
                            TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(5, 0, 15, 0),
                                  child: const Image(
                                    image: AssetImage(
                                      'assets/icons/property_status_icon.png',
                                    ),
                                    fit: BoxFit.scaleDown,
                                  ),
                                )),
                            const TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Text(
                                  "Property Status",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w900),
                                )),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Text(
                                widget.propertydetail.propertyStatus.toString(),
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w500),
                              ),
                            )
                          ]),
                        ],
                      ),
                      Visibility(
                        visible: showTenantDetails(),
                        child: Table(
                          columnWidths: const {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(3),
                            2: FlexColumnWidth(7),
                          },
                          children: [
                            const TableRow(children: [
                              TableCell(child: SizedBox(height: 20)),
                              TableCell(child: SizedBox(height: 20)),
                              TableCell(child: SizedBox(height: 20))
                            ]),
                            TableRow(children: [
                              TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(5, 0, 15, 0),
                                    child: const Image(
                                      image: AssetImage(
                                        'assets/icons/tenant_name_icon.png',
                                      ),
                                      fit: BoxFit.scaleDown,
                                    ),
                                  )),
                              const TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Text(
                                    "Tenant Name",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w900),
                                  )),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Text(
                                  widget.tenantdetail.tenantName.toString(),
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ]),
                            const TableRow(children: [
                              TableCell(child: SizedBox(height: 20)),
                              TableCell(child: SizedBox(height: 20)),
                              TableCell(child: SizedBox(height: 20))
                            ]),
                            TableRow(children: [
                              TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(5, 0, 15, 0),
                                    child: const Image(
                                      image: AssetImage(
                                        'assets/icons/email_icon.png',
                                      ),
                                      fit: BoxFit.scaleDown,
                                    ),
                                  )),
                              const TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Text(
                                    "Email",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w900),
                                  )),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Text(
                                  widget.tenantdetail.tenantEmail.toString(),
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ]),
                            const TableRow(children: [
                              TableCell(child: SizedBox(height: 20)),
                              TableCell(child: SizedBox(height: 20)),
                              TableCell(child: SizedBox(height: 20))
                            ]),
                            TableRow(children: [
                              TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(5, 0, 15, 0),
                                    child: const Image(
                                      image: AssetImage(
                                        'assets/icons/gender_icon.png',
                                      ),
                                      fit: BoxFit.scaleDown,
                                    ),
                                  )),
                              const TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Text(
                                    "Gender",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w900),
                                  )),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Text(
                                  widget.tenantdetail.tenantGender.toString(),
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ]),
                            const TableRow(children: [
                              TableCell(child: SizedBox(height: 20)),
                              TableCell(child: SizedBox(height: 20)),
                              TableCell(child: SizedBox(height: 20))
                            ]),
                            TableRow(children: [
                              TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(5, 0, 15, 0),
                                    child: const Image(
                                      image: AssetImage(
                                        'assets/icons/age_icon.png',
                                      ),
                                      fit: BoxFit.scaleDown,
                                    ),
                                  )),
                              const TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Text(
                                    "Age",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w900),
                                  )),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Text(
                                  widget.tenantdetail.tenantAge.toString(),
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ]),
                            const TableRow(children: [
                              TableCell(child: SizedBox(height: 20)),
                              TableCell(child: SizedBox(height: 20)),
                              TableCell(child: SizedBox(height: 20))
                            ]),
                            TableRow(children: [
                              TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(5, 0, 15, 0),
                                    child: const Image(
                                      image: AssetImage(
                                        'assets/icons/category_icon.png',
                                      ),
                                      fit: BoxFit.scaleDown,
                                    ),
                                  )),
                              const TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Text(
                                    "Category",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w900),
                                  )),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Text(
                                  widget.tenantdetail.tenantCategory.toString(),
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ]),
                            const TableRow(children: [
                              TableCell(child: SizedBox(height: 20)),
                              TableCell(child: SizedBox(height: 20)),
                              TableCell(child: SizedBox(height: 20))
                            ]),
                            TableRow(children: [
                              TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(5, 0, 15, 0),
                                    child: const Image(
                                      image: AssetImage(
                                        'assets/icons/phone_icon.png',
                                      ),
                                      fit: BoxFit.scaleDown,
                                    ),
                                  )),
                              const TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Text(
                                    "Phone Number",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w900),
                                  )),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Text(
                                  formatPhoneNumber(widget
                                      .tenantdetail.tenantPhone
                                      .toString()),
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void deleteDialog() {
    showDialog(
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
                  "Delete This Property?",
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
                        deleteProperty();
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

  bool showTenantDetails() {
    return widget.tenantdetail.tenantId != null;
  }

  void deleteProperty() {
    http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/property/delete_property.php"),
        body: {
          "userid": widget.userdata.userid.toString(),
          "propertyid": widget.propertydetail.propertyId,
          "tenantid": widget.tenantdetail.tenantId,
          "imagenum": widget.propertydetail.imageNum,
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Delete Success",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.green,
          ));
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Delete Failed",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Delete Failed",
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.red,
        ));
      }
    });
  }

  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length >= 4) {
      return '${phoneNumber.substring(0, 3)}-${phoneNumber.substring(3)}';
    } else {
      return phoneNumber;
    }
  }
}
