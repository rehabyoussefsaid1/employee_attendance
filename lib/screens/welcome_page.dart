import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:employee_attendance/screens/bottom_bar.dart';
import 'package:employee_attendance/screens/onBoarding_page.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/SharedPreferences.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  void _loadUserInfo() async {
    String token = await getToken();
    if (token == '') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => onBoardingPage()),
          (route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => BottomBar()),
          (route) => false);

      /*  ApiResponse response = await getUserDetail();
      if (response.data != null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => BottomBar()),
            (route) => false);
      } else if (response.error == unauthorized) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => onBoardingPage()),
            (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));
      } */
    }
  }

  @override
  void initState() {
    super.initState();

    _checkIfFirstTime();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      } else {}
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    saveAndroidDeviceInfo(build);
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    saveIosDeviceInfo(data);
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Future<void> saveAndroidDeviceInfo(AndroidDeviceInfo build) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('manufacturer', build.manufacturer ?? '');
    await prefs.setString('devicemodel', build.model ?? '');
    await prefs.setString('devicename', build.device ?? '');
    await prefs.setString('versionrelease', build.version.release ?? '');
    await prefs.setString('platform', 'Android' ?? '');
    await prefs.setString('idiom', build.device ?? '');
    await prefs.setString('deviceid', build.id ?? '');
  }
  
  
   Future<void> saveIosDeviceInfo(IosDeviceInfo data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('manufacturer', data.name ?? '');
    await prefs.setString('devicemodel', data.model ?? '');
    await prefs.setString('devicename',  data.name ?? '');
    await prefs.setString('versionrelease', data.utsname.release ?? '');
    await prefs.setString('platform', data.utsname.machine ?? '');
    await prefs.setString('idiom',  data.name ?? '');
    await prefs.setString('deviceid', data.identifierForVendor ?? '');
  }

  Future<void> _checkIfFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
      _loadUserInfo();
    } else {
      Timer(const Duration(seconds: 3), () {
        _loadUserInfo();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 166, 96, 180),
      body: Stack(
        children: [
          Positioned(
            left: -163,
            top: -160,
            child: Container(
              padding: const EdgeInsets.all(164),
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  width: 5,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ),
          Positioned(
            left: -180,
            top: -180,
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                shape: BoxShape.circle,
                border: Border.all(
                  width: 145,
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          Positioned(
            right: -171,
            bottom: -171,
            child: Container(
              padding: const EdgeInsets.all(164),
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  width: 5,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ),
          Positioned(
            right: -190,
            bottom: -190,
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                shape: BoxShape.circle,
                border: Border.all(
                  width: 145,
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.07,
              vertical: screenSize.height * 0.19,
            ),
            child: Column(
              children: [
                Image.asset("assets/AttendMeS.png"),
                const CircularProgressIndicator(
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
