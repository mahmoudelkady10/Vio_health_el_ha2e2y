import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medic_app/widgets/rounded_button.dart';
import 'package:url_launcher/url_launcher.dart';

class Location extends StatefulWidget {
  const Location({Key? key}) : super(key: key);
  static const id = 'reach_us_screen';

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 85),
          child: Text("Reach Us", style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        backgroundColor: Theme
            .of(context)
            .primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 110),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
            Image.asset('assets/map.png'),
        const SizedBox(
          height: 2,
        ),
        SizedBox(
          width: 325,
          height: 50,
          child: FloatingActionButton(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            backgroundColor: Theme
                .of(context)
                .primaryColor,
            onPressed: () {
              _launchURL();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.assistant_direction_rounded, color: Colors.white,),
               SizedBox(
                width: 4,
               ),
                Text('Get Directions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Card(
            child: ListTile(
                title: Text('Our Location',style: TextStyle(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0),textAlign: TextAlign.center,),
                subtitle: const Text(
                '171 Tahrir St - DownTown - 15113 - Cairo - Egypt',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0),textAlign: TextAlign.center),
          ),
        ),
        ),
        ],
    ),
      )
    ,
    );
  }

  _launchURL() async {
    const url = 'https://www.google.com/maps/place/VIO+Health/@30.0446584,31.2382948,18z/data=!3m1!4b1!4m5!3m4!1s0x1458413cc3f484a9:0x749fa0d5b4065cb1!8m2!3d30.0446584!4d31.2389149';
    launch(url);
  }
}
// FlatButton(
// onPressed: () {
// setState(() {
// _launchURL();
// });
//},
