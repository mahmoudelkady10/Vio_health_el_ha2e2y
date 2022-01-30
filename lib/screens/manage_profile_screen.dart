import 'dart:typed_data';
import 'dart:io';
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:gender_picker/gender_picker.dart';
import 'package:gender_picker/source/enums.dart';

import 'package:flutter/cupertino.dart';
import 'dart:core';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/network/edit_profile_api.dart';
import 'package:medic_app/network/login_api.dart';
import 'package:medic_app/widgets/rounded_button.dart';
import 'package:medic_app/widgets/validated_text_field.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constant.dart';
import 'home_screen.dart';

// enum Gender { male, female }

class ManageProfile extends StatefulWidget {
  const ManageProfile({Key? key}) : super(key: key);
  static String id = 'profile_screen';

  @override
  _ManageProfileState createState() => _ManageProfileState();
}

class _ManageProfileState extends State<ManageProfile> {
  Gender? _gender = Gender.Male;
  late String gender;
  var firstNameController = TextEditingController();
  var emailController = TextEditingController();
  var bloodGroupController = TextEditingController();
  var weightController = TextEditingController();
  var img64Controller = TextEditingController();
  static File? _image;
  static String? img64;
  static final ImagePicker _picker = ImagePicker();

  Future<void> _img_from_camera(context) async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    img64Controller.text = base64Encode(File(image!.path).readAsBytesSync());
    setState(() {
      _image = File(image.path);
    });
  }

  Future<void> _img_from_gallery(context) async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    img64Controller.text = base64Encode(File(image!.path).readAsBytesSync());
    setState(() {
      _image = File(image.path);
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: Text('Gallery'),
                    onTap: () async {
                      await _img_from_gallery(context);
                      imageCache?.clear();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () async {
                    await _img_from_camera(context);
                    imageCache?.clear();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    var userData = Provider.of<UserModel>(context);
    firstNameController.text = userData.name!;
    emailController.text = userData.email!;
    bloodGroupController.text = userData.bloodGroup!;
    weightController.text = userData.weight!;
    gender = userData.gender!;
    img64 = img64Controller.text;
    bool showSpinner = false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Profile'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
          child: ListView(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    if (_image == null)
                      GestureDetector(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                    image:
                                        NetworkImage(userData.image.toString()),
                                    fit: BoxFit.fill),
                              ),
                            )
                          ],
                        ),
                        onTap: () => _showPicker(context),
                      ),
                    if (_image != null)
                      GestureDetector(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                    image: FileImage(File(_image!.path)),
                                    fit: BoxFit.fill),
                              ),
                            )
                          ],
                        ),
                        onTap: () => _showPicker(context),
                      ),
                    ValidatedTextField(
                      fieldController: firstNameController,
                      labelText: 'Full Name',
                      hintText: 'Enter your name',
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
                      fieldController: emailController,
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      fieldValidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 8.0),
                      child: Card(
                        semanticContainer: false,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: DropdownButtonFormField(
                          validator: (value) => value == null
                              ? 'Please provide Blood Group'
                              : null,
                          onChanged: (val) {
                            bloodGroupController.text =
                                val.toString().toLowerCase();
                          },
                          decoration: kTextFieldDecoration,
                          hint: Text(bloodGroupController.text),
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
                    ValidatedTextField(
                      fieldController: weightController,
                      labelText: 'Weight(Kg)',
                      hintText: 'Enter weight in Kg',
                      fieldValidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    GenderPickerWithImage(
                      showOtherGender: false,
                      verticalAlignedText: false,
                      selectedGender: _gender.toString() == 'male'
                          ? Gender.Male
                          : Gender.Female,
                      selectedGenderTextStyle: const TextStyle(
                          color: Color(0xFF8b32a8),
                          fontWeight: FontWeight.bold),
                      unSelectedGenderTextStyle: const TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.normal),
                      onChanged: (Gender? gender) {
                        _gender = gender;
                      },
                      equallyAligned: true,
                      animationDuration: const Duration(milliseconds: 300),
                      isCircular: true,
                      // default : true,
                      opacityOfGradient: 0.4,
                      padding: const EdgeInsets.all(3),
                      size: 50, //default : 40
                    ),
                    RoundedButton(
                      buttonFunction: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            showSpinner = true;
                          });
                          String gender =
                              _gender == Gender.Male ? 'male' : 'female';
                          var response = await EditProfileApi.editProfile(
                              context,
                              userData.partnerId!,
                              firstNameController.text,
                              emailController.text,
                              bloodGroupController.text,
                              weightController.text,
                              gender,
                              img64Controller.text);
                          int statusCode =
                              json.decode(response.body)['result']['status'];
                          print(response.body);
                          if (statusCode == 200) {
                            imageCache?.clear();
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String? token = prefs.getString('token');
                            int status = await LoginApi.getUserInfo(
                                context, token!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text("Profile Updated"),
                              ),
                            );
                            Navigator.pushReplacementNamed(
                                context, MyHomePage.id);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text("Profile Update Failed!"),
                              ),
                            );
                            Navigator.pushReplacementNamed(
                                context, MyHomePage.id);
                          }

                          setState(() {
                            showSpinner = false;
                          });
                        }
                      },
                      buttonText: 'Save',
                    ),
                    RoundedButton(
                      buttonFunction: () {
                        Navigator.pop(context);
                      },
                      buttonText: 'Cancel',
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
