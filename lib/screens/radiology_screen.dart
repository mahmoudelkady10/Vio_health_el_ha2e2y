import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/network/appointments_api.dart';
import 'package:medic_app/network/create_appointment_api.dart';
import 'package:medic_app/network/radiologgy_api.dart';
import 'package:medic_app/network/time_slots_api.dart';
import 'package:medic_app/widgets/loading_screen.dart';
import 'package:medic_app/widgets/rounded_button.dart';
import 'package:medic_app/widgets/unit_request_card.dart';
import 'package:medic_app/widgets/validated_text_field.dart';
import 'package:provider/provider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:expandable/expandable.dart';

class Radiology extends StatefulWidget {
  const Radiology({Key? key}) : super(key: key);
  static const id = 'radiology_screen';

  @override
  State<Radiology> createState() => _RadiologyState();
}

class _RadiologyState extends State<Radiology> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int? userId = Provider
        .of<UserModel>(context)
        .partnerId;
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
                  builder: (_) =>
                      AlertDialog(
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
                                'click on the below button to add\nyour own scans or choose\nany appointment to see your\nscans or add a new one',
                                style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .primaryColor)),
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
        backgroundColor: Theme
            .of(context)
            .primaryColor,
      ),
      body: FutureBuilder(
        future: AppointmentsApi.getAppointments(
            context, userId, Provider
            .of<UserModel>(context)
            .token),
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
                              doctorName: snapshot.data[index].doctorName ==
                                  false ? null : snapshot.data[index]
                                  .doctorName,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RadiologyHistory(
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
            builder: (_) =>
                LoaderOverlay(
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
                          Text('click confirm to write your\nown Scans\n',
                              style:
                              TextStyle(color: Theme
                                  .of(context)
                                  .primaryColor)),
                          Center(
                            child: TextField(
                              controller: myController,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .subtitle1,
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
                              buttonColor: Theme
                                  .of(context)
                                  .primaryColor,
                              buttonText: 'cancel',
                              buttonFunction: () {
                                Navigator.pop(context, Radiology.id);
                              },
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            height: 70,
                            child: RoundedButton(
                              buttonColor: Theme
                                  .of(context)
                                  .primaryColor,
                              buttonText: 'confirm',
                              buttonFunction: () async {
                                context.loaderOverlay.show(
                                    widget: const LoadingScreen());
                                var time = await TimesApi.getTimeSlots(
                                    context, DateTime.now(), 19, 1);
                                var status =
                                await CreateAppointmentApi.createAppointment(
                                    context,
                                    DateTime.now(),
                                    19,
                                    Provider
                                        .of<UserModel>(context, listen: false)
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
                                      Provider
                                          .of<UserModel>(context,
                                          listen: false)
                                          .token);
                                  print(appointmentlast.last.id);
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                        return RadiologyHistory(
                                            appId: appointmentlast.last.id!
                                                .toInt());
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
        backgroundColor: Theme
            .of(context)
            .primaryColor,
      ),
    );
  }
}


class RadiologyHistory extends StatefulWidget {
  const RadiologyHistory({Key? key, required this.appId}) : super(key: key);
  final int appId;

  @override
  _RadiologyHistoryState createState() => _RadiologyHistoryState();
}

class _RadiologyHistoryState extends State<RadiologyHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radiology History'),
        backgroundColor: Theme
            .of(context)
            .primaryColor,
      ),
      body: FutureBuilder(
        future: RadiologyApi.getRads(context, widget.appId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 6.0),
                      child: Card(
                        elevation: 10,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Scan Type:',
                                    ),
                                    Text(snapshot.data[index].name),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Date: ',
                                    ),
                                    Text(
                                      snapshot.data[index].date,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.bottomRight,
                                height: 80,
                                width: 150,
                                child: RoundedButton(
                                  buttonText: 'Check/Add Results',
                                  buttonColor: Theme
                                      .of(context)
                                      .primaryColor,
                                  buttonFunction: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                          return RadiologyResults(
                                            name: snapshot.data[index].name,
                                            date: snapshot.data[index].date,
                                            results: snapshot.data[index]
                                                .radLines,
                                            radId: snapshot.data[index].id,);
                                        }));
                                  },
                                ),
                              )
                            ]),
                      ));
                });
          } else {
            return const Center(
              child: Text('No Records Found'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return RadiologyImage(appId: widget.appId);
          }));
        },
      ),
    );
  }
}

class RadiologyResults extends StatefulWidget {
  const RadiologyResults({Key? key, this.results, required this.name,
    required this.date, required this.radId}) : super(key: key);
  final dynamic results;
  final String name;
  final String date;
  final int radId;

  @override
  _RadiologyResultsState createState() => _RadiologyResultsState();
}

class _RadiologyResultsState extends State<RadiologyResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scans'),
        backgroundColor: Theme
            .of(context)
            .primaryColor,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                        BorderSide(color: Theme
                            .of(context)
                            .primaryColor),
                        top:
                        BorderSide(color: Theme
                            .of(context)
                            .primaryColor))),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(widget.date)
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.results.length,
                itemBuilder: (BuildContext context, int index) {
                  return ExpandablePanel(
                    header: Padding(
                      padding: const EdgeInsets.only(top: 9.0),
                      child: Text(widget.results[index].name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.black)),
                    ),
                    collapsed: const SizedBox.shrink(),
                    expanded: InteractiveViewer(
                        minScale: 1,
                        maxScale: 4,
                        child: Image.network(
                          widget.results[index].image!, width: 800,
                          height: 800,)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return RadiologyImage(radId: widget.radId);
          }));
        },
      ),
    );
  }
}


class RadiologyImage extends StatefulWidget {
  const RadiologyImage({Key? key, this.appId, this.radId}) : super(key: key);
  final int? appId;
  final int? radId;

  @override
  _RadiologyImageState createState() => _RadiologyImageState();
}

class _RadiologyImageState extends State<RadiologyImage> {
  dynamic image;
  final picker = ImagePicker();
  int ctImage = 0;
  static dynamic img64;
  TextEditingController myController = TextEditingController();

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
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                    height: 500, width: 500, child: Image.file(image)),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                      backgroundColor: Theme
                          .of(context)
                          .primaryColor,
                      child: const Icon(Icons.crop),
                      onPressed: () {
                        _cropImage();
                      }),
                  FloatingActionButton(
                      backgroundColor: Theme
                          .of(context)
                          .primaryColor,
                      child: const Icon(Icons.close),
                      onPressed: () {
                        _clear();
                      }),
                ],
              ),
              const SizedBox(height: 5,),
              ValidatedTextField(
                fieldController: myController,
                labelText: 'Caption',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: RoundedButton(
                    buttonText: 'Upload',
                    buttonColor: Theme
                        .of(context)
                        .primaryColor,
                    buttonFunction: () async {
                      var status = 0;
                      context.loaderOverlay.show(widget: const LoadingScreen());
                      if(widget.appId != null){
                        status = await RadiologyApi.createRadRequest(
                            context, img64, widget.appId!, myController.text);
                      } else {
                        status = await RadiologyApi.AddRadResults(context, img64, myController.text, widget.radId!);
                      }
                      context.loaderOverlay.hide();
                      if (status == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text("Scan uploaded successfully"),
                          ),
                        );
                        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                        //   return MedicationDetails(appId: widget.appId);
                        // }));
                        Navigator.pop(context);
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
