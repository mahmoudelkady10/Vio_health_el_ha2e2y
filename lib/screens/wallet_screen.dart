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
      body: Center(
        child: SizedBox(
          width: deviseSize.width * 0.9,
          height: deviseSize.height * 0.3,
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            semanticContainer: false,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFA095C1),
                    Color(0xFF6b6187),
                    Color(0xFF593793),
                    Color(0xFF593793),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Available Balance',
                          style:
                          TextStyle(color: Color(0xFFCBCFD1), fontSize: 15),
                        ),
                        Text(
                          '${user.balance} EGP',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const Text(
                          'ON HOLD',
                          style:
                          TextStyle(color: Color(0xFFCBCFD1), fontSize: 12),
                        ),
                        Text(
                          '${user.onHold} EGP',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Image(
                          image: AssetImage('assets/walleticon.png'),
                          height: 60,
                          width: 60,
                        ),
                        const SizedBox(
                          height: 45,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 35.0, top: 15.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFcf4aff),
                                  Color(0xFF9c13cf),
                                  Color(0xFF9d00d6),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'Add Amount to be added to account',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color(0xFF979797),
                                              fontSize: 13),
                                        ),
                                        content: ValidatedTextField(
                                            labelText: "Amount",
                                            hintText:
                                            "Enter top up amount (EGP)",
                                            fieldController: topupController,
                                            keyboardType: TextInputType.number),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Cancel', style: TextStyle(color: Theme.of(context).primaryColor),)),
                                          TextButton(
                                              onPressed: () async {
                                                var url = await WalletApi.topUp(
                                                    context,
                                                    user.uid,
                                                    topupController.text,
                                                    user.token);
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                          return PaymentScreen(
                                                            url_: url.toString(),
                                                          );
                                                        }));
                                              },
                                              child: Text('Top up', style: TextStyle(color: Theme.of(context).primaryColor),)),
                                        ],
                                      );
                                    });
                              },
                              child: const Text(
                                'TOP UP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              style: ButtonStyle(
                                  alignment: Alignment.center,
                                  fixedSize: MaterialStateProperty.all(
                                      Size(100, deviseSize.height * 0.056))),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
