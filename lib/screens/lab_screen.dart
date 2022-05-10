import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:medic_app/model/lab_model.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/network/appointments_api.dart';
import 'package:medic_app/network/create_appointment_api.dart';
import 'package:medic_app/network/lab_api.dart';
import 'package:medic_app/network/medication_api.dart';
import 'package:medic_app/network/radiologgy_api.dart';
import 'package:medic_app/network/time_slots_api.dart';
import 'package:medic_app/screens/radiology_screen.dart';
import 'package:medic_app/widgets/loading_screen.dart';
import 'package:medic_app/widgets/rounded_button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:medic_app/widgets/unit_request_card.dart';
import 'package:medic_app/widgets/validated_text_field.dart';
import 'package:provider/provider.dart';
import 'package:expandable/expandable.dart';
import 'package:convert/convert.dart';
import 'package:intl/intl.dart';
import 'medication_screen.dart';

class LabApointments extends StatelessWidget {
  static const id = 'lab_screen';
  const LabApointments({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextEditingController? myController = TextEditingController();
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
                                      builder: (context) => Labs(
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
                      Text('click confirm to write your\nown record\n',
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



class Labs extends StatelessWidget {
  const Labs({Key? key, required this.appId}) : super(key: key);
  final int appId;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lab'),
          backgroundColor: Colors.white,
          bottom: const TabBar(
            unselectedLabelStyle: TextStyle(fontSize: 14.0),
            labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            labelPadding: EdgeInsets.all(8.0),
            isScrollable: true,
            unselectedLabelColor: Color(0xFF979797),
            labelColor: Color(0xFF707070),
            indicatorColor: Colors.white,
            indicatorWeight: 0.5,
            tabs: [
              Text('Lab'),
              Text('Radiology'),
              Text('Medication'),
            ],
          ),
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor, //change your color here
          ),
        ),
        body: TabBarView(
          children: [
            FutureBuilder(
              future: LabApi.getLabs(context, appId),
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
                                            'Test Type:',
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
                                        buttonText: 'Check Results',
                                        buttonColor: Theme.of(context).primaryColor,
                                        buttonFunction: () {
                                          if (snapshot.data[index].labLines.isNotEmpty) {
                                            print(snapshot.data[index].labLines);
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) {
                                              return LabResults(
                                                  name: snapshot.data[index].name,
                                                  date: snapshot.data[index].date,
                                                  results:
                                                      snapshot.data[index].labLines);
                                            }));
                                          } else {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) {
                                              return LabResults(
                                                  name: snapshot.data[index].name,
                                                  date: snapshot.data[index].date,
                                                  image: snapshot.data[index].image.toString());
                                            }));
                                          }
                                        },
                                      ),
                                    )
                                  ]),
                            ));
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
                                'Click the button below to add lab records',
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
            FutureBuilder(
              future: RadiologyApi.getRads(context, appId),
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
                                'Go to radiology main page to add records.',
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
            FutureBuilder(
              future: MedicationApi.getMedication(context, appId),
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
                                    child: InteractiveViewer(
                                      child: Image.network(
                                          snapshot.data[index].image.toString()),
                                      maxScale: 5,
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
                                'Go to medication main page to add records.',
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
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MyForm(appId: appId,);
            }));
          },
        ),
      ),
    );
  }
}

class LabResults extends StatelessWidget {
  const LabResults(
      {Key? key,
      required this.name,
      required this.date,
      this.results,
      this.image})
      : super(key: key);
  final String name;
  final String date;
  final List<LabLines>? results;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$name Results'),
        backgroundColor: Theme.of(context).primaryColor,

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
                            BorderSide(color: Theme.of(context).primaryColor),
                        top:
                            BorderSide(color: Theme.of(context).primaryColor))),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(date)
                  ],
                ),
              ),
            ),
            if (results != null) const SizedBox(
              height: 70,
            ),
            if (results == null)
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    InteractiveViewer(
                        minScale: 1, maxScale: 4, child: Image.network(image!, width: 800, height: 800,)),
                  ],
                ),
              ),
            if (results != null)
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: results!.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 45.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    border: Border(
                                      left: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 3),
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 13.0, horizontal: 35.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        '${results![index].measure.toString()}: ',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          '${results![index].result.toString()} ${results![index].unit.toString()}'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            )
                          ],
                        ),
                      );
                    }),
              ),

          ],
        ),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  const MyForm({Key? key, required this.appId}) : super(key: key);
  final int appId;
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _nameController;
  static List<String> measurements = [''];
  static List<String> results = [''];
  static List<String> units = [''];
  DateTime? selectedDate;

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
                        selectedDate = val;
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
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add lab results'),
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
                          return LabImage(appId: widget.appId,);
                        },
                      ),
                    );
                  })) // add more IconButton
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LoaderOverlay(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // name textfield
                Padding(
                  padding: const EdgeInsets.only(right: 32.0),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: 'Test Name'),
                    validator: (v) {
                      if (v!.trim().isEmpty) return 'Please enter something';
                      return null;
                    },
                  ),
                ),
                Card(
                  semanticContainer: false,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: CupertinoButton(
                    padding: EdgeInsetsDirectional.zero,
                    child: selectedDate != null
                        ? Text(DateFormat('yyyy-MM-dd')
                        .format(selectedDate!))
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
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Add Results',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                ..._getFriends(),
                const SizedBox(
                  height: 40,
                ),
                FlatButton(
                  onPressed: () async {
                    context.loaderOverlay.show(widget: const LoadingScreen());
                    var status = await LabApi.postLab(context, measurements,
                        results, units, _nameController!.text, widget.appId, selectedDate!);
                    context.loaderOverlay.hide();
                    if (status == 200) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Lab results saved'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Lab results not saved'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// get firends text-fields
  List<Widget> _getFriends() {
    List<Widget> friendsTextFields = [];
    for (int i = 0; i < measurements.length; i++) {
      friendsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: FriendTextFields(i)),
            const SizedBox(
              width: 6,
            ),
            // we need add button at last friends row
            _addRemoveButton(i == measurements.length - 1, i),
          ],
        ),
      ));
    }
    return friendsTextFields;
  }

  /// add / remove button
  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          measurements.insert(index + 1, '');
          results.insert(index + 1, '');
          units.insert(index + 1, '');
        } else {
          measurements.removeAt(index);
          results.removeAt(index);
          units.removeAt(index);
        }
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }
}

