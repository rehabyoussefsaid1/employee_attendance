import 'package:employee_attendance/app_localizations.dart';
import 'package:employee_attendance/screens/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'dart:async';
import 'dart:developer' as developer;



void main() {

 runZonedGuarded(() {
    runApp(const MyApp());
  }, (dynamic error, dynamic stack) {
    developer.log("Something went wrong!", error: error, stackTrace: stack);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Attendancegit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
     
       localizationsDelegates: const[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
 supportedLocales: const [
        Locale('en', 'US'),
        Locale('ar' , 'EG'),
      ], 
 
      home:const WelcomePage(),
      
   
    );
  }
}