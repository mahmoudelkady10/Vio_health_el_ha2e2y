import 'dart:ui';
import 'package:medic_app/network/create_appointment_api.dart';
import 'package:medic_app/network/services_api.dart';
import 'package:medic_app/network/time_slots_api.dart';
import 'package:medic_app/widgets/animated_tile.dart';
import 'package:medic_app/widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:medic_app/model/specialties_model.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/network/doctors_api.dart';

import 'home_screen.dart';

class Availability extends StatelessWidget {
  const Availability({Key? key}) : super(key: key);
  static const id = 'availability_screen';

  @override
  Widget build(BuildContext context) {
    List<SpecialtiesModel> specialties =
        Provider.of<SpecialtiesList>(context, listen: false).specialties;
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 80),
          child: Text("Doctors", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder(
          future: DoctorsApi.getDoctors(context),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: specialties.length,
                  itemBuilder: (context, i) {
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(specialties[i].name.toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                )),
                          ),
                          SizedBox(
                            width: 500,
                            height: 120,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (snapshot.data[index].specialtyId ==
                                        specialties[i].id) {
                                      return GestureDetector(
                                        child: SizedBox(
                                          width: 300,
                                          height: 200,
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 13.0),
                                              child: Container(
                                                height: 120,
                                                width: 100,
                                                padding: const EdgeInsets.only(
                                                    bottom: 13, left: 8),
                                                child: Row(children: [
                                                  Expanded(
                                                    flex: 5,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  20),
                                                          border: Border.all(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              width: 3),
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .imageUrl),
                                                              fit:
                                                                  BoxFit.fill)),
                                                    ),
                                                  ),
                                                  const Spacer(
                                                    flex: 1,
                                                  ),
                                                  Expanded(
                                                    flex: 8,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Text(
                                                            '${snapshot.data[index].title}${snapshot.data[index].name}',
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15),
                                                          ),
                                                          Text(
                                                            snapshot.data[index]
                                                                .level,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 13),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                              )),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DoctorDescription(
                                                        doctorId: snapshot
                                                            .data[index].id,
                                                        specialtyId:
                                                            specialties[i].id!,
                                                        description: snapshot
                                                            .data[index]
                                                            .description,
                                                      )));
                                        },
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  }),
                            ),
                          )
                        ],
                      ),
                    );
                  });
            } else {
              return const Center(child: Text('No doctors found'));
            }
          }),
    );
  }
}

// ListTile(
// leading:  CircleAvatar(
// radius: 50,
// foregroundColor: Theme.of(context).primaryColor,
// child: CircleAvatar(
// radius: 30,
// foregroundImage: NetworkImage(snapshot.data[index].imageUrl),
// ),
// ),
//
// title: Text(
// '${snapshot.data[index].title}${snapshot.data[index].name}',
// style:
// const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
// textAlign: TextAlign.left,
// ),
// subtitle: Text(
// snapshot.data[index].level,
// style:
// const TextStyle(fontSize: 13 , fontWeight: FontWeight.bold),
// textAlign: TextAlign.left,
// ),
// ),
class DoctorDescription extends StatelessWidget {
  const DoctorDescription(
      {Key? key,
      required this.doctorId,
      required this.specialtyId,
      required this.description})
      : super(key: key);
  final int specialtyId;
  final int doctorId;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        children: [
          Html(
            data: description,
          ),
          BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 50,
                  child: FloatingActionButton(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookingType(
                                    doctorId: doctorId,
                                    specialtyId: specialtyId,
                                  )));
                    },
                    child: const Text('Book an Appointment'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BookingType extends StatelessWidget {
  const BookingType(
      {Key? key, required this.doctorId, required this.specialtyId})
      : super(key: key);
  final int specialtyId;
  final int doctorId;

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    Icon icon = Icon(
      Icons.local_hospital_outlined,
      size: 35,
      color: Theme.of(context).primaryColor,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose service'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: FutureBuilder(
            future: ServicesApi.getServices(context),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 130.0),
                      child: Container(
                          alignment: Alignment.topCenter,
                          child: AnimatedTitle()),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 280, horizontal: 20),
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            if ((snapshot.data[index].specialtyId ==
                                        specialtyId ||
                                    snapshot.data[index].specialtyId ==
                                        false) &&
                                (snapshot.data[index].doctorId == doctorId ||
                                    snapshot.data[index].doctorId == false)) {
                              return SizedBox(
                                width: deviceSize.width * 0.4,
                                height: deviceSize.height * 0.4,
                                child: GestureDetector(
                                  child: Card(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        icon,
                                        Text(
                                            snapshot.data[index].name
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Arial',
                                                fontSize: 16,
                                                color: Colors.black54)),
                                        Text(
                                            '${snapshot.data[index].price.toString()} EGP')
                                      ],
                                    ),
                                    elevation: 8,
                                    shadowColor: Colors.blueGrey,
                                    margin: const EdgeInsets.all(5.0),
                                    shape: const RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: 1.0, color: Colors.white70)),
                                  ),
                                  onTap: () {
                                    if (snapshot.data[index].serviceClass ==
                                        'telemedicine') {
                                      if (Provider.of<UserModel>(context,
                                                  listen: false)
                                              .balance <
                                          snapshot.data[index].price) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text("Top Up Wallet!"),
                                          ),
                                        );
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => BookingT(
                                                      type: snapshot
                                                          .data[index].id,
                                                      doctorId: doctorId,
                                                      specialtyId: specialtyId,
                                                    )));
                                      }
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => BookingT(
                                                    type:
                                                        snapshot.data[index].id,
                                                    doctorId: doctorId,
                                                    specialtyId: specialtyId,
                                                  )));
                                    }
                                  },
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text('No services found'),
                );
              }
            }),
      ),
    );
  }
}

