import 'package:flutter/material.dart';
import 'package:landlordy/edit_data/edittenantpage.dart';
import 'package:landlordy/models/tenant.dart';
import 'package:landlordy/models/user.dart';
import 'package:url_launcher/url_launcher.dart';

class TenantDetailPage extends StatefulWidget {
  final User userdata;
  final Tenant tenantdetail;
  const TenantDetailPage(
      {super.key, required this.userdata, required this.tenantdetail});

  @override
  State<TenantDetailPage> createState() => _TenantDetailPageState();
}

class _TenantDetailPageState extends State<TenantDetailPage> {
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
                  builder: (context) => EditTenantPage(
                    userdata: widget.userdata,
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
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            color: Colors.lightBlue.shade100,
            elevation: 5,
            child: Container(
              padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
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
                                margin: const EdgeInsets.fromLTRB(5, 0, 15, 0),
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
                                    fontSize: 25, fontWeight: FontWeight.w900),
                              )),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Text(
                              widget.tenantdetail.tenantName.toString(),
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
                                margin: const EdgeInsets.fromLTRB(5, 0, 15, 0),
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
                                    fontSize: 25, fontWeight: FontWeight.w900),
                              )),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Text(
                              widget.tenantdetail.tenantEmail.toString(),
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
                                margin: const EdgeInsets.fromLTRB(5, 0, 15, 0),
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
                                    fontSize: 25, fontWeight: FontWeight.w900),
                              )),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Text(
                              widget.tenantdetail.tenantGender.toString(),
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
                                margin: const EdgeInsets.fromLTRB(5, 0, 15, 0),
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
                                    fontSize: 25, fontWeight: FontWeight.w900),
                              )),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Text(
                              widget.tenantdetail.tenantAge.toString(),
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
                                margin: const EdgeInsets.fromLTRB(5, 0, 15, 0),
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
                                    fontSize: 25, fontWeight: FontWeight.w900),
                              )),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Text(
                              widget.tenantdetail.tenantCategory.toString(),
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
                                margin: const EdgeInsets.fromLTRB(5, 0, 15, 0),
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
                                    fontSize: 25, fontWeight: FontWeight.w900),
                              )),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Text(
                              formatPhoneNumber(
                                  widget.tenantdetail.tenantPhone.toString()),
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
                                margin: const EdgeInsets.fromLTRB(5, 0, 15, 0),
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
                                    fontSize: 25, fontWeight: FontWeight.w900),
                              )),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Text(
                              "RM ${widget.tenantdetail.rentalPrice}",
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
                                margin: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                                child: const Image(
                                  image: AssetImage(
                                    'assets/icons/rental_status_icon.png',
                                  ),
                                  fit: BoxFit.scaleDown,
                                ),
                              )),
                          const TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Text(
                                "Rental Status",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w900),
                              )),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Text(
                              widget.tenantdetail.rentalStatus.toString(),
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w500),
                            ),
                          )
                        ]),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      clipBehavior: Clip.antiAlias,
                      onPressed: () {
                        launchWhatsApp(
                            widget.tenantdetail.tenantPhone.toString(),
                            widget.tenantdetail.tenantName.toString());
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        fixedSize: Size(screenWidth * 0.5, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // elevation: 100,
                      ),
                      child: Ink.image(
                          padding: EdgeInsets.zero,
                          image: const AssetImage(
                              'assets/images/WhatsAppButtonGreenSmall.png'),
                          fit: BoxFit.cover),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void launchWhatsApp(String phone, String name) async {
    String phoneNumber = phone.substring(1);
    String encodedText = Uri.encodeComponent("Hi, $name");
    Uri url = Uri.parse('https://wa.me/$phoneNumber?text=$encodedText');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  String formatPhoneNumber(String phoneNumber) {
    return '${phoneNumber.substring(0, 3)}-${phoneNumber.substring(3)}';
  }
}
