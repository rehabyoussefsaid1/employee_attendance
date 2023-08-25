import 'package:employee_attendance/app_localizations.dart';
import 'package:employee_attendance/screens/Check_in_out.dart';
import 'package:employee_attendance/screens/Service.dart';
import 'package:employee_attendance/screens/generated_qrCode.dart';
import 'package:employee_attendance/screens/history_page.dart';
import 'package:employee_attendance/screens/home_page.dart';
import 'package:employee_attendance/screens/profile_page.dart';
import 'package:employee_attendance/screens/qrCode_succes.dart';
import 'package:employee_attendance/screens/scan_page.dart';
import 'package:employee_attendance/screens/show_camera.dart';
import 'package:employee_attendance/screens/success_checkin_page.dart';
import 'package:camera/camera.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:employee_attendance/screens/change_password2.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key, this.initialIndex});

  final int? initialIndex;

  get result => null;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  String? status;
  String? YN;
  // String? Status;
  List<Widget> _widgetOptions = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialIndex != null) {
      _selectedIndex = widget.initialIndex!;
    }

    _widgetOptions = [
      const HomeScreen(),
   const ServicePage(),
      FutureBuilder<Widget>(
        future: getPage(),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Return a placeholder widget while the future is loading
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Handle any errors that occurred while resolving the future
            return Text('Error: ${snapshot.error}');
          } else {
            // Return the resolved widget
            return snapshot.data!;
          }
        },
      ),
      const HistoryPage(),
     // const ProfilePage(),
    ];

    SharedPreferences.getInstance().then((prefs) async {
      await getSessionVariables(prefs);
      // setState(() {
      //   // Status = status;
      //   // Call setState to trigger a rebuild after getting the session variables
      // });
    });
  }

  Future<void> getSessionVariables(SharedPreferences prefs) async {
    setState(() {
      status = prefs.getString('status');
      YN = prefs.getString('getQrCode');
    });
  }

  // for Scan
  Future<Widget> getPage() async {
    final prefs = await SharedPreferences.getInstance();
    await getSessionVariables(prefs);
    print(status);
    if (status == "checkOut") {
      return ScanPage();
    } else {
      final cameras = await availableCameras();
      return CameraPage(
        cameras: cameras,
      );
    }
  }

  // for qr code
  Future<Widget> getPage2() async {
    final prefs = await SharedPreferences.getInstance();
    await getSessionVariables(prefs);
    print(YN);
    if (YN == "no") {
      return QrCodeGeneratedPage();
    } else {
      return GeneratedCodePageSuccess();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String result = "";

  @override
  Widget build(BuildContext context) {
     var translator = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 20,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: const Color.fromARGB(255, 156, 39, 176),
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: const Color.fromARGB(255, 156, 39, 176),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue), // Set the color for selected label text
        unselectedLabelStyle:const TextStyle(fontWeight: FontWeight.normal, color: Colors.grey), // Set the color for unselected label text

        items:  [
          BottomNavigationBarItem(
            icon: const Icon(FluentSystemIcons.ic_fluent_home_regular),
            activeIcon:const Icon(FluentSystemIcons.ic_fluent_home_filled),
            label:  translator.translate('Home'),
            
          ),
          BottomNavigationBarItem(
            icon:const Icon(FluentSystemIcons.ic_fluent_window_shield_regular),
            activeIcon:
              const  Icon(FluentSystemIcons.ic_fluent_wallpaper_filled),
            label: translator.translate('my services'),
          ),
          BottomNavigationBarItem(//for empaty place
            icon: const SizedBox(width: 20, height: 25,),
            label: translator.translate('Check In'),
          ),
          BottomNavigationBarItem(
            icon:const Icon(
                FluentSystemIcons.ic_fluent_channel_follow_regular),
            activeIcon:const Icon(
                FluentSystemIcons.ic_fluent_channel_follow_filled),
            label: translator.translate('follow'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(FluentSystemIcons.ic_fluent_settings_dev_regular),
            activeIcon:const Icon(FluentSystemIcons.ic_fluent_settings_dev_filled),
            label: translator.translate('setting'), 
          ),
        ],
      ),
       floatingActionButton: FloatingActionButton(//for make checkin and checkout screen 
        onPressed: () {
           Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CheckUserPage(),
              ),
            );
        
        },
        child: Icon(Icons.av_timer_outlined, size: 50.0,),
        backgroundColor: const Color.fromARGB(255, 156, 39, 176),
      ),
     /*  floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (status == "checkOut") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScanPage(),
              ),
            );
          } else {
            await availableCameras().then(
              (value) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CameraPage(
                    cameras: value,
                  ),
                ),
              ),
            );
          }
        },
        child: Icon(Icons.av_timer_outlined, size: 50.0,),
        backgroundColor: const Color.fromARGB(255, 156, 39, 176),
      ), */
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> scanQr() async {
    try {
      FlutterBarcodeScanner.scanBarcode(
          '#2A99CF', 'cancel', false, ScanMode.QR);
    } catch (e) {
      print("ERROR");
    }

    //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SucessCheckinPage(scanResult: result,)));
  }
}
