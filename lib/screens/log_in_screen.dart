import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:medic_app/network/login_api.dart';
import 'package:medic_app/network/medication_api.dart';
import 'package:medic_app/screens/home_screen.dart';
import 'package:medic_app/screens/registration_screen.dart';
import 'package:medic_app/widgets/rounded_button.dart';
import 'package:medic_app/widgets/validated_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _hidePassword = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: const Text('Login'),
      // ),
      body: LoaderOverlay(
        // overlayWidget: ,
        child: ListView(
          children: [
            SizedBox(height: deviceSize.height * 0.1),
            Center(
                child: Image.asset(
              'assets/viologo.png',
              width: 250,
              height: 200,
            )),
            SizedBox(
                height: deviceSize.height * 0.05,
                width: deviceSize.width * 0.01),
            ValidatedTextField(
              fieldController: emailController,
              hintText: 'E-mail',
              labelText: 'Enter Email',
              fieldIcon: Icons.mail,
              keyboardType: TextInputType.emailAddress,
            ),
            ValidatedTextField(
              fieldController: passwordController,
              hintText: 'Password',
              labelText: 'Password',
              fieldIcon: Icons.lock,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _hidePassword = !_hidePassword;
                    });
                  },
                  icon: Icon(
                      _hidePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey.shade400)),
              fieldObscure: _hidePassword,
            ),
            SizedBox(height: deviceSize.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: InkWell(
                    onTap: () async {
                      String url = 'https://techno.clinic/web/reset_password?';
                      await launch(url);
                    },
                    child: Text(
                      'Forgot password ?',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: deviceSize.height * 0.04),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.1),
              child: RoundedButton(
                buttonText: 'Log In',
                buttonColor: Theme.of(context).primaryColor,
                buttonFunction: () async {
                  context.loaderOverlay.show(
                      widget: const CircularProgressIndicator(
                    strokeWidth: 2,
                  ));
                  dynamic status = await LoginApi.login(context,
                      emailController.text.trim(), passwordController.text);
                  context.loaderOverlay.hide();
                  if (status != 200) {
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
                            Text('Wrong Email or Password!'),
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
                  } else {
                    var meds = await MedicationApi.getMedicineList(context);
                    File file;
                    Directory? directory = Platform.isAndroid
                        ? await getExternalStorageDirectory()
                        : await getApplicationSupportDirectory();
                    if (await File("${directory!.path}/medicine.json").exists()){
                      file = File("${directory.path}/medicine.json");

                    } else {
                      file = await File("${directory.path}/medicine.json").create();
                    }
                    await file.writeAsString(jsonEncode(meds));
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString("med_last_update", DateTime.now().toString());
                    prefs.setBool("isLoggedIn", true);
                    prefs.setString('token',
                        Provider.of<UserModel>(context, listen: false).token);
                    Navigator.pushReplacementNamed(context, MyHomePage.id);
                  }
                },
              ),
            ),
            ListTile(
              title: Text(
                'Create Account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  decoration: TextDecoration.underline,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, Registration.id);
              },
            )
          ],
        ),
      ),
    );
  }
}

// RichText(
// text: TextSpan(
// text: 'Forgot Password',
// recognizer: TapGestureRecognizer()
// ..onTap = () => print('Go to Forget Password Screen'),
// style: const TextStyle(
// color: Colors.blue, decoration: TextDecoration.underline),
// ),
// ),
