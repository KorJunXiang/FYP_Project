import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:landlordy/insert_data/uploadpaymentpage.dart';
import 'package:landlordy/models/property.dart';
import 'package:landlordy/models/rentalpayment.dart';
import 'package:landlordy/models/tenant.dart';
import 'package:landlordy/models/user.dart';
import 'package:landlordy/shared/myserverconfig.dart';
import 'package:landlordy/views/paymentdetailpage.dart';

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
  List<String> tenantList = List<String>.filled(12, "");
  List<RentalPayment> paymentList = <RentalPayment>[];
  List<int> yearIntList = [];
  Set<int> uniqueYears = {};
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
                      Expanded(
                          flex: 3,
                          child: Text(
                            tenantList[index],
                            style: const TextStyle(
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
                                  : (tenantList[index] != "")
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
                                    RentalPayment singlePayment =
                                        paymentList.firstWhere(
                                            (payment) =>
                                                payment.month ==
                                                    monthList[index] &&
                                                payment.year == year,
                                            orElse: () =>
                                                RentalPayment(paymentId: null));
                                    (widget.tenantdetail.tenantName
                                                .toString() !=
                                            "Not Available")
                                        ? (tenantList[index] != "")
                                            ? overwriteDialog(
                                                monthList[index],
                                                year,
                                                singlePayment,
                                              )
                                            : {
                                                await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          UploadPaymentPage(
                                                        userdata:
                                                            widget.userdata,
                                                        propertydetail: widget
                                                            .propertydetail,
                                                        tenantdetail:
                                                            widget.tenantdetail,
                                                        paymentdetail:
                                                            singlePayment,
                                                        month: monthList[index],
                                                        year: year,
                                                        reupload: false,
                                                      ),
                                                    )),
                                                loadYearListAndPaymentsAndImageList(
                                                    year)
                                              }
                                        : ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                            content: Text("No Tenant Detail",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            backgroundColor: Colors.red,
                                          ));
                                  },
                                  child: Image.asset(
                                    'assets/icons/upload_icon.png',
                                    scale: 18,
                                  )),
                              GestureDetector(
                                  onTap: () async {
                                    String year = _yearEditingController.text;
                                    RentalPayment singlePayment =
                                        paymentList.firstWhere(
                                            (payment) =>
                                                payment.month ==
                                                    monthList[index] &&
                                                payment.year == year,
                                            orElse: () =>
                                                RentalPayment(paymentId: null));
                                    (tenantList[index] != "")
                                        ? {
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PaymentDetailPage(
                                                    userdata: widget.userdata,
                                                    propertydetail:
                                                        widget.propertydetail,
                                                    tenantdetail:
                                                        widget.tenantdetail,
                                                    paymentdetail:
                                                        singlePayment,
                                                  ),
                                                )),
                                            loadYearListAndPaymentsAndImageList(
                                                year)
                                          }
                                        : ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                            content: Text(
                                                "Payment Detail Not Available",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            backgroundColor: Colors.red,
                                          ));
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

  void overwriteDialog(String month, String year, RentalPayment singlePayment) {
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
                  "Re-Upload New Payment?",
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
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UploadPaymentPage(
                                userdata: widget.userdata,
                                propertydetail: widget.propertydetail,
                                tenantdetail: widget.tenantdetail,
                                paymentdetail: singlePayment,
                                month: month,
                                year: year,
                                reupload: true,
                              ),
                            ));
                        loadYearListAndPaymentsAndImageList(year);
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

  Future<void> loadYearListAndPaymentsAndImageList(String year) async {
    String originalYear = formatYear(widget.userdata.userdatereg.toString());
    tenantList = List<String>.filled(12, "");
    setState(() {
      isLoading = true;
    });
    final Map<String, int> monthMap = {
      'January': 0,
      'February': 1,
      'March': 2,
      'April': 3,
      'May': 4,
      'June': 5,
      'July': 6,
      'August': 7,
      'September': 8,
      'October': 9,
      'November': 10,
      'December': 11
    };

    final responsePayments = await http.post(
        Uri.parse(
            "${MyServerConfig.server}/landlordy/php/rentalpayment/load_payment.php"),
        body: {
          "userid": widget.userdata.userid,
          "propertyid": widget.propertydetail.propertyId,
        });
    log(responsePayments.body);
    if (responsePayments.statusCode == 200) {
      var jsondatapayment = jsonDecode(responsePayments.body);
      if (jsondatapayment['status'] == "success") {
        paymentList.clear();
        yearList.clear();
        yearIntList.clear();

        jsondatapayment['data']['payments'].forEach((v) {
          paymentList.add(RentalPayment.fromJson(v));
          int paymentYear = int.parse(v['year']);
          uniqueYears.add(paymentYear);
          if (paymentYear == int.parse(year)) {
            int monthIndex = monthMap[v['month']]!;
            tenantList[monthIndex] = v['tenant_name'];
          }
        });

        yearIntList = uniqueYears.toList();
        yearIntList.sort();
        yearList.addAll(yearIntList.map((year) => year.toString()));

        int latestYear = yearIntList
            .reduce((current, next) => current > next ? current : next);
        // log("LATEST YEAR: $latestYear");
        for (int i = 1; i < 5; i++) {
          yearList.add((latestYear + i).toString());
        }
      } else {
        yearList.clear();
        yearList.add(originalYear);
        // log("ORIGINAL YEAR: $originalYear");
        for (int i = 1; i < 5; i++) {
          yearList.add((int.parse(originalYear) + i).toString());
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
