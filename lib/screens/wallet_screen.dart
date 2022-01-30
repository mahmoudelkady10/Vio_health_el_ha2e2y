import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/network/login_api.dart';
import 'package:medic_app/network/wallet_api.dart';
import 'package:medic_app/screens/home_screen.dart';
import 'package:medic_app/widgets/validated_text_field.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);
  static const id = 'wallet_screen';

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserModel>(context);
    var topupController = TextEditingController();
    var deviseSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: SizedBox(
          width: deviseSize.width * 0.8,
          height: deviseSize.height * 0.4,
          child: Stack(
            children: [
              Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                semanticContainer: false,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Text('Balance: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Theme.of(context).primaryColor),
                                textAlign: TextAlign.left),
                          ),
                        ),
                        ListTile(
                          title: const Text(
                            'EGP',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Text(user.balance.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.black),
                              textAlign: TextAlign.center),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Text('On Hold: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Theme.of(context).primaryColor),
                                textAlign: TextAlign.left),
                          ),
                        ),
                        ListTile(
                          title: const Text(
                            'EGP',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Text(user.onHold.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.black),
                              textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Icon(
                              Icons.monetization_on,
                              size: 40,
                            ),
                            content: ValidatedTextField(
                                fieldIcon: Icons.attach_money,
                                labelText: "Amount",
                                hintText: "Enter top up amount",
                                fieldController: topupController,
                                keyboardType: TextInputType.number),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel')),
                              TextButton(
                                  onPressed: () async{
                                    var url = await WalletApi.topUp(context, user.uid,
                                        topupController.text, user.token);
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return PaymentScreen(
                                        url_: url.toString(),
                                      );
                                    }));
                                  },
                                  child: const Text('Top up')),
                            ],
                          );
                        });
                  },
                  child: const Text(
                    'TOP UP',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor),
                      side: MaterialStateProperty.all(
                          const BorderSide(style: BorderStyle.solid)),
                      alignment: Alignment.bottomCenter,
                      fixedSize: MaterialStateProperty.all(Size(
                          deviseSize.width * 0.78, deviseSize.height * 0.056))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key? key, this.url_}) : super(key: key);
  static const id = 'payment_screen';
  final String? url_;

  @override
  Widget build(BuildContext context) {
    final flutterWebViewPlugin = FlutterWebviewPlugin();
    flutterWebViewPlugin.onUrlChanged.listen((String url) async {
      print(url);
      if (url.contains('success=true')) {
        FlutterWebviewPlugin().close();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Top Up successful!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');
        int response = await LoginApi.getUserInfo(context, token!);
        if (response != 200) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Center(
                  child: Icon(
                Icons.warning,
                color: Colors.red,
                size: 50,
              )),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text('User logged in on another device!'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('ok',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline)),
                )
              ],
            ),
          );
          Navigator.pushReplacementNamed(context, WelcomeScreen2.id);
        } else {
          Navigator.pushReplacementNamed(context, MyHomePage.id);
        }
      } else if (url.contains('success=false')) {
        FlutterWebviewPlugin().close();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Top Up failed!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pushReplacementNamed(context, MyHomePage.id);
      }
    });
    flutterWebViewPlugin.onBack.listen((event) {
      Navigator.pop(context);
    });
    return WebviewScaffold(
      url: url_!,
      withZoom: true,
      enableAppScheme: true,
      withLocalStorage: true,
      appBar: AppBar(
        title: const Text('Top Up'),
      ),
      initialChild: Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
