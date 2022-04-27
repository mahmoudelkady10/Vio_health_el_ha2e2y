import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medic_app/network/medication_api.dart';
import 'package:medic_app/screens/medication_screen.dart';
import 'package:medic_app/widgets/loading_screen.dart';
import 'package:medic_app/widgets/rounded_button.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:flutter_typeahead/cupertino_flutter_typeahead.dart';

class AddMedication extends StatefulWidget {
  const AddMedication({Key? key, required this.appId}) : super(key: key);
  final int appId;
  static const id = 'add_medication_screen';

  @override
  State<AddMedication> createState() => _AddMedicationState();
}

class _AddMedicationState extends State<AddMedication> {
  TextEditingController name = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController dose = TextEditingController();
  TextEditingController duration = TextEditingController();
  List<String> medicineList = [];

  Future<void> getData() async{
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();
    File file;
    file = File("${directory!.path}/medicine.json");
    final String response = await file.readAsString();
    final data = await json.decode(response);
    List<String> temp = [];
    for (var index in data){
      temp.add(index["name"].toString().toLowerCase());
    }
    setState(() {
      medicineList = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void _clear() {
    setState(() {
      name.text = '';
      type.text = '';
      amount.text = '';
      dose.text = '';
      duration.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(30),
          child: Text('Add Your Prescription',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Theme.of(context).primaryColor,

      ),
      body: LoaderOverlay(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: ListView(
            children: [
              SizedBox(
                width: 200,
                height: 50,
                child: Card(
                  child: Column(
                    children: [
                      const Text('Instructions',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB22234))),
                      const SizedBox(
                        height: 5,
                      ),
                      Text('Add prescription info below',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                    ],
                  ),
                ),
              ),
              const Text('Start Typing medication name...', style: TextStyle(color: Colors.black26),),
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    print(medicineList);
                    return const Iterable<String>.empty();
                  }
                  return medicineList.where((String option) {
                    return option.contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) {
                    name.text = selection;
                },
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: type,
                style: Theme.of(context).textTheme.subtitle1,
                decoration: const InputDecoration(
                  hintText: 'Type',
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: amount,
                style: Theme.of(context).textTheme.subtitle1,
                decoration: const InputDecoration(
                  hintText: 'Amount/dose',
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: dose,
                style: Theme.of(context).textTheme.subtitle1,
                decoration: const InputDecoration(
                  hintText: 'Doses/day',
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: duration,
                style: Theme.of(context).textTheme.subtitle1,
                decoration: const InputDecoration(
                  hintText: 'Duration',
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              RoundedButton(
                  buttonText: 'Submit',
                  buttonColor: Theme.of(context).primaryColor,
                  buttonFunction: () async {
                    if (name.text != '' &&
                        type.text != '' &&
                        amount.text != '' &&
                        dose.text != '' &&
                        duration.text != '') {
                      context.loaderOverlay.show(widget: const LoadingScreen());
                      var status = await MedicationApi.postPrescription(
                          context,
                          widget.appId,
                          name.text,
                          type.text,
                          amount.text,
                          dose.text,
                          duration.text,
                          null);
                      context.loaderOverlay.hide();
                      if (status == 200) {
                        if (status == 200) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text("Prescription uploaded successfully"),
                            ),
                          );
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return MedicationDetails(appId: widget.appId);
                          }));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("Failed to Upload your prescription"),
                            ),
                          );
                        }
                      }
                      _clear();
                    } else {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                  elevation: 10,
                                  title: const Center(
                                      child: Icon(
                                    Icons.announcement_outlined,
                                    color: Color(0xFFB22234),
                                    size: 50,
                                  )),
                                  content: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: const [
                                        Text('Please fill out all information'),
                                      ]),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('ok',
                                          style: TextStyle(
                                              color: Colors.black,
                                              decoration:
                                                  TextDecoration.underline)),
                                    )
                                  ]));
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class AppId {
  final int appId;

  const AppId(this.appId);
}
