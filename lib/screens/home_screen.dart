import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:medic_app/network/ads_api.dart';
import 'package:medic_app/network/city_api.dart';
import 'package:medic_app/network/governorate_api.dart';
import 'package:medic_app/network/login_api.dart';
import 'package:medic_app/network/specialties_api.dart';
import 'package:medic_app/screens/booking_screen.dart';
import 'package:medic_app/screens/doctors_search_screen.dart';
import 'package:medic_app/screens/health_monitor_screen.dart';
import 'package:medic_app/screens/lab_screen.dart';
import 'package:medic_app/screens/manage_profile_screen.dart';
import 'package:medic_app/screens/packages_screen.dart';
import 'package:medic_app/screens/wallet_screen.dart';
import 'package:medic_app/widgets/loading_screen.dart';
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
import 'package:loader_overlay/loader_overlay.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  static const id = 'home_screen';

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final List<Widget> _displayScreen = <Widget>[
    const DashBoard(),
    const BookingS(),
    const FollowUpDashboard(),
    const WalletScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserModel>(context);
    var deviceSize = MediaQuery.of(context).size;

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
        centerTitle: true,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Image(
          image: AssetImage('assets/viologo.png'),
          width: 80,
          height: 40,
        ),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: CircleAvatar(
              foregroundImage:
              NetworkImage(Provider.of<UserModel>(context).image),
              radius: 20,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        }),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AlManara.id);
              },
              icon: const Icon(
                Icons.info_outline,
                color: Color(0xFFCBCFD1),
                size: 35,
              ))
        ],
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
                    : Container(
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
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              user.name.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 70,
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(
                          Icons.person_pin,
                          color: Color(0xFF979797),
                          size: 35,
                        ),
                        SizedBox(width: 5.0,),
                        Text(
                          'Profile',
                          style: TextStyle(color: Color(0xFF979797), fontSize: 18),
                        ),
                        SizedBox(width: 50.0,),
                        Icon(Icons.keyboard_arrow_right, color: Color(0xFF979797), size: 50,)
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, ManageProfile.id);
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
                  width: 250,
                  height: 70,
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(
                          Icons.exit_to_app_rounded,
                          color: Color(0xFF979797),
                          size: 35,
                        ),
                        SizedBox(width: 5.0,),
                        Text(
                          'Log Out',
                          style: TextStyle(color: Color(0xFF979797), fontSize: 18),
                        ),
                        SizedBox(width: 50.0,),
                        Icon(Icons.keyboard_arrow_right, color: Color(0xFF979797), size: 50,)
                      ],
                    ),
                    onTap: () async{
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
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
        unselectedLabelStyle: const TextStyle(color: Color(0xFFCBCFD1)),
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: const Color(0xFFCBCFD1),
        showUnselectedLabels: true,
        iconSize: 30,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/home.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/calendar-2.png')),
            label: 'Book Now',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_sharp),
            label: 'Follow Up',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/Group 345.png')),
            label: 'Wallet',
          ),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: _displayScreen.elementAt(_selectedIndex),
    );
  }
}


class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
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
      '\nDoctors',
      // '\nServices',
      '\nAppointments',
      // '\nTestimonials',
      '\nMedication',
      '\nGallery',
      // '\nReach Us',
      // '\nVIO Health',
      '\nHealth Monitor',
      '\nPackages',
      // '\nFollow Up',
      // '\nLab'
    ];
    List icons = [
      ImageIcon(
        const AssetImage('assets/doctor.png'),
        size: 75,
        color: Theme.of(context).primaryColor,
      ),
      // ImageIcon(
      //   const AssetImage('assets/services.png'),
      //   size: 75,
      //   color: Theme.of(context).primaryColor,
      // ),
      ImageIcon(
        const AssetImage('assets/appointment.png'),
        size: 75,
        color: Theme.of(context).primaryColor,
      ),
      // ImageIcon(
      //   const AssetImage('assets/test.png'),
      //   size: 75,
      //   color: Theme.of(context).primaryColor,
      // ),
      ImageIcon(
        const AssetImage('assets/medication.png'),
        size: 75,
        color: Theme.of(context).primaryColor,
      ),
      ImageIcon(
        const AssetImage('assets/Group-1.png'),
        size: 75,
        color: Theme.of(context).primaryColor,
      ),
      // ImageIcon(
      //   const AssetImage('assets/reach-us.png'),
      //   size: 75,
      //   color: Theme.of(context).primaryColor,
      // ),
      // ImageIcon(
      //   const AssetImage('assets/about-us.png'),
      //   size: 75,
      //   color: Theme.of(context).primaryColor,
      // ),
      ImageIcon(
        const AssetImage('assets/health monitor.png'),
        size: 75,
        color: Theme.of(context).primaryColor,
      ),
      ImageIcon(
        const AssetImage('assets/your package.png'),
        size: 75,
        color: Theme.of(context).primaryColor,
      ),
      // ImageIcon(
      //   const AssetImage('assets/follow_up.png'),
      //   size: 75,
      //   color: Theme.of(context).primaryColor,
      // ),
      // ImageIcon(
      //   const AssetImage('assets/health_monitor.png'),
      //   size: 75,
      //   color: Theme.of(context).primaryColor,
      // ),
    ];
    return RefreshIndicator(
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
                height: 60,
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Balance: ${Provider.of<UserModel>(context).balance}',
                        style: const TextStyle(color: Colors.green),
                      ),
                      Text('On Hold: ${Provider.of<UserModel>(context).onHold}',
                          style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 13,
                children: [
                  optioncard(deviceSize, icons[0], options[0], Availability.id,
                      context),
                  optioncard(deviceSize, icons[1], options[1], Appointment.id,
                      context),
                  // optioncard(
                  //     deviceSize, icons[2], options[2], Medication.id, context),
                  optioncard(deviceSize, icons[3], options[3],
                      PastAppointments.id, context),
                  optioncard(deviceSize, icons[4], options[4], HmDashBoard.id,
                      context),
                  optioncard(deviceSize, icons[5], options[5],
                       PackagesScreen.id, context),
                ],
              ),
            ),
          ),
        ],
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
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
          if (option == '\nDoctors') {
            var specialties = await SpecialtiesApi.getSpecialties(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Availability();
            }));
          } else if (option == '\nHealth Monitor') {
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
          } else {
            Navigator.pushNamed(context, screen);
          }
        },
      ),
    );
  }
}

