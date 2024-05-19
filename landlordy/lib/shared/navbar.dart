import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:landlordy/models/user.dart';
import 'package:landlordy/shared/myserverconfig.dart';
import 'package:landlordy/views/eventspage.dart';
import 'package:landlordy/views/genreportpage.dart';
import 'package:landlordy/views/maintenancepage.dart';
import 'package:landlordy/views/profilepage.dart';
import 'package:landlordy/views/propertiespage.dart';
import 'package:landlordy/views/rentalpaymentpage.dart';
import 'package:landlordy/views/tenantspage.dart';
import 'package:landlordy/views/welcomepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
  final User userdata;
  final int selectedIndex;
  const NavBar(
      {super.key, required this.userdata, required this.selectedIndex});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              widget.userdata.username.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              widget.userdata.useremail.toString(),
              style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
            ),
            margin: EdgeInsets.zero,
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  "${MyServerConfig.server}/landlordy/assets/profiles/${widget.userdata.userid}.png",
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      double progress = loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1);
                      return Center(
                          child: CircularProgressIndicator(
                        value: progress,
                        color: Colors.blue,
                      ));
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/images/user.png');
                  },
                ),
              ),
            ),
            decoration: const BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                    image: AssetImage('assets/images/background.jpg'),
                    fit: BoxFit.cover)),
          ),
          const Divider(
            color: Colors.black,
            height: 0,
            thickness: 2,
          ),
          ListTile(
            leading: Image.asset(
              'assets/icons/property_name_icon.png',
              scale: 18,
            ),
            title: const Text("Properties",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            tileColor: widget.selectedIndex == 0 ? Colors.blue : null,
            textColor: widget.selectedIndex == 0 ? Colors.white : null,
            iconColor: widget.selectedIndex == 0 ? Colors.white : null,
            onTap: () {
              navigateToPage(0);
            },
          ),
          const Divider(
            color: Colors.black,
            height: 0,
            thickness: 2,
          ),
          ListTile(
            leading: Image.asset(
              'assets/icons/tenant_icon.png',
              scale: 18,
            ),
            title: const Text("Tenants",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            tileColor: widget.selectedIndex == 1 ? Colors.blue : null,
            textColor: widget.selectedIndex == 1 ? Colors.white : null,
            iconColor: widget.selectedIndex == 1 ? Colors.white : null,
            onTap: () {
              navigateToPage(1);
            },
          ),
          const Divider(
            color: Colors.black,
            height: 0,
            thickness: 2,
          ),
          ListTile(
            leading: Image.asset(
              'assets/icons/price_icon.png',
              scale: 18,
            ),
            title: const Text("Rental Payment",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            tileColor: widget.selectedIndex == 2 ? Colors.blue : null,
            textColor: widget.selectedIndex == 2 ? Colors.white : null,
            iconColor: widget.selectedIndex == 2 ? Colors.white : null,
            onTap: () {
              navigateToPage(2);
            },
          ),
          const Divider(
            color: Colors.black,
            height: 0,
            thickness: 2,
          ),
          ListTile(
            leading: Image.asset(
              'assets/icons/maintenance_icon.png',
              scale: 18,
            ),
            title: const Text("Maintenance",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            tileColor: widget.selectedIndex == 3 ? Colors.blue : null,
            textColor: widget.selectedIndex == 3 ? Colors.white : null,
            iconColor: widget.selectedIndex == 3 ? Colors.white : null,
            onTap: () {
              navigateToPage(3);
            },
          ),
          const Divider(
            color: Colors.black,
            height: 0,
            thickness: 2,
          ),
          ListTile(
            leading: Image.asset(
              'assets/icons/event_icon.png',
              scale: 18,
            ),
            title: const Text("Events",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            tileColor: widget.selectedIndex == 4 ? Colors.blue : null,
            textColor: widget.selectedIndex == 4 ? Colors.white : null,
            iconColor: widget.selectedIndex == 4 ? Colors.white : null,
            onTap: () {
              navigateToPage(4);
            },
          ),
          const Divider(
            color: Colors.black,
            height: 0,
            thickness: 2,
          ),
          ListTile(
            leading: Image.asset(
              'assets/icons/graph_icon.png',
              scale: 18,
            ),
            title: const Text("Report Generation",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            tileColor: widget.selectedIndex == 5 ? Colors.blue : null,
            textColor: widget.selectedIndex == 5 ? Colors.white : null,
            iconColor: widget.selectedIndex == 5 ? Colors.white : null,
            onTap: () {
              navigateToPage(5);
            },
          ),
          const Divider(
            color: Colors.black,
            height: 0,
            thickness: 2,
          ),
          ListTile(
            leading: Image.asset(
              'assets/icons/profile_icon.png',
              scale: 18,
            ),
            title: const Text("Profile",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            tileColor: widget.selectedIndex == 6 ? Colors.blue : null,
            textColor: widget.selectedIndex == 6 ? Colors.white : null,
            iconColor: widget.selectedIndex == 6 ? Colors.white : null,
            onTap: () {
              navigateToPage(6);
            },
          ),
          const Divider(
            color: Colors.black,
            height: 0,
            thickness: 2,
          ),
          ListTile(
            leading: Image.asset(
              'assets/icons/logout_icon.png',
              scale: 18,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            onTap: () {
              logoutDialog();
            },
          ),
          const Divider(
            color: Colors.black,
            height: 0,
            thickness: 2,
          ),
        ],
      ),
    );
  }

  void navigateToPage(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PropertiesPage(userdata: widget.userdata),
            ));
        break;
      case 1:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TenantsPage(userdata: widget.userdata),
            ));
        break;
      case 2:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RentalPaymentPage(userdata: widget.userdata),
            ));
        break;
      case 3:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MaintenancePage(userdata: widget.userdata),
            ));
        break;
      case 4:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => EventsPage(userdata: widget.userdata),
            ));
        break;
      case 5:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GenReportPage(userdata: widget.userdata),
            ));
        break;
      case 6:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(userdata: widget.userdata),
            ));
        break;
    }
  }

  void logoutDialog() {
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
                  "Confirm Logout?",
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
                        logout();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WelcomePage(),
                            ));
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Logout Success",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          backgroundColor: Colors.green,
                        ));
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

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('login', false);
  }
}
