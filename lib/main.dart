import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medic_app/model/packages_model.dart';
import 'package:medic_app/model/specialties_model.dart';
import 'package:medic_app/screens/booking_screen.dart';
import 'package:medic_app/screens/doctors_screen.dart';
import 'package:medic_app/screens/follow_up_screen.dart';
import 'package:medic_app/screens/health_monitor_screen.dart';
import 'package:medic_app/screens/lab_screen.dart';
import 'package:medic_app/screens/manage_profile_screen.dart';
import 'package:medic_app/screens/medication_screen.dart';
import 'package:medic_app/screens/contact_screen.dart';
import 'package:medic_app/screens/about_us_screen.dart';
import 'package:medic_app/screens/gallery_screen.dart';
import 'package:medic_app/screens/home_screen.dart';
import 'package:medic_app/screens/log_in_screen.dart';
import 'package:medic_app/screens/packages_screen.dart';
import 'package:medic_app/screens/radiology_screen.dart';
import 'package:medic_app/screens/registration_screen.dart';
import 'package:medic_app/screens/speciality_screen.dart';
import 'package:medic_app/screens/doctors_search_screen.dart';
import 'package:medic_app/screens/appointment_screen.dart';
import 'package:medic_app/screens/almanara_screen.dart';
import 'package:medic_app/screens/testimonials_screen.dart';
import 'package:medic_app/screens/reach_us_screen.dart';
import 'package:medic_app/screens/video_call_screen.dart';
import 'package:medic_app/screens/wallet_screen.dart';
import 'package:medic_app/widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/time_slots_model.dart';
import 'model/user_model.dart';
import 'network/login_api.dart';
import 'network/medication_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserModel()),
        ChangeNotifierProvider.value(value: SpecialtiesList()),
        ChangeNotifierProvider.value(value: TimesList()),
        ChangeNotifierProvider.value(value: PackagesContentList())
      ],
      child: MaterialApp(
          title: 'My Clinic',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color(0xFF002768),
          ),
          initialRoute: WelcomeScreen.id,
          routes: {
            AboutUs.id: (context) => const AboutUs(),
            Appointment.id: (context) => const Appointment(),
            Availability.id: (context) => const Availability(),
            Medication.id: (context) => const Medication(),
            ContactUs.id: (context) => const ContactUs(),
            PastAppointments.id: (context) => const PastAppointments(),
            Location.id: (context) => const Location(),
            FollowUp.id: (context) => const FollowUp(),
            Services.id: (context) => const Services(),
            Testimonials.id: (context) => const Testimonials(),
            AlManara.id: (context) => const AlManara(),
            MyHomePage.id: (context) =>
                const MyHomePage(title: 'Techno Clinic'),
            WelcomeScreen2.id: (context) => const WelcomeScreen2(),
            WelcomeScreen.id: (context) => const WelcomeScreen(),
            LoginScreen.id: (context) => const LoginScreen(),
            BookingS.id: (context) => const BookingS(),
            Registration.id: (context) => const Registration(),
            ManageProfile.id: (context) => const ManageProfile(),
            WalletScreen.id: (context) => const WalletScreen(),
            VideoAppointment.id: (context) => const VideoAppointment(),
            PackagesScreen.id: (context) => const PackagesScreen(),
            DoctorSearch.id: (context) => const DoctorSearch(),
            HmDashBoard.id: (context) => const HmDashBoard(),
            HealthMonitor.id: (context) => const HealthMonitor(),
            Radiology.id: (context) => const Radiology(),
            LabApointments.id: (context) => const LabApointments(),


          }),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  static const String id = 'welcome_screen';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    void navigateUser() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var status = prefs.getBool('isLoggedIn') ?? false;
      print(status);
      if (status) {
        String? token = prefs.getString('token');
        if (token == null) {
          Navigator.pushReplacementNamed(context, WelcomeScreen2.id);
        } else {
          dynamic response = await LoginApi.getUserInfo(context, token);
          if (response.toString() != '200') {
            imageCache?.clear();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.clear();
            await Future.delayed(const Duration(seconds: 2));
            Navigator.pushReplacementNamed(context, WelcomeScreen2.id);
          } else {
            if(prefs.getString("med_latest_update") != null){
              var today = DateTime.now();
              var lastUpdate = prefs.getString("med_last_update");
              var diff = today.difference(DateTime.parse(lastUpdate!)).inDays;
              if (diff >= 7) {
                var meds = await MedicationApi.getMedicineList(context);
                Directory? directory = Platform.isAndroid
                    ? await getExternalStorageDirectory()
                    : await getApplicationSupportDirectory();
                File file;
                if (await File("${directory!.path}/medicine.json").exists()){
                  file = File("${directory.path}/medicine.json");

                } else {
                  file = await File("${directory.path}/medicine.json").create();
                }
                await file.writeAsString(jsonEncode(meds));
              }
            } else {
              SharedPreferences prefs =
              await SharedPreferences.getInstance();
              prefs.setString("med_last_update", DateTime.now().toString());
            }
            Navigator.pushReplacementNamed(context, MyHomePage.id);
          }
        }
      } else {
        Navigator.pushReplacementNamed(context, WelcomeScreen2.id);
      }
    }

    Timer(
      const Duration(seconds: 2),
      () => navigateUser(),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: deviceSize.height * 0.35),
            Image.asset(
              'assets/techno clinic.png',
              width: 300,
              height: 200,
            ),
            SizedBox(height: deviceSize.height * 0.15),
            const Text(
              'Powered By',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
              ),
            ),
            Image.asset(
              'assets/TTlogo.png',
              width: 80,
              height: 80,
            )
          ],
        ),
      ),
    );
  }
}

class WelcomeScreen2 extends StatelessWidget {
  static const String id = 'welcome_screen_2';

  const WelcomeScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            CustomPaint(
              painter: ShapesPainter(),
              child: SizedBox(
                height: 280,
                width:  800,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 130),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text('WELCOME TO ',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB22234))),
                      Text('Techno Clinic',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB22234))),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height:30),
            Image.asset(
              'assets/techno clinic.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height:30),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 90,
                  child: RoundedButton(
                    buttonColor: Theme.of(context).primaryColor,
                    buttonText: 'Log in',
                    buttonFunction: () {
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 90,
                  child: RoundedButton(
                      buttonColor: Colors.white,
                      buttonText: 'Create Account',
                      textColor: Theme.of(context).primaryColor,
                      buttonFunction: () {
                        Navigator.pushNamed(context, Registration.id);
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
const double _kCurveHeight = 35;

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Path();
    p.lineTo(0, size.height - _kCurveHeight);
    p.relativeQuadraticBezierTo(size.width / 2, 2 * _kCurveHeight, size.width, 0);
    p.lineTo(size.width, 0);
    p.close();

    canvas.drawPath(p, Paint()..color = const Color(0xFF002768));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
//'https://images.onhealth.com/images/slideshow/right-doctor-finder-s1-doctors.jpg'
