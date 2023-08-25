import 'package:employee_attendance/app_localizations.dart';
import 'package:employee_attendance/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:employee_attendance/constants/lang_ar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class onBoardingPage extends StatefulWidget {
  const onBoardingPage({super.key});

  @override
  State<onBoardingPage> createState() => _onBoardingPageState();
}

class _onBoardingPageState extends State<onBoardingPage> {
  
  @override
  Widget build(BuildContext context) {

    var translator = AppLocalizations.of(context);
    return SafeArea(
      child: IntroductionScreen(
        pages: [
          PageViewModel(
            title: translator.translate('pageview_Title1'),
            body: translator.translate('pageview_body1'),
            image: Padding(
              padding: const EdgeInsets.only(top: 22),
              child:  SvgPicture.asset('assets/save_time.svg'),),
            decoration: getPageDecoration(),
          ),
          PageViewModel(
           title: translator.translate('pageview_Title2'),
            body: translator.translate('pageview_body2'),
            image: Padding(
              padding: const EdgeInsets.only(top: 22),
              child:  SvgPicture.asset("assets/real_time_data.svg"),
            ),
            decoration: getPageDecoration(),
          ),
          PageViewModel(
          title: translator.translate('pageview_Title3'),
            body: translator.translate('pageview_body3'),
            image: Padding(
              padding: const EdgeInsets.only(top: 22),
              child:  SvgPicture.asset("assets/attendance_record.svg"),
            ),
            decoration: getPageDecoration(),
          ),
            PageViewModel(
          title: translator.translate('pageview_Title4'),
            body: translator.translate('pageview_body4'),
            image: Padding(
              padding: const EdgeInsets.only(top: 22),
              child:  SvgPicture.asset("assets/Make_your_career.svg"),
            ),
            decoration: getPageDecoration(),
          ),
        ],
        onDone: () {
          goToLogin(context);
        },
        showNextButton: true,
        next: Container(
        width: 145,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              translator.translate("next"),
              style: GoogleFonts.raleway(
                          textStyle: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),),
            ),
          ],
        ),
      ),
      ),
      

            
           
            
        showBackButton: false,
        showSkipButton: true,
        onSkip: () => goToLogin(context),
        skip:  Text(translator.translate('skip'),
            style: GoogleFonts.urbanist(
                          textStyle: TextStyle(
                            color: Color.fromARGB(255, 131, 145, 181),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
            ),
        done:  Container(
        width: 145,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              translator.translate("next"),
              style: GoogleFonts.raleway(
                          textStyle: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),),
            ),
          ],
        ),
      ),
      ),
        dotsDecorator: getDotDecoration(),
      ),
    );
  }

  void goToLogin(context) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );

  DotsDecorator getDotDecoration() => DotsDecorator(
        color: const Color.fromARGB(255, 228, 229, 231),
        activeColor: const Color.fromARGB(255, 43, 128, 211),
        size: const Size(10, 10),
        activeSize: const Size(20, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );

  PageDecoration getPageDecoration() {
    return PageDecoration(
      imageAlignment: Alignment.center,
      titleTextStyle: GoogleFonts.raleway(
                          textStyle: TextStyle(
                            color: Color.fromARGB(255, 6, 6, 6),
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),),
      bodyTextStyle:GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color:  Color.fromARGB(255, 112, 123, 129),
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),),
      imagePadding: const EdgeInsets.only(
        top: 8,
      ),
    );
  }
}
