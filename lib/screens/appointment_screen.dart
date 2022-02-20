import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/network/appointments_api.dart';
import 'package:medic_app/widgets/unit_request_card.dart';
import 'package:provider/provider.dart';

class Appointment extends StatelessWidget {
  const Appointment({Key? key}) : super(key: key);
  static const id = 'appointment';

  @override
  Widget build(BuildContext context) {
    int? userId = Provider.of<UserModel>(context).partnerId;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: const Padding(
              padding: EdgeInsets.all(40),
              child: Text('Appointment',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            bottom: const TabBar(
              tabs: [Text('New'), Text('Confirmed'), Text('Done')],
            ),
          ),
          body: TabBarView(children: [
            FutureBuilder(
            future: AppointmentsApi.getAppointments(context, userId!, Provider.of<UserModel>(context).token),
            builder:
                (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      if (snapshot.data[index].state == 'draft' && snapshot.data[index].doctor != 'External Doctor') {
                        return AppointmentCard(
                          appId: snapshot.data[index].id,
                          requestState: snapshot.data[index].state,
                          service: snapshot.data[index].type,
                          doctor: snapshot.data[index].doctor,
                          date: snapshot.data[index].date,
                          day: snapshot.data[index].day,
                          time: snapshot.data[index].time,
                          showButton: true,
                          showVideoCall: false,
                        );
                      }
                      else {
                        return const SizedBox.shrink();
                      }
                    });
              } else {
                return const Center(child: Text('No appointments found'));
              }
            }),
            FutureBuilder(
                future: AppointmentsApi.getAppointments(context, userId, Provider.of<UserModel>(context).token),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.data != null) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          if (snapshot.data[index].state == 'confirm' && snapshot.data[index].doctor != 'External Doctor') {
                            return AppointmentCard(
                              requestState: snapshot.data[index].state,
                              service: snapshot.data[index].type,
                              doctor: snapshot.data[index].doctor,
                              date: snapshot.data[index].date,
                              day: snapshot.data[index].day,
                              time: snapshot.data[index].time,
                              showButton: false,
                              showVideoCall: snapshot.data[index].serviceClass == 'telemedicine'? true: false,
                              url: snapshot.data[index].meetingUrl,
                              room: snapshot.data[index].room,
                            );
                          }
                          else {
                            return const SizedBox.shrink();
                          }
                        });
                  } else {
                    return const Center(child: Text('No appointments found'));
                  }
                }),
            FutureBuilder(
                future: AppointmentsApi.getAppointments(context, userId, Provider.of<UserModel>(context).token),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.data != null) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          if (snapshot.data[index].state == 'done' && snapshot.data[index].doctor != 'External Doctor') {
                            return AppointmentCard(
                              requestState: snapshot.data[index].state,
                              service: snapshot.data[index].type,
                              doctor: snapshot.data[index].doctor,
                              date: snapshot.data[index].date,
                              day: snapshot.data[index].day,
                              time: snapshot.data[index].time,
                              diagnosis: snapshot.data[index].diagnosis,
                              showButton: false,
                              showVideoCall: false,
                            );
                          }
                          else {
                            return const SizedBox.shrink();
                          }
                        });
                  } else {
                    return const Center(child: Text('No appointments found'));
                  }
                }),

          ])),
    );
  }
}
