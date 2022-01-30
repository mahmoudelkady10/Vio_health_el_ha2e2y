import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medic_app/model/specialties_model.dart';
import 'package:medic_app/screens/booking_screen.dart';
import 'package:medic_app/screens/doctors_screen.dart';
import 'package:medic_app/screens/health_monitor_screen.dart';
import 'package:medic_app/screens/healthmonitor_history_screen.dart';
import 'package:medic_app/screens/manage_profile_screen.dart';
import 'package:medic_app/screens/medication_screen.dart';
import 'package:medic_app/screens/contact_screen.dart';
import 'package:medic_app/screens/about_us_screen.dart';
import 'package:medic_app/screens/gallery_screen.dart';
import 'package:medic_app/screens/home_screen.dart';
import 'package:medic_app/screens/log_in_screen.dart';
import 'package:medic_app/screens/registration_screen.dart';
import 'package:medic_app/screens/speciality_screen.dart';
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
        ChangeNotifierProvider.value(value: TimesList())
      ],
      child: MaterialApp(
          title: 'My Clinic',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.blue.shade800,
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
            Services.id: (context) => const Services(),
            Testimonials.id: (context) => const Testimonials(),
            AlManara.id: (context) => const AlManara(),
            MyHomePage.id: (context) => const MyHomePage(title: 'VIO Health'),
            WelcomeScreen2.id: (context) => const WelcomeScreen2(),
            WelcomeScreen.id: (context) => const WelcomeScreen(),
            LoginScreen.id: (context) => const LoginScreen(),
            BookingS.id: (context) => const BookingS(),
            Registration.id: (context) => const Registration(),
            ManageProfile.id: (context) => const ManageProfile(),
            WalletScreen.id: (context) => const WalletScreen(),
            VideoAppointment.id: (context) => const VideoAppointment(),
            HealthMonitor.id: (context) => const HealthMonitor(),
            HealthMonitorHistory.id: (context) => const HealthMonitorHistory(),
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
        dynamic response = await LoginApi.getUserInfo(context, token!);
        if (response.toString() != '200') {
          imageCache?.clear();
          SharedPreferences prefs =
          await SharedPreferences.getInstance();
          await prefs.clear();
          await Future.delayed(const Duration(seconds: 2));
          Navigator.pushReplacementNamed(context, WelcomeScreen2.id);
        } else {
          Navigator.pushReplacementNamed(context, MyHomePage.id);
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
              'assets/viologo.png',
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
              width: 100,
              height: 100,
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
            SizedBox(height: deviceSize.height * 0.20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 25.0),
                ),
                Text('WELCOME TO ',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor)),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 25.0),
                ),
                Text('VIO Health.',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor)),
              ],
            ),
            SizedBox(height: deviceSize.height * 0.10),
            Image.asset(
              'assets/viologo.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(
              height: 15,
            ),
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
//'https://images.onhealth.com/images/slideshow/right-doctor-finder-s1-doctors.jpg'
