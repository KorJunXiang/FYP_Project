// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:landlordy/insert_data/uploadpaymentpage.dart';
import 'package:landlordy/models/property.dart';
import 'package:landlordy/models/rentalpayment.dart';
import 'package:landlordy/models/tenant.dart';
import 'package:landlordy/models/user.dart';
import 'package:landlordy/shared/myserverconfig.dart';

class RentalMonthlyPage extends StatefulWidget {
  final User userdata;
  final Property propertydetail;
  final Tenant tenantdetail;
  const RentalMonthlyPage(
      {super.key,
      required this.userdata,
      required this.propertydetail,
      required this.tenantdetail});

  @override
  State<RentalMonthlyPage> createState() => _RentalMonthlyPageState();
}

class _RentalMonthlyPageState extends State<RentalMonthlyPage> {
  final TextEditingController _yearEditingController = TextEditingController();
  final TextEditingController _amountEditingController =
      TextEditingController();
  late double screenWidth, screenHeight;
  bool isLoading = true;
  final List<bool> _imageList = List<bool>.filled(12, false);
  List<RentalPayment> paymentList = <RentalPayment>[];
  List<int> yearIntList = [];
  List<String> yearList = [];
  List<String> monthList = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  @override
  void initState() {
    super.initState();
    loadYearListAndPaymentsAndImageList(
        formatYear(widget.userdata.userdatereg.toString()));
    _yearEditingController.text =
        formatYear(widget.userdata.userdatereg.toString());
  }

  @override
  void dispose() {
    _amountEditingController.dispose();
    _yearEditingController.dispose();
    super.dispose();
  }

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
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                  width: screenWidth * 0.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Image.network(
                    "${MyServerConfig.server}/landlordy/assets/properties/${widget.propertydetail.propertyId}_1.png",
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        double progress =
                            loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1);
                        return Center(
                            child: CircularProgressIndicator(
                          value: progress,
                          color: Colors.blue,
                        ));
                      }
                    },
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/property_name_icon.png',
                            scale: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "${widget.propertydetail.propertyName}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/tenant_name_icon.png',
                            scale: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "${widget.tenantdetail.tenantName}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/price_icon.png',
                            scale: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "RM${widget.propertydetail.rentalPrice}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/year_icon.png',
                  scale: 15,
                  alignment: Alignment.centerLeft,
                ),
                SizedBox(
                  width: screenWidth * 0.4,
                  child: DropdownMenu<String>(
                    menuHeight: 200,
                    expandedInsets: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    controller: _yearEditingController,
                    trailingIcon: const Icon(Icons.arrow_drop_down_rounded,
                        color: Colors.black, size: 30),
                    selectedTrailingIcon: const Icon(
                        Icons.arrow_drop_up_rounded,
                        color: Colors.black,
                        size: 30),
                    label: const Text(
                      'Year',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    inputDecorationTheme: const InputDecorationTheme(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    dropdownMenuEntries: yearList.map((String items) {
                      return DropdownMenuEntry<String>(
                        value: items,
                        label: items,
                      );
                    }).toList(),
                    onSelected: (String? newValue) {
                      _yearEditingController.text = newValue!;
                      loadYearListAndPaymentsAndImageList(newValue);
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[350],
                border: const Border.symmetric(
                    horizontal: BorderSide(color: Colors.black, width: 2))),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/month_icon.png',
                          scale: 18,
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          "Month",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 25),
                        ),
                      ],
                    )),
                Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/tenant_name_icon.png',
                          scale: 18,
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          "Tenant",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 25),
                        ),
                      ],
                    )),
                Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/image_upload_icon.png',
                          scale: 18,
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          "Status",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 25),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: monthList.length,
            itemBuilder: (context, index) {
              return Container(
                  decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      border: const Border(
                          bottom: BorderSide(color: Colors.black, width: 2))),
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Text(
                            monthList[index],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          )),
                      const Expanded(
                          flex: 3,
                          child: Text(
                            "Name",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          )),
                      Flexible(
                          fit: FlexFit.loose,
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              (isLoading)
                                  ? const CircularProgressIndicator(
                                      color: Colors.blue,
                                    )
                                  : (_imageList[index] == true)
                                      ? Image.asset(
                                          'assets/icons/tick_icon.png',
                                          scale: 18,
                                        )
                                      : Image.asset(
                                          'assets/icons/cross_icon.png',
                                          scale: 18,
                                        ),
                              GestureDetector(
                                  onTap: () async {
                                    String year = _yearEditingController.text;
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UploadPaymentPage(
                                            userdata: widget.userdata,
                                            propertydetail:
                                                widget.propertydetail,
                                            tenantdetail: widget.tenantdetail,
                                            month: monthList[index],
                                            year: year,
                                          ),
                                        ));
                                    loadYearListAndPaymentsAndImageList(year);
                                  },
                                  child: Image.asset(
                                    'assets/icons/upload_icon.png',
                                    scale: 18,
                                  )),
                              GestureDetector(
                                  onTap: () {
                                    String year = _yearEditingController.text;
                                    loadYearListAndPaymentsAndImageList(year);
                                  },
                                  child: Image.asset(
                                    'assets/icons/next_icon.png',
                                    scale: 18,
                                  )),
                            ],
                          )),
                    ],
                  ));
            },
          ))
        ],
      ),
    );
  }

  Future<void> loadYearListAndPaymentsAndImageList(String year) async {
    setState(() {
      isLoading = true;
    });
    String propertyid = widget.propertydetail.propertyId.toString();
    int numofmonth = monthList.length;
    final responsePayments = await http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/rentalpayment/load_payment.php"),
        body: {
          "userid": widget.userdata.userid,
          "propertyid": widget.propertydetail.propertyId
        });
    for (int i = 0; i < numofmonth; i++) {
      String imageUrl =
          "${MyServerConfig.server}/landlordy/assets/payments/${propertyid}_$year${monthList[i]}.png";
      http.Response response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        _imageList[i] = true;
      } else {
        _imageList[i] = false;
      }
    }
    // print(responsePayments.body);
    if (responsePayments.statusCode == 200) {
      var jsondatapayment = jsonDecode(responsePayments.body);
      if (jsondatapayment['status'] == "success") {
        paymentList.clear();
        yearList.clear();
        yearIntList.clear();
        yearList.add(year);
        jsondatapayment['data']['payments'].forEach((v) {
          paymentList.add(RentalPayment.fromJson(v));
          yearIntList.add(int.parse(v['year']));
        });
        int latestYear = yearIntList
            .reduce((current, next) => current > next ? current : next);
        for (int i = 0; i < 2; i++) {
          yearList.add((latestYear + i).toString());
        }
      } else {
        yearList.clear();
        for (int i = 1; i < 2; i++) {
          yearList.add((int.parse(year) + i).toString());
        }
      }
      isLoading = false;
      setState(() {});
    }
  }

  String formatYear(String date) {
    return date.substring(0, 4);
  }
}
