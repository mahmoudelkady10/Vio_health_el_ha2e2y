import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medic_app/network/appointment_action_api.dart';
import 'package:medic_app/screens/video_call_screen.dart';
import 'package:medic_app/widgets/rounded_button.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard(
      {Key? key,
      this.service,
      this.doctor,
      this.date,
      this.time,
      this.diagnosis,
      this.requestState,
      this.day,
      this.showButton,
      this.appId,
      this.showVideoCall,
      this.url,
      this.room})
      : super(key: key);

  final String? service;
  final String? doctor;
  final String? date;
  final String? time;
  final String? diagnosis;
  final String? requestState;
  final String? day;
  final bool? showButton;
  final int? appId;
  final bool? showVideoCall;
  final dynamic url;
  final dynamic room;

  @override
  Widget build(BuildContext context) {
    final Color titleColor;
    final String? requestTitle;
    if (requestState == 'draft') {
      requestTitle = 'New';
      titleColor = Colors.blue;
    } else if (requestState == 'confirm') {
      requestTitle = 'Confirmed';
      titleColor = Colors.green;
    } else if (requestState == 'done') {
      requestTitle = 'Done';
      titleColor = Colors.red;
    } else {
      requestTitle = '';
      titleColor = Colors.black;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Card(
              elevation: 4.0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                      child: Text(
                        requestTitle.toString(),
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Row(children: [
                      const Text(
                        'Service: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17.0,
                        ),
                      ),
                      Text(
                        service!,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline,
                          fontSize: 15.0,
                        ),
                      ),
                    ]),
                    const SizedBox(height: 4,),
                    Row(children: [
                      const Text(
                        'Doctor: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17.0,
                        ),
                      ),
                      Text(
                        doctor!,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15.0,
                        ),
                      )
                    ]),
                    const SizedBox(height: 4,),
                    Row(children: [
                      const Text(
                        'Date: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17.0,
                        ),
                      ),
                      Text(
                        date!,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15.0,
                        ),
                      )
                    ]),
                    const SizedBox(height: 4,),
                    if (day != null)
                      Row(children: [
                        const Text(
                          'Time:  ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.0,
                          ),
                        ),
                        Text(
                          day!,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 15.0,
                          ),
                        ),
                        if (time != null)
                          Text(
                            "  ${time!}",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 15.0,
                            ),
                          )
                      ]),

                    Visibility(
                        visible: requestState == 'done',
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: RoundedButton(
                            buttonText: 'Diagnosis',
                            buttonFunction: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Center(child: Text('Diagnosis')),
                                  content: Text(
                                      diagnosis ?? 'No Diagnosis Made',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 15.0,
                                      )),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      },
                                      child: const SizedBox(
                                        width: 60,
                                        child: RoundedButton(
                                          buttonText: 'ok',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )),
                    // ListTile(
                    //   title: const Text('Diagnosis'),
                    //   subtitle: Text(
                    //     diagnosis ?? 'yy',
                    //     style: TextStyle(
                    //       color: Theme.of(context).primaryColor,
                    //       fontSize: 15.0,
                    //     ),
                    //   ),
                    // ),
                    Visibility(
                      visible: showButton == true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 70,
                            child: RoundedButton(
                              buttonColor: Theme.of(context).primaryColor,
                              buttonText: 'Cancel',
                              buttonFunction: () async{
                                var response = await AppointmentAction.cancelAppoint(context, appId!);
                                int status = jsonDecode(response.body)['result']['status'];
                                if (status == 200){
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                      const SnackBar(
                                        backgroundColor:
                                        Colors.green,
                                        content: Text(
                                            "Appointment Cancelled"),
                                      ));
                                  Navigator.pop(context);
                                }else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                      const SnackBar(
                                        backgroundColor:
                                        Colors.red,
                                        content: Text(
                                            "Failed to cancel appointment!"),
                                      ));
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            height: 70,
                            child: RoundedButton(
                              buttonColor: Theme.of(context).primaryColor,
                              buttonText: 'Confirm',
                              buttonFunction: () async{
                                var response = await AppointmentAction.confirmAppoint(context, appId!);
                                int status = jsonDecode(response.body)['result']['status'];
                                if (status == 200){
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                      const SnackBar(
                                        backgroundColor:
                                        Colors.green,
                                        content: Text(
                                            "Appointment Confirmed!"),
                                      ));
                                  Navigator.pop(context);
                                }else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                      const SnackBar(
                                        backgroundColor:
                                        Colors.red,
                                        content: Text(
                                            "Failed to confirm appointment!"),
                                      ));
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                        visible: showVideoCall!,
                        child: SizedBox(
                          height: 70,
                          width: 250,
                          child: RoundedButton(
                            buttonColor: url!= ''? Theme.of(context).primaryColor: Colors.grey,
                            buttonText: 'Go to online Appointment',
                            buttonFunction: () {
                                if(url!='') {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return VideoAppointment(room: room.toString(), url: url.toString(),);
                                  }));
                                }
                            },
                          ),

                        ))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
