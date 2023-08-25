import 'package:employee_attendance/app_localizations.dart';
import 'package:employee_attendance/screens/detail_presence_page.dart';
import 'package:employee_attendance/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../constants/SharedPreferences.dart';
import '../constants/constants.dart';
import '../models/User.dart';
import '../models/api-response.dart';
import '../services/presence_services.dart';
import '../services/user-services.dart';
import 'Login_page.dart';

//import '../models/test.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  User? user;

  //User Information
  void getUser() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null && mounted) {
      setState(() {
        user = response.data as User;
        print(user!.data.userId);
      });
      fetchData();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            if (mounted)
              {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false)
              }
          });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${response.error}')));
      }
    }
  }

  List<Map<String, dynamic>> filteredPresenceList = [];
  List<Map<String, dynamic>> presenceList = [];

//call the function of fetching presences
  Future<void> fetchData() async {
    try {
      List<Map<String, dynamic>> fetchedPresenceList =
          await getPresenceByIdEmp(user!.data.userId!);

      setState(() {
        presenceList = fetchedPresenceList;
        filteredPresenceList = fetchedPresenceList;
      });
    } catch (e) {
      print(e);
    }
  }

    
  int selectedIndex = 0;
  List category = [];

  TextEditingController _dateController1 = TextEditingController();
  late String _selectedDate1;

  Future<void> _selectDate1(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: darkBlue,
              secondary: lightBlue,
              onSecondary: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: darkBlue,
              ),
            ),
            textTheme: const TextTheme(
              headline4: TextStyle(
                fontFamily: "NexaBold",
              ),
              overline: TextStyle(
                fontFamily: "NexaBold",
              ),
              button: TextStyle(
                fontFamily: "NexaBold",
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate1 = DateFormat('yyyy-MM-dd').format(picked);
        _dateController1.text = _selectedDate1;
        filterPresenceListByDate(_selectedDate1);
      });
    }
  }

  @override
  void initState() {
    setState(() {
      getUser();
    });

    super.initState();
    // _selectedDate1 = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // _dateController1.text = _selectedDate1;
    _dateController1.text = "yyyy-MM-dd";
  }

  void filterPresenceListByDate(String selectedDate) {
    setState(() {
      filteredPresenceList = presenceList
          .where((presence) => presence['day'] == selectedDate)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    var translator = AppLocalizations.of(context);
category = [translator.translate('My data'), translator.translate('on account'),translator.translate('vacation'), translator.translate('Disclaimer'), translator.translate('my contracts'), translator.translate('my letters'), translator.translate('Clarifications'),  translator.translate('Resignation')];

    return Scaffold(
      backgroundColor: const Color.fromARGB(86, 155, 39, 176),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Gap(screenSize.height * 0.04),
           
            Gap(screenSize.height * 0.02),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.07,
                ),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        height: screenSize.height * 0.08,
                        width: screenSize.width * 1,
                        child: ListView.builder(
                          itemCount: category.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: ((context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index == 3
                                    ? screenSize.width * 0
                                    : screenSize.width * 0.03,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                    // Filter the presence list based on the selected category
                                    if (selectedIndex == 0) {
                                      // All category
                                      filteredPresenceList = presenceList;
                                    } else {
                                      String selectedStatus =
                                          category[selectedIndex];
                                      filteredPresenceList = presenceList
                                          .where((presence) =>
                                              presence['status'] ==
                                              selectedStatus)
                                          .toList();
                                    }
                                  });
                                },
                                child: Center(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: 5,
                                      bottom: 5,
                                      left: index == 0 ? 4 : 0,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: selectedIndex == index
                                          ? lightBlue
                                          : Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: selectedIndex == index
                                              ? maincolor
                                              : Color.fromARGB(148, 249, 214, 234),
                                          offset: selectedIndex == index
                                              ? Offset(1, 1)
                                              : Offset(0, 0),
                                          blurRadius:
                                              selectedIndex == index ? 2 : 0,
                                        )
                                      ],
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: lightBlue,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  screenSize.width * 0.04),
                                          child: Text(
                                            category[index],
                                            style: TextStyle(
                                              fontSize: screenSize.width * 0.04,
                                              color: selectedIndex == index
                                                  ? Colors.white
                                                  : darkBlue,
                                              fontFamily: 'ro',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Gap(screenSize.height * 0.01),
            Container(
              padding: EdgeInsets.only(
                top: 0,
                left: screenSize.width * 0.03,
                right: screenSize.width * 0.03,
                bottom: screenSize.height * 0.01,
              ),
              height: screenSize.height * 0.658,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
 Text(translator.translate('personal information'),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(children: [
               Text(
              'Name:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'employe name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            ]
           
            ),
             SizedBox(height: 16),
              Row(children: [
            Text(
              'Mobile:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
              Text(
             '01002365962',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
              ],
              )
              ],
              ),
          
           
            ),
          ],
        ),
      ),
    );
  }
}
