import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medic_app/model/follow_up_model.dart';
import 'package:medic_app/model/health_monitor_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

// For spo2, body_temp and blood glucose
class DrawGraph extends StatelessWidget {
  const DrawGraph({Key? key, required this.data}) : super(key: key);
  final List<HmModel> data;

  @override
  Widget build(BuildContext context) {
    String category = data[0].category;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SfCartesianChart(
          primaryXAxis: CategoryAxis(isVisible: false),
          // Chart title
          title: ChartTitle(text: 'Latest changes in ${data[0].category}'),
          // Enable legend
          legend: Legend(isVisible: false),
          // Enable tooltip
          series: <SplineSeries<HmModel, dynamic>>[
            SplineSeries<HmModel, dynamic>(
                color: Theme.of(context).primaryColor,
                dataSource: data,
                xValueMapper: (HmModel data, _) => data.date.toString(),
                yValueMapper: (HmModel data, _) =>
                category == 'body_temperature'
                    ? double.parse(data.bodyTemp)
                    : category == 'blood_glucose'? double.parse(data.bgMeasure):double.parse(data.spo2),
                // Enable data label
                dataLabelSettings: const DataLabelSettings(isVisible: true)),
          ]),
    );
  }
}

// For blood pressure
class DrawGraph2 extends StatelessWidget {
  const DrawGraph2({Key? key, required this.data}) : super(key: key);
  final List<HmModel> data;

  @override
  Widget build(BuildContext context) {
    String category = data[0].category;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SfCartesianChart(
          primaryXAxis: CategoryAxis(isVisible: false),
          // Chart title
          title: ChartTitle(text: 'Latest changes in ${data[0].category}'),
          // Enable legend
          legend: Legend(isVisible: false),
          // Enable tooltip
          series: <SplineSeries<HmModel, dynamic>>[
            SplineSeries<HmModel, dynamic>(
                color: Theme.of(context).primaryColor,
                dataSource: data,
                xValueMapper: (HmModel data, _) => data.date.toString(),
                yValueMapper: (HmModel data, _) =>
                    double.parse(data.systolicPressure),
                // Enable data label
                dataLabelSettings: const DataLabelSettings(isVisible: true)),
            SplineSeries<HmModel, dynamic>(
              dataSource: data,
              xValueMapper: (HmModel data, _) => data.date.toString(),
              yValueMapper: (HmModel data, _) =>
                  double.parse(data.diastolicPressure),
              // Enable data label
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              color: Colors.red,
            ),
          ]),
    );
  }
}

class DrawGraph3 extends StatelessWidget {
  const DrawGraph3({Key? key, required this.data}) : super(key: key);
  final List<FollowUpReadingsModel> data;

  @override
  Widget build(BuildContext context) {
    String category = data[0].category;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SfCartesianChart(
          primaryXAxis: CategoryAxis(isVisible: false),
          // Chart title
          title: ChartTitle(text: 'Latest changes in ${data[0].category}'),
          // Enable legend
          legend: Legend(isVisible: false),
          // Enable tooltip
          series: <SplineSeries<FollowUpReadingsModel, dynamic>>[
            SplineSeries<FollowUpReadingsModel, dynamic>(
                dataSource: data,
                xValueMapper: (FollowUpReadingsModel data, _) =>
                    data.date.toString(),
                yValueMapper: (FollowUpReadingsModel data, _) =>
                    double.parse(data.readings),
                // Enable data label
                dataLabelSettings: const DataLabelSettings(isVisible: true)),
          ]),
    );
  }
}

class DrawGraph4 extends StatelessWidget {
  const DrawGraph4({Key? key, required this.data}) : super(key: key);
  final List<FollowUpReadingsModel> data;

  @override
  Widget build(BuildContext context) {
    String category = data[0].category;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SfCartesianChart(
          primaryXAxis: CategoryAxis(isVisible: false),
          // Chart title
          title: ChartTitle(text: 'Latest changes in ${data[0].category}'),
          // Enable legend
          legend: Legend(isVisible: false),
          // Enable tooltip
          series: <SplineSeries<FollowUpReadingsModel, dynamic>>[
            SplineSeries<FollowUpReadingsModel, dynamic>(
                color: Theme.of(context).primaryColor,
                dataSource: data,
                xValueMapper: (FollowUpReadingsModel data, _) => data.date.toString(),
                yValueMapper: (FollowUpReadingsModel data, _) =>
                    double.parse(data.readings.toString().split(RegExp(r"[/-]+"))[0]),
                // Enable data label
                dataLabelSettings: const DataLabelSettings(isVisible: true)),
            SplineSeries<FollowUpReadingsModel, dynamic>(
              dataSource: data,
              xValueMapper: (FollowUpReadingsModel data, _) => data.date.toString(),
              yValueMapper: (FollowUpReadingsModel data, _) =>
                  double.parse(data.readings.toString().split(RegExp(r"[/-]+"))[1]),
              // Enable data label
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              color: Colors.red,
            ),
          ]),
    );
  }
}