class FriendTextFields extends StatefulWidget {
  final int index;

  FriendTextFields(this.index);

  @override
  _FriendTextFieldsState createState() => _FriendTextFieldsState();
}

class _FriendTextFieldsState extends State<FriendTextFields> {
  TextEditingController? _nameController;
  TextEditingController? _resultController;
  TextEditingController? _unitController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _resultController = TextEditingController();
    _unitController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController!.dispose();
    _resultController!.dispose();
    _unitController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   _nameController!.text = _MyFormState.measurements[widget.index] ?? '';
    // });

    return Row(
      children: [
        SizedBox(
          width: 150,
          child: TextFormField(
            controller: _nameController,
            onChanged: (v) => _MyFormState.measurements[widget.index] = v,
            decoration: const InputDecoration(hintText: 'type'),
            validator: (v) {
              if (v!.trim().isEmpty) return 'Please enter something';
              return null;
            },
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        SizedBox(
          width: 100,
          child: TextFormField(
            controller: _resultController,
            onChanged: (v) => _MyFormState.results[widget.index] = v,
            decoration: const InputDecoration(hintText: 'result'),
            validator: (v) {
              if (v!.trim().isEmpty) return 'Please enter something';
              return null;
            },
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        SizedBox(
          width: 50,
          child: TextFormField(
            controller: _unitController,
            onChanged: (v) => _MyFormState.units[widget.index] = v,
            decoration: const InputDecoration(hintText: 'unit'),
            validator: (v) {
              if (v!.trim().isEmpty) return 'Please enter something';
              return null;
            },
          ),
        ),
      ],
    );
  }
}

class LabImage extends StatefulWidget {
  const LabImage({Key? key, required this.appId}) : super(key: key);
  final int appId;
  @override
  _LabImageState createState() => _LabImageState();
}

class _LabImageState extends State<LabImage> {
  dynamic image;
  final picker = ImagePicker();
  final cropper = ImageCropper();

  int ctImage = 0;
  static dynamic img64;
  final myController = TextEditingController();
  DateTime? selectedDate;

  void _pickImageCamera() async {
    final pickedImage =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      image = pickedImageFile;
      img64 = base64Encode(pickedImageFile.readAsBytesSync());
    });
  }

  void _pickImageGallery() async {
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      image = pickedImageFile;
      img64 = base64Encode(pickedImageFile.readAsBytesSync());
    });
  }

  void _cropImage() async {
    File? cropped = await cropper.cropImage(
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
                        selectedDate = val;
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
                child:
                    SizedBox(height: 500, width: 500, child: Image.file(image)),
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
              const SizedBox(
                height: 5,
              ),
              ValidatedTextField(
                fieldController: myController,
                labelText: 'Test Name',
              ),
              Card(
                semanticContainer: false,
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: CupertinoButton(
                  padding: EdgeInsetsDirectional.zero,
                  child: selectedDate != null
                      ? Text(DateFormat('yyyy-MM-dd')
                      .format(selectedDate!))
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: RoundedButton(
                    buttonText: 'Upload',
                    buttonColor: Theme.of(context).primaryColor,
                    buttonFunction: () async {
                      context.loaderOverlay.show(widget: const LoadingScreen());
                      var status = await LabApi.postLabImage(
                          context, img64, myController.text, widget.appId, selectedDate!);
                      context.loaderOverlay.hide();
                      if (status == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text("image uploaded successfully"),
                          ),
                        );
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
