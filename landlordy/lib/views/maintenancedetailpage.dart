import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:landlordy/edit_data/editmaintenancepage.dart';
import 'package:landlordy/models/maintenance.dart';
import 'package:landlordy/models/propertytenant.dart';
import 'package:landlordy/models/user.dart';
import 'package:landlordy/shared/myserverconfig.dart';
import 'package:http/http.dart' as http;

class MaintenanceDetailPage extends StatefulWidget {
  final User userdata;
  final Maintenance maintenancedetail;
  final List<PropertyTenant> propertytenant;
  const MaintenanceDetailPage(
      {super.key,
      required this.userdata,
      required this.maintenancedetail,
      required this.propertytenant});

  @override
  State<MaintenanceDetailPage> createState() => _MaintenanceDetailPageState();
}

class _MaintenanceDetailPageState extends State<MaintenanceDetailPage> {
  late double screenWidth, screenHeight;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
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
                  builder: (context) => EditMaintenancePage(
                    userdata: widget.userdata,
                    maintenancedetail: widget.maintenancedetail,
                    propertytenant: widget.propertytenant,
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
          Card(
            margin: const EdgeInsets.all(10),
            color: Colors.blue.shade100,
            elevation: 5,
            child: Container(
              padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(5),
                },
                children: [
                  TableRow(children: [
                    const TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Text(
                          "Reference ID",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.end,
                        )),
                    const TableCell(child: SizedBox(width: 10)),
                    TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Text(
                          widget.maintenancedetail.referenceId.toString(),
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ))
                  ]),
                  const TableRow(children: [
                    TableCell(child: SizedBox(height: 20)),
                    TableCell(child: SizedBox(height: 20)),
                    TableCell(child: SizedBox(height: 20)),
                  ]),
                  TableRow(children: [
                    const TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Text(
                          "Property Name",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w900),
                          textAlign: TextAlign.end,
                        )),
                    const TableCell(child: SizedBox(width: 10)),
                    TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Text(
                          widget.maintenancedetail.propertyName.toString(),
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ))
                  ]),
                  const TableRow(children: [
                    TableCell(child: SizedBox(height: 20)),
                    TableCell(child: SizedBox(height: 20)),
                    TableCell(child: SizedBox(height: 20)),
                  ]),
                  TableRow(children: [
                    const TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Text(
                          "Tenant Name",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w900),
                          textAlign: TextAlign.end,
                        )),
                    const TableCell(child: SizedBox(width: 10)),
                    TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Text(
                          widget.maintenancedetail.tenantName.toString(),
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ))
                  ]),
                  const TableRow(children: [
                    TableCell(child: SizedBox(height: 20)),
                    TableCell(child: SizedBox(height: 20)),
                    TableCell(child: SizedBox(height: 20)),
                  ]),
                  TableRow(children: [
                    const TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Text(
                          "Maintenance Type",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w900),
                          textAlign: TextAlign.end,
                        )),
                    const TableCell(child: SizedBox(width: 10)),
                    TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Text(
                          widget.maintenancedetail.maintenanceType.toString(),
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ))
                  ]),
                  const TableRow(children: [
                    TableCell(child: SizedBox(height: 20)),
                    TableCell(child: SizedBox(height: 20)),
                    TableCell(child: SizedBox(height: 20)),
                  ]),
                  TableRow(children: [
                    const TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w900),
                          textAlign: TextAlign.end,
                        )),
                    const TableCell(child: SizedBox(width: 10)),
                    TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Text(
                          widget.maintenancedetail.maintenanceDesc.toString(),
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ))
                  ]),
                  const TableRow(children: [
                    TableCell(child: SizedBox(height: 20)),
                    TableCell(child: SizedBox(height: 20)),
                    TableCell(child: SizedBox(height: 20)),
                  ]),
                  TableRow(children: [
                    const TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Text(
                          "Cost",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w900),
                          textAlign: TextAlign.end,
                        )),
                    const TableCell(child: SizedBox(width: 10)),
                    TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Text(
                          "RM ${widget.maintenancedetail.maintenanceCost}",
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ))
                  ]),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void deleteDialog() {
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
                  "Delete This Maintenance?",
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
                        deleteMaintenance();
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

  void deleteMaintenance() {
    http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/maintenance/delete_maintenance.php"),
        body: {
          "userid": widget.userdata.userid.toString(),
          "maintenanceid": widget.maintenancedetail.maintenanceId,
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Delete Success",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ));
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Delete Failed",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Delete Failed",
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ));
      }
    });
  }
}
