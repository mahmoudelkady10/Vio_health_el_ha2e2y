import 'package:flutter/cupertino.dart';

class AppointmentsModel {
  int? id;
  String? type;
  String? date;
  String? day;
  int? doctorId;
  String? doctor;
  String? time;
  String? diagnosis;
  String? state;
  String? serviceClass;
  dynamic meetingUrl;
  dynamic room;

  AppointmentsModel(
      {this.id,
      this.type,
      this.date,
      this.day,
      this.doctorId,
      this.doctor,
      this.time,
      this.diagnosis,
      this.state,
      this.meetingUrl,
      this.room,
      this.serviceClass});

  factory AppointmentsModel.fromJson(Map<String, dynamic> json) {
    return AppointmentsModel(
        id: json['id'],
        type: json['appointment_type'],
        date: json['date'],
        day: json['day'],
        doctorId: json['doctor_id'],
        doctor: json['doctor'],
        time: json['time'],
        diagnosis: json['diagnosis'],
        state: json['state'],
        serviceClass: json['service_class'],
        meetingUrl: json['telemedicine_main_url'],
        room: json['telemedicine_room']
    );
  }
}

class AppointmentsList extends ChangeNotifier {
  List<AppointmentsModel> _appointmentsList = [];

  set appointments(List<AppointmentsModel> newList) {
    _appointmentsList = newList;
    notifyListeners();
  }

  List<AppointmentsModel> get appointments => _appointmentsList;
}
