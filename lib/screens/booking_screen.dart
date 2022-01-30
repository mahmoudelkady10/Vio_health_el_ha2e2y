import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:medic_app/widgets/animated_tile.dart';
import 'package:medic_app/widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/network/create_appointment_api.dart';
import 'package:medic_app/network/doctors_api.dart';
import 'package:medic_app/network/services_api.dart';
import 'package:medic_app/network/specialties_api.dart';
import 'package:medic_app/network/time_slots_api.dart';

import 'home_screen.dart';

class BookingS extends StatelessWidget {
  const BookingS({Key? key}) : super(key: key);
  static const id = 'booking_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Specialty"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: FutureBuilder(
          future: SpecialtiesApi.getSpecialties(context),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              return Flex(
                direction: Axis.vertical,
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: SizedBox(
                              height: 120,
                              child: Card(
                                elevation: 4,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: SizedBox(
                                  height: 80,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Container(
                                                  height: 100,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              snapshot
                                                                  .data[index]
                                                                  .imageUrl),
                                                          fit: BoxFit.fill)),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          title:
                                              Text(snapshot.data[index].name),
                                          subtitle: Text(
                                              snapshot.data[index].description),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: SizedBox(
                                          width: 95,
                                          height: 60,
                                          child: RoundedButton(
                                            buttonText: 'choose',
                                            buttonColor:
                                                Theme.of(context).primaryColor,
                                            buttonFunction: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          BookingType(
                                                            specialtyId:
                                                                snapshot
                                                                    .data[index]
                                                                    .id,
                                                          )));
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No Specialties found'));
            }
          },
        ),
      ),
    );
  }
}

class BookingType extends StatelessWidget {
  const BookingType({Key? key, required this.specialtyId}) : super(key: key);
  final int specialtyId;

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
        title: const Padding(
          padding: EdgeInsets.all(60),
          child: Text(
            'Choose service',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
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
                      padding: const EdgeInsets.only(top:130.0),
                      child: Container(alignment: Alignment.topCenter,child: AnimatedTitle()),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 280, horizontal: 20),
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            if (snapshot.data[index].specialtyId == specialtyId ||
                                snapshot.data[index].specialtyId == false) {
                              return GestureDetector(
                                child: SizedBox(
                                  height: deviceSize.height * 0.2,
                                  width: deviceSize.width * 0.5,
                                  child: Card(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        icon,
                                        Text(snapshot.data[index].name.toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Arial',
                                                fontSize: 16,
                                                color: Colors.black54)),
                                        Text(
                                            '${snapshot.data[index].price.toString()} AED')
                                      ],
                                    ),
                                    elevation: 8,
                                    shadowColor: Colors.blueGrey,
                                    margin: const EdgeInsets.all(5.0),
                                    shape: const RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: 1.0, color: Colors.white70)),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BookingD(
                                                type: snapshot.data[index].id,
                                                doctorId:
                                                    snapshot.data[index].doctorId,
                                                specialtyId: specialtyId,
                                              )));
                                },
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

class BookingD extends StatelessWidget {
  const BookingD(
      {Key? key,
      required this.specialtyId,
      required this.type,
      required this.doctorId})
      : super(key: key);
  final int specialtyId;
  final int type;
  final dynamic doctorId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Doctor'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: FutureBuilder(
          future: DoctorsApi.getDoctors(context),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              return Flex(
                direction: Axis.vertical,
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          if (snapshot.data[index].specialtyId == specialtyId) {
                            if (snapshot.data[index].id == doctorId ||
                                doctorId == false) {
                              return GestureDetector(
                                child: Card(
                                  elevation: 4,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: SizedBox(
                                    height: 120,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  border: Border.all(
                                                      color: Theme.of(context).primaryColor,
                                                      width: 3
                                                  ),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          snapshot.data[index].imageUrl),
                                                      fit: BoxFit.fill)),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: ListTile(
                                            title: Text(
                                                '${snapshot.data[index].title} ${snapshot.data[index].name}'),
                                            subtitle: Text(
                                                snapshot.data[index].level),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BookingT(
                                                doctorId:
                                                    snapshot.data[index].id,
                                                specialtyId: specialtyId,
                                                type: type,
                                              )));
                                },
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          } else {
                            return const SizedBox.shrink();
                          }
                        }),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No Specialties found'));
            }
          },
        ),
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
          await TimesApi.getTimeSlots(context, updatedDate!, widget.doctorId);
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
                padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        fit: StackFit.loose,
                        clipBehavior: Clip.antiAlias,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                height:50,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.timer),
                                      const SizedBox(width: 5,),
                                      Text(
                                        snapshot.data[index].time,
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 18.0, top: 0.0, bottom: 0.0),
                                child: SizedBox(
                                  width: 80,
                                  height: 60,
                                  child: RoundedButton(
                                    buttonText: 'Book',
                                    buttonColor: Theme.of(context).primaryColor,
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
                                                            snapshot.data[index]
                                                                .id);
                                                if (status == 200) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      backgroundColor:
                                                          Colors.green,
                                                      content: Text(
                                                          "Appointment Booked"),
                                                    ),
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      backgroundColor:
                                                          Colors.red,
                                                      content: Text(
                                                          "Booking Failed"),
                                                    ),
                                                  );
                                                }
                                                Navigator.pushNamed(
                                                    context, MyHomePage.id);
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.only(right: 10.0),
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
                                                padding: const EdgeInsets.only(left: 7.0),
                                                child: SizedBox(
                                                  width: 100,
                                                  height: 70,
                                                  child: RoundedButton(
                                                    buttonText: 'Cancel',
                                                    textColor: Theme.of(context).primaryColor,
                                                    buttonColor: Colors.white,
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
    DateFormat dFormat = DateFormat('dd/MM/yyy');
    int? partnerId = Provider.of<UserModel>(context).partnerId;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose appointment time'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DatePicker(
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
              ),
            ],
          ),
          if (updatedDate != null) Expanded(child: showTimes(context, updatedDate, partnerId)),
          if (updatedDate == null) const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class DoctorId {
  final int doctorId;

  const DoctorId(this.doctorId);
}