class SpecialtyId {
  final int specialtyId;

  const SpecialtyId(this.specialtyId);
}

class Type {
  final int type;

  const Type(this.type);
}

class BookingT extends StatefulWidget {
  const BookingT(
      {Key? key,
      required this.doctorId,
      required this.specialtyId,
      required this.type})
      : super(key: key);
  final int doctorId;
  final int specialtyId;
  final int type;

  @override
  State<BookingT> createState() => _BookingTState();
}

class _BookingTState extends State<BookingT> {
  DateTime? updatedDate = DateTime.now();
  Future<dynamic>? futureData;
  TextEditingController dateInput = TextEditingController();

  Future<dynamic> getData(updatedDate) async {
    try {
      dynamic data =
          await TimesApi.getTimeSlots(context, updatedDate!, widget.doctorId, 1);
      return data;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
    futureData = getData(updatedDate);
  }

  Widget showTimes(context, updatedDate, partnerId) {
    return FutureBuilder(
        future: getData(updatedDate),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            if (snapshot.data.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '       Available Time',
                      textAlign: TextAlign.left,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            fit: StackFit.loose,
                            clipBehavior: Clip.antiAlias,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(
                                    height: 50,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.timer),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            snapshot.data[index].time,
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 18.0,
                                        top: 0.0,
                                        bottom: 0.0),
                                    child: SizedBox(
                                      width: 80,
                                      height: 60,
                                      child: RoundedButton(
                                        buttonText: 'Book',
                                        buttonColor:
                                            Theme.of(context).primaryColor,
                                        buttonFunction: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              title: const Center(
                                                  child: Icon(
                                                Icons.assignment_outlined,
                                                color: Colors.deepOrangeAccent,
                                                size: 50,
                                              )),
                                              content: Text(
                                                  'Confirm Appointment at ${snapshot.data[index].time}'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () async {
                                                    int status =
                                                        await CreateAppointmentApi
                                                            .createAppointment(
                                                      context,
                                                      updatedDate!,
                                                      widget.doctorId,
                                                      partnerId!,
                                                      widget.type,
                                                      snapshot.data[index].id,
                                                          null,
                                                          1
                                                    );
                                                    if (status == 200) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          backgroundColor:
                                                              Colors.green,
                                                          content: Text(
                                                              "Appointment Booked"),
                                                        ),
                                                      );
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          backgroundColor:
                                                              Colors.red,
                                                          content: Text(
                                                              "Booking Failed"),
                                                        ),
                                                      );
                                                    }
                                                    Navigator
                                                        .pushReplacementNamed(
                                                            context,
                                                            MyHomePage.id);
                                                  },
                                                  child: const Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 10.0),
                                                    child: SizedBox(
                                                      width: 100,
                                                      height: 70,
                                                      child: RoundedButton(
                                                        buttonText: 'Confirm',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 7.0),
                                                    child: SizedBox(
                                                      width: 100,
                                                      height: 70,
                                                      child: RoundedButton(
                                                        buttonText: 'Cancel',
                                                        textColor:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                        buttonColor:
                                                            Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                height: 0.3,
                                thickness: 1,
                                color: Colors.black,
                                indent: 15,
                                endIndent: 15,
                              ),
                            ],
                          );
                        }),
                  ],
                ),
              );
            } else {
              return const Text('No free time slots on date chosen');
            }
          } else {
            return const Text('No free time slots on date chosen');
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    int? partnerId = Provider.of<UserModel>(context).partnerId;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose appointment time'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        children: [
          DatePicker(
            DateTime.now(),
            initialSelectedDate: DateTime.now(),
            selectionColor: Theme.of(context).primaryColor,
            selectedTextColor: Colors.white,
            onDateChange: (date) {
              // New date selected
              setState(() {
                updatedDate = date;
              });
            },
          ),
          const SizedBox(
            height: 15,
          ),
          Center(child: showTimes(context, updatedDate, partnerId)),
        ],
      ),
    );
  }
}

class DoctorId {
  final int doctorId;

  const DoctorId(this.doctorId);
}

// SizedBox(
// height: 100,
// width: 500,
// child: GridView.builder(
// shrinkWrap: true,
// scrollDirection: Axis.horizontal,
// gridDelegate:
// const SliverGridDelegateWithMaxCrossAxisExtent(
// maxCrossAxisExtent: 100,
// childAspectRatio: 1,
// crossAxisSpacing: 1,
// mainAxisSpacing: 2,
// ),

// }),
// );
