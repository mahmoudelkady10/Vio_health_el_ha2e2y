import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:medic_app/network/city_api.dart';
import 'package:medic_app/network/governorate_api.dart';
import 'package:medic_app/network/login_api.dart';
import 'package:medic_app/network/specialties_api.dart';
import 'package:medic_app/screens/booking_screen.dart';
import 'package:medic_app/screens/doctors_search_screen.dart';
import 'package:medic_app/screens/health_monitor_screen.dart';
import 'package:medic_app/screens/healthmonitor_history_screen.dart';
import 'package:medic_app/screens/manage_profile_screen.dart';
import 'package:medic_app/screens/packages_screen.dart';
import 'package:medic_app/screens/wallet_screen.dart';
import 'package:medic_app/widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/screens/speciality_screen.dart';
import 'package:medic_app/screens/almanara_screen.dart';
import 'package:medic_app/screens/testimonials_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'almanara_screen.dart';
import 'appointment_screen.dart';
import 'doctors_screen.dart';
import 'log_in_screen.dart';
import 'medication_screen.dart';
import 'gallery_screen.dart';
import 'reach_us_screen.dart';
import 'follow_up_screen.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  static const id = 'home_screen';

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _refresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    dynamic response = await LoginApi.getUserInfo(context, token!);
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserModel>(context);
    var deviceSize = MediaQuery.of(context).size;

    List options = [
      '\nDoctor',
      '\nServices',
      '\nAppointments',
      '\nTestimonials',
      '\nMedication',
      '\nGallery',
      '\nFollowUp',
      '\nTechno Information',
      '\nHealth Monitor',
      '\nPackages',
    ];
    List icons = [
      const ImageIcon(
        AssetImage('assets/doctor.png'),
        size: 75,
        color: Color(0xFFB22234),
      ),
      const ImageIcon(
        AssetImage('assets/services.png'),
        size: 75,
        color: Color(0xFFB22234),
      ),
      const ImageIcon(
        AssetImage('assets/appointment.png'),
        size: 75,
        color: Color(0xFFB22234),
      ),
      const ImageIcon(
        AssetImage('assets/test.png'),
        size: 75,
        color: Color(0xFFB22234),
      ),
      const ImageIcon(
        AssetImage('assets/medication.png'),
        size: 75,
        color: Color(0xFFB22234),
      ),
      const ImageIcon(
        AssetImage('assets/gallery.png'),
        size: 75,
        color: Color(0xFFB22234),
      ),
      const ImageIcon(
        AssetImage('assets/follow_up.png'),
        size: 75,
        color: Color(0xFFB22234),
      ),
      const ImageIcon(
        AssetImage('assets/about-us.png'),
        size: 75,
        color: Color(0xFFB22234),
      ),
      const ImageIcon(
        AssetImage('assets/health_monitor.png'),
        size: 75,
        color: Color(0xFFB22234),
      ),
      const ImageIcon(
        AssetImage('assets/packages.png'),
        size: 75,
        color: Color(0xFFB22234),
      ),
    ];
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
        ),
      ),
      drawer: Drawer(
        elevation: 56.0,
        child: ListView(
          children: [
            const SizedBox(
              height: 150,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (user.image.toString() != "")
                    ? Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              image: NetworkImage(user.image.toString()),
                              fit: BoxFit.fill),
                        ),
                      )
                    : const Icon(Icons.person),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              user.name.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            const SizedBox(
              height: 30,
            ),
            ListTile(
              leading: const Icon(
                Icons.account_balance_wallet_outlined,
                color: Color(0xFFB22234),
                size: 40,
              ),
              title: const Text(
                'Wallet',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Color(0xFFB22234)),
              ),
              onTap: () {
                Navigator.pushNamed(context, WalletScreen.id);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 70,
                  child: RoundedButton(
                      buttonColor: Colors.white,
                      buttonText: 'Edit Profile',
                      textColor: Theme.of(context).primaryColor,
                      buttonFunction: () {
                        Navigator.pushNamed(context, ManageProfile.id);
                      }),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 70,
                  child: RoundedButton(
                    buttonColor: Theme.of(context).primaryColor,
                    buttonText: 'Log Out',
                    buttonFunction: () async {
                      imageCache?.clear();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.clear();
                      await Future.delayed(const Duration(seconds: 2));

                      Navigator.of(context).pushAndRemoveUntil(
                        // the new route
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const LoginScreen(),
                        ),

                        // this function should return true when we're done removing routes
                        // but because we want to remove all other screens, we make it
                        // always return false
                        (Route route) => false,
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),

      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                SizedBox(
                  width: deviceSize.width,
                  height: 80,
                  child: Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Balance: ${Provider.of<UserModel>(context).balance}',
                          style: const TextStyle(color: Colors.green),
                        ),
                        Text(
                            'On Hold: ${Provider.of<UserModel>(context).onHold}',
                            style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 13,
                  children: [
                    optioncard(deviceSize, icons[0], options[0],
                        DoctorSearch.id, context),
                    optioncard(
                        deviceSize, icons[1], options[1], Services.id, context),
                    optioncard(deviceSize, icons[2], options[2], Appointment.id,
                        context),
                    optioncard(deviceSize, icons[3], options[3],
                        Testimonials.id, context),
                    optioncard(deviceSize, icons[4], options[4], Medication.id,
                        context),
                    optioncard(deviceSize, icons[5], options[5],
                        PastAppointments.id, context),
                    optioncard(
                        deviceSize, icons[6], options[6], FollowUp.id, context),
                    optioncard(
                        deviceSize, icons[7], options[7], AlManara.id, context),
                    optioncard(deviceSize, icons[8], options[8],
                        HealthMonitor.id, context),
                    optioncard(deviceSize, icons[9], options[9],
                        PackagesScreen.id, context),
                  ],
                ),
              ),
            ),
            BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: FloatingActionButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        Navigator.pushNamed(context, BookingS.id);
                      },
                      child: const Text('Book an Appointment'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  SizedBox optioncard(Size deviceSize, ImageIcon icon, String option,
      String screen, BuildContext context) {
    return SizedBox(
      height: deviceSize.height * 0.35,
      width: deviceSize.width * 0.31,
      child: GestureDetector(
        child: Center(
          child: Card(
            elevation: 10,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(35.0),
              title: icon,
              subtitle: Text(
                option,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: Theme.of(context).primaryColor),
              ),
            ),
          ),
        ),
        onTap: () async {
          //   if (option == '\nDoctors') {
          //     await SpecialtiesApi.getSpecialties(context);
          //     Navigator.pushNamed(context, screen);
          if (option == '\nHealth Monitor') {
            const CHANNEL = 'com.example.viohealth/channels';
            const platform = MethodChannel(CHANNEL);
            try {
              var temp =
                  await platform.invokeMethod('getData', <String, dynamic>{
                'key': "spo2",
                'file': "Data",
              });
              print(temp);
            } on PlatformException catch (e) {
              print(e.message);
            }
            Navigator.pushNamed(context, screen);
          } else if (option == '\nDoctor') {
            var governorate = await GovernorateApi.getGovernorate(context);
            var city = await CityApi.getCity(context);
            var specialty = await SpecialtiesApi.getSpecialties(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DoctorSearch(
                      governorate: governorate,
                      city: city,
                      specialty: specialty);
                },
              ),
            );
          } else {
            Navigator.pushNamed(context, screen);
          }
        },
      ),
    );
  }
}
