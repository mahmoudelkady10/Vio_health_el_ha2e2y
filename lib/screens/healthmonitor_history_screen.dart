import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/network/health_monitor_api.dart';
import 'package:provider/provider.dart';

class HealthMonitorHistory extends StatelessWidget {
  const HealthMonitorHistory({Key? key}) : super(key: key);
  static const id = 'health_monitor_history_screen';

  @override
  Widget build(BuildContext context) {
    var userId = Provider.of<UserModel>(context).partnerId;
    var token = Provider.of<UserModel>(context).token;
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: FutureBuilder(
        future: HmApi.getReadings(context, userId, token),
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
                  if (snapshot.data[index].category == 'blood_glucose'){
                    return Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Blood Glucose(mmol/L):'),
                              Text(snapshot.data[index].bgMeasure)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Date of reading:'),
                              Text(snapshot.data[index].date)
                            ],
                          ),
                        ],
                      ),
                    );

                  }
                  else if (snapshot.data[index].category == 'blood_pressure') {
                    return Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('SBP(mmHg):'),
                              Text(snapshot.data[index].systolicPressure)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('DBP(mmHg):'),
                              Text(snapshot.data[index].diastolicPressure)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Heart rate(BPM):'),
                              Text(snapshot.data[index].heartRate)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Date of reading:'),
                              Text(snapshot.data[index].date)
                            ],
                          ),
                        ],
                      ),
                    );

                  }
                  else if (snapshot.data[index].category == 'body_temperature') {
                    return Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Body Temperature(`C/F):'),
                              Text(snapshot.data[index].bodyTemp)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Date of reading:'),
                              Text(snapshot.data[index].date)
                            ],
                          ),
                        ],
                      ),
                    );

                  }
                  else if (snapshot.data[index].category == 'ecg') {
                    return Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('R-R Max:'),
                              Text(snapshot.data[index].rrMax)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('R-R Min'),
                              Text(snapshot.data[index].rrMin)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('HRV(ms)'),
                              Text(snapshot.data[index].hrv)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('mood'),
                              Text(snapshot.data[index].mood)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Respiratory rate:'),
                              Text(snapshot.data[index].respiratoryRate)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Duration(s):'),
                              Text(snapshot.data[index].durationEcg)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Heart rate(BPM):'),
                              Text(snapshot.data[index].heartRate)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Date of reading:'),
                              Text(snapshot.data[index].date)
                            ],
                          ),
                        ],
                      ),
                    );

                  }
                  else {
                    return Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('SpO2(%):'),
                              Text(snapshot.data[index].spo2)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Heart rate(BPM):'),
                              Text(snapshot.data[index].heartRate)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Date of reading:'),
                              Text(snapshot.data[index].date)
                            ],
                          ),
                        ],
                      ),
                    );

                  }
                }
                );
          } else {
            return const Center(child: Text('No readings found'),);
          }
        },
      ),
    );
  }
}
