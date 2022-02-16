import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medic_app/network/medication_api.dart';
import 'package:medic_app/screens/medication_screen.dart';
import 'package:medic_app/widgets/rounded_button.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Column(
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
                    Text('Add drugs one by one',
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                  ],
                ),
              ),
            ),
            TextField(
              controller: name,
              style: Theme.of(context).textTheme.subtitle1,
              decoration: const InputDecoration(
                hintText: 'Name',
              ),
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
                  var status = await MedicationApi.postPrescription(
                      context,
                      widget.appId,
                      name.text,
                      type.text,
                      amount.text,
                      dose.text,
                      duration.text,
                      null);
                  if (status == 200) {
                    if (status == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text("Prescription uploaded successfully"),
                        ),
                      );
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                })
          ],
        ),
      ),
    );
  }
}

class AppId {
  final int appId;

  const AppId(this.appId);
}
