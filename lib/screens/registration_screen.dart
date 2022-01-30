import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medic_app/network/registration_api.dart';
import 'package:medic_app/screens/log_in_screen.dart';
import 'package:medic_app/widgets/rounded_button.dart';
import 'package:medic_app/widgets/validated_text_field.dart';
import 'package:gender_picker/gender_picker.dart';
import 'package:gender_picker/source/enums.dart';

import '../constant.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);
  static const id = 'register_screen';
  static TextEditingController emailController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();
  static TextEditingController userNameController = TextEditingController();
  static TextEditingController bloodGroupController = TextEditingController();
  static TextEditingController weightController = TextEditingController();
  static String? _gender = 'male';
  static DateTime? dateOfBirth;

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  void _showDatePicker(ctx) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 500,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  SizedBox(
                    height: 400,
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: (val) {
                          setState(() {
                            Registration.dateOfBirth = val;
                          });
                        }),
                  ),

                  // Close the modal
                  CupertinoButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(ctx).pop(),
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    Icon blood = const Icon(Icons.bloodtype, color: Colors.grey,);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 45.0),
        child: ListView(
          children: [
            Text('Create Account',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor)),
            const SizedBox(
              height: 25,
            ),
            ValidatedTextField(
              fieldController: Registration.userNameController,
              hintText: 'Full Name',
              labelText: 'Full Name',
              fieldIcon: Icons.person,
              fieldValidator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                Pattern pattern = r"^[a-z A-Z]+$";
                RegExp regex = RegExp(pattern.toString());
                if (!regex.hasMatch(value)) {
                  return 'Enter a valid Name';
                }
                return null;
              },
            ),
            ValidatedTextField(
              fieldController: Registration.emailController,
              hintText: 'Enter Email',
              labelText: 'Enter Email',
              fieldIcon: Icons.mail,
              fieldValidator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                Pattern pattern =
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                RegExp regex = RegExp(pattern.toString());
                if (!regex.hasMatch(value.toLowerCase())) {
                  return 'Enter a valid email address';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            ValidatedTextField(
              fieldController: Registration.passwordController,
              hintText: 'Password',
              labelText: 'Password',
              fieldObscure: true,
              fieldIcon: Icons.lock,
              fieldValidator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                Pattern pattern =
                    r"^([0-9]|[A-Za-z])*(.*[A-Za-z]*)(?=.*\d*)[A-Za-z\d*]{6,}$";

                RegExp regex = RegExp(pattern.toString());
                if (!regex.hasMatch(value)) {
                  return 'Enter a valid Password (6 or more characters)';
                }
                return null;
              },
            ),
            ValidatedTextField(
              fieldController: Registration.weightController,
              hintText: 'Weight(KG.)',
              labelText: 'Weight(KG.)',
              fieldIcon: Icons.accessibility,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
              child: Card(
                semanticContainer: false,
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonFormField(
                  icon: blood,
                  validator: (value) =>
                      value == null ? 'Please provide Blood Group' : null,
                  onChanged: (val) {
                    Registration.bloodGroupController.text =
                        val.toString().toLowerCase();
                  },
                  decoration: kTextFieldDecoration,
                  hint: const Text("Blood Group"),
                  items: const [
                    DropdownMenuItem(
                      child: Text("A+"),
                      value: "A+",
                    ),
                    DropdownMenuItem(
                      child: Text("B+"),
                      value: "B+",
                    ),
                    DropdownMenuItem(
                      child: Text("O+"),
                      value: "O+",
                    ),
                    DropdownMenuItem(
                      child: Text("AB+"),
                      value: "AB+",
                    ),
                    DropdownMenuItem(
                      child: Text("A-"),
                      value: "A-",
                    ),
                    DropdownMenuItem(
                      child: Text("B-"),
                      value: "B-",
                    ),
                    DropdownMenuItem(
                      child: Text("O-"),
                      value: "O-",
                    ),
                    DropdownMenuItem(
                      child: Text("AB-"),
                      value: "AB-",
                    ),
                  ],
                ),
              ),
            ),
            const Text(
              'Select your Date of Birth',
              textAlign: TextAlign.center,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
              child: SizedBox(
                height: 50,
                child: Card(
                  semanticContainer: false,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: CupertinoButton(
                    padding: EdgeInsetsDirectional.zero,
                    child: Registration.dateOfBirth != null
                        ? Text(DateFormat('yyyy-MM-dd')
                            .format(Registration.dateOfBirth!))
                        : const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Icon(
                                Icons.calendar_today_rounded,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                    onPressed: () {
                      _showDatePicker(context);
                    },
                  ),
                ),
              ),
            ),
            GenderPickerWithImage(
              showOtherGender: false,
              verticalAlignedText: false,
              selectedGender: Gender.Male,
              selectedGenderTextStyle: const TextStyle(
                  color: Color(0xFF8b32a8), fontWeight: FontWeight.bold),
              unSelectedGenderTextStyle: const TextStyle(
                  color: Colors.black54, fontWeight: FontWeight.normal),
              onChanged: (Gender? gender) {
                List genderS = gender.toString().split('.');
                Registration._gender = genderS[1].toString().toLowerCase();
                print(Registration.emailController.text);
              },
              equallyAligned: true,
              animationDuration: const Duration(milliseconds: 300),
              isCircular: true,
              // default : true,
              opacityOfGradient: 0.4,
              padding: const EdgeInsets.all(3),
              size: 50, //default : 40
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.1),
              child: RoundedButton(
                  buttonText: 'Register',
                  buttonColor: Theme.of(context).primaryColor,
                  buttonFunction: () async {
                    var status = await RegisterApi.register(
                        context,
                        Registration.emailController.text,
                        Registration.userNameController.text,
                        Registration.passwordController.text,
                        Registration._gender,
                        Registration.dateOfBirth!,
                        Registration.weightController.text,
                        Registration.bloodGroupController.text);
                    int statusCode =
                        json.decode(status.body)['result']['status'];
                    if (statusCode != 200) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Center(
                              child: Icon(
                            Icons.warning,
                            color: Theme.of(context).primaryColor,
                            size: 50,
                          )),
                          content: Text(json
                              .decode(status.body)['result']['message']
                              .toString()),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('ok'),
                            )
                          ],
                        ),
                      );
                    } else if (statusCode == 200) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Center(
                              child: Icon(
                            Icons.thumb_up,
                            color: Theme.of(context).primaryColor,
                            size: 50,
                          )),
                          content: const Text(
                              'Registration successful use information to log in'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, LoginScreen.id);
                              },
                              child: const Text('ok'),
                            )
                          ],
                        ),
                      );
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
