import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medic_app/model/user_model.dart';
import 'about_us_screen.dart';
import 'contact_screen.dart';

class AlManara extends StatefulWidget {
  const AlManara({Key? key}) : super(key: key);
  static const id = 'almanara_screen';

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<AlManara> createState() => _AlManara();
}

class _AlManara extends State<AlManara> {
  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserModel>(context);
    var deviceSize = MediaQuery.of(context).size;

    List options = ['About Us', 'Contact Us'];
    List icons = [
      ImageIcon(const AssetImage('assets/about-us.png'), size: 75, color: Theme.of(context).primaryColor,),
      ImageIcon(const AssetImage('assets/contact-us.png'), size: 75, color: Theme.of(context).primaryColor,),

    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text(
          'Vio Health',
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 115),
              child: GridView.count(
                crossAxisCount: 1,
                crossAxisSpacing: 0,
                mainAxisSpacing: 30,
                children: [
                  optioncard(
                      deviceSize, icons[0], options[0], AboutUs.id, context),
                  optioncard(
                      deviceSize, icons[1], options[1], ContactUs.id, context),
                ],
              ),
            ),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  SizedBox optioncard(Size deviceSize, ImageIcon icon, String option, String screen,
      BuildContext context) {
    return SizedBox(
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
              contentPadding: const EdgeInsets.symmetric(vertical: 50),
              title: icon,
              subtitle: Text(
                option,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, screen);
        },
      ),
    );
  }
}
