import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({Key? key}) : super(key: key);
  static const String id = 'contact_us';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 80),
            child: Text('Contact Us', style: TextStyle( fontWeight: FontWeight.bold),),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 180),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 15,
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('hello@vio.health'),
                    onTap: () async {
                      await _launchURL1();
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.phone_android_rounded),
                    title: const Text('+201212666672'),
                    onTap: () async {
                      await _launchURL();
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  _launchURL() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '+201212666672',
    );
    await launch(launchUri.toString());
  }
  _launchURL1() async {
    final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'hello@vio.health');
    launch(emailLaunchUri.toString());
  }
}