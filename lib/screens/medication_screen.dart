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
import 'package:medic_app/widgets/loading_screen.dart';
import 'package:medic_app/widgets/rounded_button.dart';
import 'package:medic_app/widgets/unit_request_card.dart';
import 'package:provider/provider.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:loader_overlay/loader_overlay.dart';

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
                              doctorName: snapshot.data[index].doctorName == false? null: snapshot.data[index].doctorName,
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
            builder: (_) => LoaderOverlay(
              child: AlertDialog(
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
                          buttonFunction: () {
                            Navigator.pop(context, Medication.id);
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
                            context.loaderOverlay.show(widget: const LoadingScreen());
                            var time = await TimesApi.getTimeSlots(
                                context, DateTime.now(), 19, 1);
                            var status =
                                await CreateAppointmentApi.createAppointment(
                              context,
                              DateTime.now(),
                              19,
                              Provider.of<UserModel>(context, listen: false)
                                  .partnerId,
                              3,
                              time.first.id!.toInt(),
                                  myController.text,
                                  1
                            );
                            context.loaderOverlay.hide();
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
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

class MedicationImage extends StatefulWidget {
  const MedicationImage({Key? key, required this.appId}) : super(key: key);
  final int appId;

  @override
  State<MedicationImage> createState() => _MedicationImageState();
}

class _MedicationImageState extends State<MedicationImage> {
  dynamic image;
  final picker = ImagePicker();
  int ctImage = 0;
  static dynamic img64;

  void _pickImageCamera() async {
    final pickedImage = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      image = pickedImageFile;
      img64 = base64Encode(pickedImageFile.readAsBytesSync());
    });
  }

  void _pickImageGallery() async {
    final pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      image = pickedImageFile;
      img64 = base64Encode(pickedImageFile.readAsBytesSync());
    });
  }

  void _cropImage() async {
    File? cropped = await ImageCropper.cropImage(
      sourcePath: image.path.toString(),
    );
    setState(() {
      image = cropped ?? image;
      image = File(cropped!.path);
      img64 = base64Encode(image.readAsBytesSync());
    });
  }

  void _clear() {
    setState(() {
      image = null;
      img64 = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.photo_camera),
              onPressed: () => _pickImageCamera(),
            ),
            IconButton(
              icon: const Icon(Icons.photo_library),
              onPressed: () => _pickImageGallery(),
            )
          ],
        ),
      ),
      body: LoaderOverlay(
        child: ListView(
          children: [
            if (image != null) ...[
              Padding(
                padding: const EdgeInsets.only(top:10),
                child: SizedBox(height: 500, width: 500, child: Image.file(image)),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: const Icon(Icons.crop),
                      onPressed: () {
                        _cropImage();
                      }),
                  FloatingActionButton(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: const Icon(Icons.close),
                      onPressed: () {
                        _clear();
                      }),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: RoundedButton(
                    buttonText: 'Upload',
                    buttonColor: Theme.of(context).primaryColor,
                    buttonFunction: () async {
                      context.loaderOverlay.show(widget: const LoadingScreen());
                      var status = await MedicationApi.postPrescription(
                          context, widget.appId, '', '', '', '', '', img64);
                      context.loaderOverlay.hide();
                      if (status == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text("image uploaded successfully"),
                          ),
                        );
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                          return MedicationDetails(appId: widget.appId);
                        }));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("Failed to Upload your image"),
                          ),
                        );
                      }
                    }),
              )
            ]
          ],
        ),
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MedicationImage(appId: widget.appId);
                        },
                      ),
                    );
                  })) // add more IconButton
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
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return AddMedication(appId: widget.appId);
          }));
        },
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

class AppId {
  final int appId;

  const AppId(this.appId);
}