// class TimeSlots extends StatelessWidget {
//   const TimeSlots(
//       {Key? key,
//       required this.doctorId,
//       required this.date,
//       required this.specialtyId,
//       required this.type})
//       : super(key: key);
//   final int doctorId;
//   final DateTime date;
//   final int type;
//   final int specialtyId;
//
//   @override
//   Widget build(BuildContext context) {
//     int? partnerId = Provider.of<UserModel>(context).partnerId;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Choose time slot'),
//         backgroundColor: Colors.tealAccent.shade700,
//       ),
//       body: Center(
//         child: FutureBuilder(
//             future: TimesApi.getTimeSlots(context, date, doctorId),
//             builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (snapshot.connectionState == ConnectionState.done &&
//                   snapshot.data != null) {
//                 return ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: snapshot.data.length,
//                     itemBuilder: (context, index) {
//                       return SizedBox(
//                         width: 100,
//                         height: 65,
//                         child: Card(
//                           elevation: 20,
//                           child: ListTile(
//                             leading: const Icon(Icons.timer),
//                             title: Text(
//                               snapshot.data[index].time,
//                               textAlign: TextAlign.center,
//                             ),
//                             onTap: () {
//                               showDialog(
//                                 context: context,
//                                 builder: (_) => AlertDialog(
//                                   title: const Center(
//                                       child: Icon(
//                                     Icons.assignment_outlined,
//                                     color: Colors.deepOrangeAccent,
//                                     size: 50,
//                                   )),
//                                   content: Text(
//                                       'Confirm Appointment at ${snapshot.data[index].time}'),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () async {
//                                         int status = await CreateAppointmentApi
//                                             .createAppointment(
//                                                 context,
//                                                 date,
//                                                 doctorId,
//                                                 partnerId!,
//                                                 type,
//                                                 snapshot.data[index].id);
//                                         if (status == 200) {
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(
//                                             const SnackBar(
//                                               backgroundColor: Colors.green,
//                                               content:
//                                                   Text("Appointment Booked"),
//                                             ),
//                                           );
//                                         } else {
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(
//                                             const SnackBar(
//                                               backgroundColor: Colors.red,
//                                               content: Text("Booking Failed"),
//                                             ),
//                                           );
//                                         }
//                                         Navigator.pushNamed(
//                                             context, MyHomePage.id);
//                                       },
//                                       child: const Text('yes'),
//                                     ),
//                                     TextButton(
//                                       onPressed: () {
//                                         Navigator.pop(context);
//                                       },
//                                       child: const Text('no'),
//                                     )
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       );
//                     });
//               } else {
//                 return const Text('No free time slots on date chosen');
//               }
//             }),
//       ),
//     );
//   }
// }
//
// class Date {
//   final String date;
//
//   const Date(this.date);
// }

// Text(snapshot.data[index].time, textAlign: TextAlign.center,),
// SizedBox(
// width: 600,
// height: 110,
// child: Container(
// alignment: Alignment.centerLeft,
// child: ListView.builder(
// shrinkWrap: true,
// scrollDirection: Axis.horizontal,
// itemCount: snapshot.data.length,
// itemBuilder:
// (BuildContext context, int index) {
// if (snapshot.data[index].specialtyId ==
// specialties[i].id) {
// return SizedBox(
// width: 200,
// height: 80,
// child: ListTile(
// minVerticalPadding: 8.0,
// leading: CircleAvatar(
// radius: 25,
// backgroundImage: NetworkImage(
// snapshot.data[index].imageUrl),
// ),
// title: Text(
// '${snapshot.data[index].title}${snapshot.data[index].name}',
// style:
// const TextStyle(fontSize: 15),
// textAlign: TextAlign.left,
// ),
// subtitle: Text(
// snapshot.data[index].level,
// style:
// const TextStyle(fontSize: 13),
// textAlign: TextAlign.left,
// ),
// ),
// );
// } else {
// return const SizedBox.shrink();
// }
// }),
// ),
// )
