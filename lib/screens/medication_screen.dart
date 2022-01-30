import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medic_app/network/medication_api.dart';
import 'package:expandable/expandable.dart';
import 'package:medic_app/network/appointments_api.dart';
import 'package:medic_app/widgets/unit_request_card.dart';
import 'package:provider/provider.dart';
import 'package:medic_app/model/user_model.dart';

class Medication extends StatelessWidget {
  const Medication({Key? key}) : super(key: key);
  static const id = 'medication_screen';

  @override
  Widget build(BuildContext context) {
    int? userId = Provider.of<UserModel>(context).partnerId;
    return Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.all(40),
            child: Text('Choose appointment',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: FutureBuilder(
          future: AppointmentsApi.getAppointments(context, userId, Provider.of<UserModel>(context).token),
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
                    if (snapshot.data[index].state == 'done') {
                      return Column(
                        children: [
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
        ));
  }
}

class MedicationDetails extends StatelessWidget {
  const MedicationDetails({Key? key, required this.appId}) : super(key: key);
  final int appId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(75),
          child: Text('Prescriptions',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder(
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
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                      child: ExpandablePanel(
                          header: Padding(
                            padding: const EdgeInsets.only(top: 9.0),
                            child: Text(snapshot.data[index].medicineId, textAlign: TextAlign.center,),
                          ),
                          collapsed: SizedBox.shrink(),
                          expanded: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Name:'),
                                    Text(snapshot.data[index].medicineId),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Type:'),
                                    Text(snapshot.data[index].medicineFormId),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Amount/dose:'),
                                    Text(snapshot.data[index].dosageQuantity),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Doses/day:'),
                                    Text(snapshot.data[index].frequency),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Duration: '),
                                    Text('${snapshot.data[index].days} Day(s)'),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ),
                  );

            });
          } else {
            return const Center(
              child: Text('No medication found'),
            );
          }
        },
      ),
    );
  }
}

class AppId {
  final int appId;

  const AppId(this.appId);
}
