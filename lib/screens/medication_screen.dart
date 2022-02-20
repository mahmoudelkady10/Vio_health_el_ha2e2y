import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medic_app/network/create_appointment_api.dart';
import 'package:medic_app/network/medication_api.dart';
import 'package:expandable/expandable.dart';
import 'package:medic_app/network/appointments_api.dart';
import 'package:medic_app/network/time_slots_api.dart';
import 'package:medic_app/screens/add_medication_screen.dart';
import 'package:medic_app/widgets/rounded_button.dart';
import 'package:medic_app/widgets/unit_request_card.dart';
import 'package:provider/provider.dart';
import 'package:medic_app/model/user_model.dart';

class Medication extends StatefulWidget {
  const Medication({Key? key}) : super(key: key);
  static const id = 'medication_screen';

  @override
  State<Medication> createState() => _MedicationState();
}

class _MedicationState extends State<Medication> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int? userId = Provider.of<UserModel>(context).partnerId;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Choose appointment',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.announcement),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Center(
                        child: Icon(
                      Icons.announcement_outlined,
                      color: Colors.black,
                      size: 50,
                    )),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            'click on the below button to add\nyour own prescription or choose\nany appointment to see your\nprescriptions or add a new one',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor)),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('ok',
                            style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.underline)),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          // add more IconButton
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder(
        future: AppointmentsApi.getAppointments(
            context, userId, Provider.of<UserModel>(context).token),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  if (snapshot.data[index].state == 'done' ||
                      snapshot.data[index].doctor.toString() ==
                          'External Doctor') {
                    return Column(
                      children: [
                        if (snapshot.data[index].state == 'done' ||
                            snapshot.data[index].doctor.toString() ==
                                'External Doctor')
                          GestureDetector(
                            child: AppointmentCard(
                              service: snapshot.data[index].type,
                              doctor: snapshot.data[index].doctor,
                              date: snapshot.data[index].date,
                              showButton: false,
                              showVideoCall: false,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MedicationDetails(
                                            appId: snapshot.data[index].id,
                                          )));
                            },
                          ),
                        const Divider(
                          height: 10,
                          thickness: 5,
                        )
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                });
          } else {
            return const Center(
              child: Text('no appointments found'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              elevation: 10,
              title: const Center(
                  child: Icon(
                Icons.announcement_outlined,
                color: Colors.black,
                size: 50,
              )),
              content: SizedBox(
                width: 200,
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('click confirm to write your\nown prescription\n',
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                    Center(
                      child: TextField(
                        controller: myController,
                        style: Theme.of(context).textTheme.subtitle1,
                        decoration: const InputDecoration(
                          hintText: '         Write the doctor name',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 70,
                      child: RoundedButton(
                        buttonColor: Theme.of(context).primaryColor,
                        buttonText: 'cancel',
                        buttonFunction: () async {
                          Navigator.pushNamed(context, Medication.id);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      height: 70,
                      child: RoundedButton(
                        buttonColor: Theme.of(context).primaryColor,
                        buttonText: 'confirm',
                        buttonFunction: () async {
                          var time = await TimesApi.getTimeSlots(
                              context, DateTime.now(), 19);
                          var status =
                              await CreateAppointmentApi.createAppointment(
                            context,
                            DateTime.now(),
                            19,
                            Provider.of<UserModel>(context, listen: false)
                                .partnerId,
                            3,
                            time.first.id!.toInt(),
                          );
                          if (status == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text("successfully"),
                              ),
                            );
                            var appointmentlast =
                                await AppointmentsApi.getAppointments(
                                    context,
                                    userId,
                                    Provider.of<UserModel>(context,
                                            listen: false)
                                        .token);
                            print(appointmentlast.last.id);
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return MedicationDetails(
                                  appId: appointmentlast.last.id!.toInt());
                            }));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text("Failed"),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
        child: const Icon(Icons.call_to_action_outlined),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

class MedicationDetails extends StatefulWidget {
  const MedicationDetails({Key? key, required this.appId}) : super(key: key);
  final int appId;

  @override
  State<MedicationDetails> createState() => _MedicationDetailsState();
}

class _MedicationDetailsState extends State<MedicationDetails> {
  late File image = File('');
  final picker = ImagePicker();
  int ctImage = 0;
  static dynamic img64;

  void _pickImageCamera() async {
    final pickedImage = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 150,
        maxHeight: 150);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      image = pickedImageFile;
      img64 = base64Encode(pickedImageFile.readAsBytesSync());
    });
    var status = await MedicationApi.postPrescription(
        context, widget.appId, null, null, null, null, null, img64);
    if (status == 200) {
      if (status == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("image uploaded successfully"),
          ),
        );
        Navigator.pushReplacementNamed(context, Medication.id);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Failed to Upload your image"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Prescriptions',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.add_a_photo_outlined),
              onPressed: () {
                _pickImageCamera();
              },
            ),
          ),
          // add more IconButton
        ],
      ),
      body: FutureBuilder(
        future: MedicationApi.getMedication(context, widget.appId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  if (snapshot.data[index].image == null) {
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Card(
                        child: ExpandablePanel(
                            header: Padding(
                              padding: const EdgeInsets.only(top: 9.0),
                              child: Text(snapshot.data[index].medicineId,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.black)),
                            ),
                            collapsed: const SizedBox.shrink(),
                            expanded: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 35.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Name:',
                                          style:
                                              TextStyle(color: Colors.black)),
                                      Text(snapshot.data[index].medicineId,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 35.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Type:',
                                          style:
                                              TextStyle(color: Colors.black)),
                                      Text(snapshot.data[index].medicineFormId,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 35.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Amount/dose:',
                                          style:
                                              TextStyle(color: Colors.black)),
                                      Text(snapshot.data[index].dosageQuantity,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 35.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Doses/day:',
                                          style:
                                              TextStyle(color: Colors.black)),
                                      Text(snapshot.data[index].frequency,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 35.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Duration: ',
                                          style:
                                              TextStyle(color: Colors.black)),
                                      Text(
                                          '${snapshot.data[index].days} Day(s)',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Card(
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              child: Center(
                                child: Image.network(
                                    snapshot.data[index].image.toString()),
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16.0),
                                topRight: Radius.circular(16.0),
                                bottomLeft: Radius.circular(16.0),
                                bottomRight: Radius.circular(16.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                });
          } else {
            return Center(
              child: SizedBox(
                width: 350,
                height: 80,
                child: Card(
                  child: Column(
                    children: [
                      const Text('Instructions',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                          'click on the below button to add prescription\nor use the upper camera icon to add image',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return AddMedication(appId: widget.appId);
          }));
        },
        child: const Icon(Icons.article_outlined),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

class AppId {
  final int appId;

  const AppId(this.appId);
}
