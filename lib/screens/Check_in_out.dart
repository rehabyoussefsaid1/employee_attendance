import 'package:employee_attendance/app_localizations.dart';
import 'package:employee_attendance/constants/colors.dart';
import 'package:employee_attendance/models/CheckLocationModel.dart';
import 'package:employee_attendance/screens/verification_page.dart';
import 'package:employee_attendance/services/assignment_services.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../models/api-response.dart';
import '../services/user-services.dart';

class CheckUserPage extends StatefulWidget {
  const CheckUserPage({super.key});

  @override
  State<CheckUserPage> createState() => _CheckUserPageState();
}

class _CheckUserPageState extends State<CheckUserPage> {
  final formKey = GlobalKey<FormState>();
  var responsmessage= "";
  var data = false;

 void checklocation() async {
   ApiResponse response = await checkLocation();
      if (response.data != null) {
        var responsedata = response.data as CheckLocationModel;
        setState(() {
          responsmessage = responsedata.msg;
          data = responsedata.data;
        });
        
      }else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));
      } 
 }
@override
  void initState() {
    super.initState();
   // checkLocation();
  }
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    var translator = AppLocalizations.of(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: Padding(
            padding: EdgeInsets.only(left: screenSize.width * 0.15),
            child: Text(
              translator.translate('CheckPage'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color.fromARGB(255, 133, 118, 118),
                fontSize: screenSize.width * 0.05,
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: Color.fromARGB(255, 133, 118, 118)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0,
              vertical: screenSize.height * 0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Gap(screenSize.height * 0),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.05,
                        vertical: screenSize.height * 0.05),
                    child: Stack(
                      children: [
                       
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              height: 250,
                              width: 250,
                              child: Center(
                                child: data ? Image.asset("assets/checkin.png") : Image.asset("assets/checkout.png"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Gap(screenSize.height * 0.01),
                        Container(
                            alignment: Alignment.center,
                            child: RichText(
                              text: TextSpan(
                                text: DateTime.now().day.toString(),
                                style: TextStyle(
                                  color:
                                      const Color.fromARGB(135, 255, 255, 255),
                                  fontSize: screenSize.width * 0.04,
                                  fontFamily: "NexaBold",
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: DateFormat(' MMMM yyyy')
                                        .format(DateTime.now()),
                                    style: TextStyle(
                                      color: Color.fromARGB(134, 0, 0, 0),
                                      fontSize: screenSize.width * 0.05,
                                      fontFamily: "NexaBold",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                    SizedBox(width: screenSize.width * 0.02),
                    Column(
                      children: [
                        Gap(screenSize.height * 0.01),
                        StreamBuilder(
                          stream: Stream.periodic(const Duration(seconds: 1)),
                          builder: (context, snapshot) {
                            return Container(
                              alignment: Alignment.center,
                              child: Text(
                                DateFormat('hh:mm:ss a').format(DateTime.now()),
                                style: TextStyle(
                                  fontFamily: "NexaRegular",
                                  fontSize: screenSize.width * 0.08,
                                  color:
                                      Color.fromARGB(134, 0, 0, 0),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.07,
                      vertical: screenSize.height * 0.01),
                  child: Text(
                   responsmessage,
                    style: TextStyle(
                      fontSize: screenSize.width * 0.045,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 88, 84, 84),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Gap(screenSize.height * 0.02),
                
                Gap(screenSize.height * 0.06),
                SizedBox(
                  width: screenSize.width * 0.5,
                  height: screenSize.height * 0.07,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: buttoncolor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35))),
                    onPressed: () {
                      checklocation();
                    },
                    child: Text(data ? translator.translate('Check Out') :translator.translate('Check In') ,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenSize.width * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )));
  }
}
