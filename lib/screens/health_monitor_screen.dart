import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/model/wave_data.dart';
import 'package:medic_app/network/health_monitor_api.dart';
import 'package:medic_app/screens/home_screen.dart';
import 'package:medic_app/widgets/rounded_button.dart';
import 'package:medic_app/widgets/waive_drawer_2.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:medic_app/widgets/wave_drawer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class HealthMonitor extends StatefulWidget {
  const HealthMonitor({Key? key}) : super(key: key);
  static const id = 'health_monitor_screen';

  @override
  _HealthMonitorState createState() => _HealthMonitorState();
}

class _HealthMonitorState extends State<HealthMonitor> {
  static const CHANNEL = 'com.example.viohealth/channels';
  static const platform = MethodChannel(CHANNEL);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey globalKey = GlobalKey();

  static dynamic bodyTemp = '';
  static dynamic bgMeasure = '';
  static dynamic systolicPressure = '';
  static dynamic diastolicPressure = '';
  static dynamic heartRateBp = '';
  static dynamic rrMax = '';
  static dynamic rrMin = '';
  static dynamic heartRateEcg = '';
  static dynamic hrv = '';
  static dynamic mood = '';
  static dynamic respiratoryRate = '';
  static dynamic durationEcg = '';
  static dynamic ecgWave = '';
  static dynamic spo2 = '';
  static dynamic heartRateSpo2 = '';
  static dynamic dateSpo2 = '';
  static dynamic dateBt = '';
  static dynamic dateBp = '';
  static dynamic dateEcg = '';
  static dynamic dateBg = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    assignReadings();
  }

  Future<void> openHealthMonitor(BuildContext context) async {
    try {
      await platform.invokeMethod('openHealthMonitor');
    } on PlatformException catch (e) {
      print(e.message);
    }
    assignReadings();
  }

  Future<dynamic> getReadings(key) async {
    dynamic temp;
    try {
      temp = await platform.invokeMethod('getData', <String, dynamic>{
        'key': key,
        'file': "Data",
      });
    } on PlatformException catch (e) {
      print(e.message);
    }
    print(temp);
    return temp;
  }

  checkReadings() {
    List temp = [
      bodyTemp,
      bgMeasure,
      systolicPressure,
      diastolicPressure,
      heartRateBp,
      rrMax,
      rrMin,
      heartRateEcg,
      hrv,
      mood,
      respiratoryRate,
      durationEcg,
      ecgWave,
      spo2,
      heartRateSpo2,
      dateSpo2,
      dateBt,
      dateBp,
      dateEcg,
      dateBg,
    ];
    int i = 0;
    for (i; i < temp.length; i++) {
      if (temp[i].toString() == 'null') {
      } else {
        return true;
      }
    }
    return false;
  }

  Future<void> _refresh() {
    return assignReadings();
  }

  Future<void> assignReadings() async {
    var _bodyTemp = await getReadings('body_temp');
    var _bgMeasure = await getReadings('bg_measure');
    var _systolicPressure = await getReadings('systolic_pressure');
    var _diastolicPressure = await getReadings('diastolic_pressure');
    var _heartRateBp = await getReadings('heart_rate_bp');
    var _rrMax = await getReadings('rrmax');
    var _rrMin = await getReadings('rrmin');
    var _heartRateEcg = await getReadings('heart_rate_ecg');
    var _hrv = await getReadings('hrv');
    var _mood = await getReadings('mood');
    var _respiratoryRate = await getReadings('respiratory_rate');
    var _durationEcg = await getReadings('duration_ecg');
    var _ecgWave = await getReadings('ecg_wave');
    var _spo2 = await getReadings('spo2');
    var _heartRateSpo2 = await getReadings('heart_rate_spo2');
    var _dateSpo2 = await getReadings('date_spo2');
    var _dateBg = await getReadings('date_bg');
    var _dateBp = await getReadings('date_bp');
    var _dateBt = await getReadings('date_bt');
    var _dateEcg = await getReadings('date_ecg');
    setState(() {
      bodyTemp = _bodyTemp;
      bgMeasure = _bgMeasure;
      systolicPressure = _systolicPressure;
      diastolicPressure = _diastolicPressure;
      heartRateBp = _heartRateBp;
      rrMax = _rrMax;
      rrMin = _rrMin;
      heartRateEcg = _heartRateEcg;
      hrv = _hrv;
      mood = _mood;
      respiratoryRate = _respiratoryRate;
      durationEcg = _durationEcg;
      ecgWave = _ecgWave;
      spo2 = _spo2;
      heartRateSpo2 = _heartRateSpo2;
      dateSpo2 = _dateSpo2;
      dateBg = _dateBg;
      dateBt = _dateBt;
      dateBp = _dateBp;
      dateEcg = _dateEcg;
    });
  }

  /// Creates an image from the given widget by first spinning up a element and render tree,
  /// then waiting for the given [wait] amount of time and then creating an image via a [RepaintBoundary].
  ///
  /// The final image will be of size [imageSize] and the the widget will be layout, ... with the given [logicalSize].
  Future<Uint8List> createImageFromWidget(Widget widget, {Duration? wait, Size? logicalSize, Size? imageSize}) async {
    final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

    logicalSize ??= ui.window.physicalSize / ui.window.devicePixelRatio;
    imageSize ??= ui.window.physicalSize;

    assert(logicalSize.aspectRatio == imageSize.aspectRatio);

    final RenderView renderView = RenderView(
      window: WidgetsBinding.instance!.window,
      child: RenderPositionedBox(alignment: Alignment.center, child: repaintBoundary),
      configuration: ViewConfiguration(
        size: logicalSize,
        devicePixelRatio: 1.0,
      ),
    );
    ServicesBinding.instance!.keyEventManager.keyMessageHandler = null;
    final PipelineOwner pipelineOwner = PipelineOwner();
    final BuildOwner buildOwner = BuildOwner();

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final RenderObjectToWidgetElement<RenderBox> rootElement = RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: widget,
    ).attachToRenderTree(buildOwner);

    buildOwner.buildScope(rootElement);

    if (wait != null) {
      await Future.delayed(wait);
    }

    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    final ui.Image image = await repaintBoundary.toImage(pixelRatio: imageSize.width / logicalSize.width);
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    var userId = Provider.of<UserModel>(context).partnerId;
    var token = Provider.of<UserModel>(context).token;
    dynamic readings = {
      'Blood Glucose': ['${bgMeasure.toString()} mmol/L', 'date: $dateBg'],
      'Blood Pressure': [
        'SBP: ${systolicPressure.toString()} mmHg',
        'DBP: ${diastolicPressure.toString()} mmHg',
        'Heart rate: $heartRateBp BPM',
        'date: $dateBp'
      ],
      'Body Temperature': ['${bodyTemp.toString()} `C', 'date: $dateBt'],
      'ECG': [
        'R-R max: $rrMax',
        'R-R min: $rrMin',
        'Heart rate: $heartRateEcg BPM',
        'HRV: $hrv ms',
        'Mood: $mood',
        'Respiratory rate: $respiratoryRate',
        'Duration: $durationEcg s',
        'date: $dateEcg'
      ],
      'SPO2': [
        'SpO2: $spo2%',
        'Heart rate: $heartRateSpo2 BPM',
        'date: $dateSpo2'
      ]
    };
    List categories = [
      'Blood Glucose',
      'Blood Pressure',
      'Body Temperature',
      'ECG',
      'SPO2'
    ];
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Health Monitor'),
          backgroundColor: Theme.of(context).primaryColor,
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Text('Most recent reading'),
              Text('Blood Glucose History'),
              Text('Blood Pressure History'),
              Text('Body Temperature History'),
              Text('ECG History'),
              Text('SPO2 History')
            ],
          ),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
                onPressed: () {
                  _refreshIndicatorKey.currentState!.show();
                }),
          ],
        ),
        body: TabBarView(
          children: [
            RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _refresh,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Visibility(
                      visible: checkReadings(),
                      child: Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 10.0),
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: categories.length,
                              itemBuilder: (context, i) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Divider(
                                      height: 4,
                                      thickness: 2,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    Text(
                                      categories[i],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.right,
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            readings[categories[i]].length,
                                        itemBuilder: (context, j) {
                                          var temp = readings[categories[i]][j]
                                              .toString()
                                              .split(' ');
                                          var n = temp.length;
                                          if (n < 3) {
                                            if (temp[0] == 'null' ||
                                                temp[1] == 'null') {
                                              return const Text(
                                                'N/A',
                                                textAlign: TextAlign.left,
                                              );
                                            } else {
                                              return Text(
                                                readings[categories[i]][j]
                                                    .toString(),
                                                textAlign: TextAlign.left,
                                              );
                                            }
                                          } else if (n >= 3) {
                                            if (temp[0] == 'null' ||
                                                temp[2] == 'null' ||
                                                temp[1] == 'null') {
                                              return const Text(
                                                'N/A',
                                                textAlign: TextAlign.left,
                                              );
                                            } else {
                                              return Text(
                                                readings[categories[i]][j]
                                                    .toString(),
                                                textAlign: TextAlign.left,
                                              );
                                            }
                                          } else {
                                            return Text(
                                              readings[categories[i]][j]
                                                  .toString(),
                                              textAlign: TextAlign.left,
                                            );
                                          }
                                        }),
                                  ],
                                );
                              }),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: checkReadings(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 70,
                                width: 150,
                                child: RoundedButton(
                                  buttonText: 'Upload/sync to server',
                                  buttonColor: Theme.of(context).primaryColor,
                                  buttonFunction: () async {
                                    List<int> lint = ecgWave
                                        .toString()
                                        .split(',')
                                        .map(int.parse)
                                        .toList();
                                    WaveformData waveData =
                                    WaveformData.fromJson(jsonEncode({
                                      "version": 2,
                                      "channels": 1,
                                      "sample_rate": 250,
                                      "samples_per_pixel": 64,
                                      "bits": 16,
                                      "length": lint.length,
                                      "data": lint
                                    }));
                                    var img = await createImageFromWidget(WaveSegments(data: waveData, zoomLevel: 1.0, globalKey: globalKey));
                                    var img64 = base64Encode(img);
                                    var dateTimeBg = dateBg.toString() != 'null'
                                        ? DateFormat('yyyy-MM-dd HH:mm:ss')
                                            .parse(dateBg)
                                        : null;
                                    var dateTimeBp = dateBp.toString() != 'null'
                                        ? DateFormat('yyyy-MM-dd HH:mm:ss')
                                            .parse(dateBp)
                                        : null;
                                    var dateTimeBt = dateBt.toString() != 'null'
                                        ? DateFormat('yyyy-MM-dd HH:mm:ss')
                                            .parse(dateBt)
                                        : null;
                                    var dateTimeEcg =
                                        dateEcg.toString() != 'null'
                                            ? DateFormat('yyyy-MM-dd HH:mm:ss')
                                                .parse(dateEcg)
                                            : null;
                                    var dateTimeSpo2 =
                                        dateSpo2.toString() != 'null'
                                            ? DateFormat('yyyy-MM-dd HH:mm:ss')
                                                .parse(dateSpo2)
                                            : null;
                                    print(dateTimeSpo2);
                                    var data = {
                                      'token': Provider.of<UserModel>(context,
                                              listen: false)
                                          .token
                                          .toString(),
                                      'blood_glucose': {
                                        'bg_measure': bgMeasure,
                                        'date_bg': dateTimeBg.toString()
                                      },
                                      'blood_pressure': {
                                        'systolic_pressure': systolicPressure,
                                        'diastolic_pressure': diastolicPressure,
                                        'heart_rate_bp': heartRateBp,
                                        'date_bp':
                                            dateTimeBp.toString().split('.')[0]
                                      },
                                      'body_temperature': {
                                        'body_temp': bodyTemp,
                                        'date_bt':
                                            dateTimeBt.toString().split('.')[0]
                                      },
                                      'ecg': {
                                        'rrmax': rrMax,
                                        'rrmin': rrMin,
                                        'heart_rate_ecg': heartRateEcg,
                                        'hrv': hrv,
                                        'mood': mood,
                                        'respiratory_rate': respiratoryRate,
                                        'duration_ecg': durationEcg,
                                        'date_ecg':
                                            dateTimeEcg.toString().split('.')[0],
                                        'wave': img64
                                      },
                                      'spo2': {
                                        'spo2': spo2,
                                        'heart_rate_spo2': heartRateSpo2,
                                        'date_spo2': dateTimeSpo2
                                            .toString()
                                            .split('.')[0]
                                      }
                                    };
                                    var response =
                                        await HmApi.postReadings(data);
                                    int status = json.decode(response.body)['result']['status'];
                                    if (status == 200){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.green,
                                          content: Text("Data Uploaded"),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text("Data Upload Failed!"),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 70,
                                width: 150,
                                child: RoundedButton(
                                  buttonText: 'New readings',
                                  buttonColor: Theme.of(context).primaryColor,
                                  buttonFunction: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Center(
                                            child: Icon(
                                          Icons.warning,
                                          color: Colors.red,
                                          size: 40,
                                        )),
                                        content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'Taking new reading will replace\ncurrently visible reading.\nIf you haven not saved and\nwould like to, then click\nupload button.',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pushReplacementNamed(
                                                  context, HealthMonitor.id);
                                              // Navigator.pop(context);
                                            },
                                            child: Text('Cancel',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    decoration: TextDecoration
                                                        .underline)),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Replace readings',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    decoration: TextDecoration
                                                        .underline)),
                                          )
                                        ],
                                      ),
                                    );
                                    await openHealthMonitor(context);
                                    assignReadings();
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 70,
                            width: 150,
                            child: RoundedButton(
                              buttonText: 'View ECG',
                              buttonColor: Theme.of(context).primaryColor,
                              buttonFunction: () async{
                                List<int> lint = ecgWave
                                    .toString()
                                    .split(',')
                                    .map(int.parse)
                                    .toList();

                                WaveformData data =
                                    WaveformData.fromJson(jsonEncode({
                                  "version": 2,
                                  "channels": 1,
                                  "sample_rate": 250,
                                  "samples_per_pixel": 64,
                                  "bits": 16,
                                  "length": lint.length,
                                  "data": lint
                                }));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PaintedWaveform(sampleData: data)));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                      visible: !checkReadings(),
                      child: Center(
                        child: SizedBox(
                          height: 100,
                          width: 200,
                          child: Column(
                            children: [
                              const Text(
                                  'Readings will appear on this screen when taken'),
                              RoundedButton(
                                buttonText: 'Open Health Monitor',
                                buttonColor: Theme.of(context).primaryColor,
                                buttonFunction: () async {
                                  await openHealthMonitor(context);
                                  assignReadings();
                                },
                              ),
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            ),
            FutureBuilder(
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
                          if (snapshot.data[index].category ==
                              'blood_glucose') {
                            return Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Blood Glucose(mmol/L):'),
                                        Text(snapshot.data[index].bgMeasure)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Date of reading:'),
                                        Text(snapshot.data[index].date)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        });
                  } else {
                    return const Center(
                      child: Text('No readings found'),
                    );
                  }
                }),
            FutureBuilder(
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
                          if (snapshot.data[index].category ==
                              'blood_pressure') {
                            return Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('SBP(mmHg):'),
                                        Text(
                                            snapshot.data[index].systolicPressure)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('DBP(mmHg):'),
                                        Text(snapshot
                                            .data[index].diastolicPressure)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Heart rate(BPM):'),
                                        Text(snapshot.data[index].heartRate)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Date of reading:'),
                                        Text(snapshot.data[index].date)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        });
                  } else {
                    return const Center(
                      child: Text('No readings found'),
                    );
                  }
                }),
            FutureBuilder(
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
                          if (snapshot.data[index].category ==
                              'body_temperature') {
                            return Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Body Temperature(`C/F):'),
                                        Text(snapshot.data[index].bodyTemp)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Date of reading:'),
                                        Text(snapshot.data[index].date)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        });
                  } else {
                    return const Center(
                      child: Text('No readings found'),
                    );
                  }
                }),
            FutureBuilder(
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
                          if (snapshot.data[index].category.toString() == 'ecg' && snapshot.data[index].rrMax != null) {
                            return Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('R-R Max:'),
                                        Text(snapshot.data[index].rrMax)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('R-R Min'),
                                        Text(snapshot.data[index].rrMin)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('HRV(ms)'),
                                        Text(snapshot.data[index].hrv)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('mood'),
                                        Text(snapshot.data[index].mood)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Respiratory rate:'),
                                        Text(snapshot.data[index].respiratoryRate)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Duration(s):'),
                                        Text(snapshot.data[index].durationEcg)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Heart rate(BPM):'),
                                        Text(snapshot.data[index].heartRate)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Date of reading:'),
                                        Text(snapshot.data[index].date)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        });
                  } else {
                    return const Center(
                      child: Text('No readings found'),
                    );
                  }
                }),
            FutureBuilder(
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
                          if (snapshot.data[index].category == 'spo2') {
                            return Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('SpO2(%):'),
                                        Text(snapshot.data[index].spo2)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Heart rate(BPM):'),
                                        Text(snapshot.data[index].heartRate)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Date of reading:'),
                                        Text(snapshot.data[index].date)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        });
                  } else {
                    return const Center(
                      child: Text('No readings found'),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}

class PaintedWaveform extends StatefulWidget {
  const PaintedWaveform({
    Key? key,
    required this.sampleData,
  }) : super(key: key);

  final dynamic sampleData;

  @override
  _PaintedWaveformState createState() => _PaintedWaveformState();
}

class _PaintedWaveformState extends State<PaintedWaveform> {
  double startPosition = 1.0;
  double zoomLevel = 1.0;
  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ECG'),
      ),
      body: Container(
        color: Colors.black87,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 4,
              child: LayoutBuilder(
                builder: (context, BoxConstraints constraints) {
                  // adjust the shape based on parent's orientation/shape
                  // the waveform should always be wider than taller
                  double height;
                  if (constraints.maxWidth < constraints.maxHeight) {
                    height = constraints.maxWidth;
                  } else {
                    height = constraints.maxHeight;
                  }

                  return Stack(
                    children: <Widget>[
                      GridPaper(
                        color: Colors.black38,
                        child: CustomPaint(
                          size: Size(
                            constraints.maxWidth,
                            height,
                          ),
                          foregroundPainter: WaveformPainter(
                            widget.sampleData,
                            zoomLevel: zoomLevel,
                            startingFrame: widget.sampleData
                                .frameIdxFromPercent(startPosition),
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Flexible(
              child: Slider(
                activeColor: Colors.indigoAccent,
                min: 1.0,
                max: 95.0,
                divisions: 42,
                onChanged: (newzoomLevel) {
                  setState(() => zoomLevel = newzoomLevel);
                },
                value: zoomLevel,
              ),
            ),
            Flexible(
              child: Slider(
                activeColor: Colors.indigoAccent,
                min: 1.0,
                max: 95.0,
                divisions: 42,
                onChanged: (newstartPosition) {
                  setState(() => startPosition = newstartPosition);
                },
                value: startPosition,
              ),
            ),
            SizedBox(
              height: 70,
              width: 150,
              child: RoundedButton(
                buttonText: 'View Full Report',
                buttonColor: Theme.of(context).primaryColor,
                buttonFunction: () {
                  //Create a new PDF document.
                  // final PdfDocument document = PdfDocument();
                  // final PdfBitmap image = PdfBitmap(imageData);
                  // document.pages
                  //     .add()
                  //     .graphics
                  //     .drawImage(image, const Rect.fromLTWH(0, 0, 500, 200));
                  // final temp = await getTemporaryDirectory();
                  // var path = '${temp.path}/image.png';
                  // File('ImageToPDF.pdf').writeAsBytes(document.save());
                  // await Share.shareFiles([path]);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return EcgReport(data: widget.sampleData);
                  }));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WaveSegments extends StatelessWidget {
  const WaveSegments({
    Key? key,
    required this.data,
    required this.zoomLevel,
    required this.globalKey,
  }) : super(key: key);

  final dynamic data;
  final double zoomLevel;
  final GlobalKey globalKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0),
      child: RepaintBoundary(
        key: globalKey,
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, BoxConstraints constraints) {
                // adjust the shape based on parent's orientation/shape
                // the waveform should always be wider than taller
                double height;
                if (constraints.maxWidth < constraints.maxHeight) {
                  height = constraints.maxWidth;
                } else {
                  height = constraints.maxHeight;
                }

                return GridPaper(
                  color: Colors.black38,
                  child: CustomPaint(
                    size: Size(
                      constraints.maxWidth,
                      150,
                    ),
                    foregroundPainter: WaveformPainter2(
                      data,
                      zoomLevel: zoomLevel,
                      startingFrame: data.frameIdxFromPercent(1.0),
                      color: Colors.green,
                      endFrame: data.frameIdxFromPercent(25.0),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 5,
            ),
            LayoutBuilder(
              builder: (context, BoxConstraints constraints) {
                // adjust the shape based on parent's orientation/shape
                // the waveform should always be wider than taller
                double height;
                if (constraints.maxWidth < constraints.maxHeight) {
                  height = constraints.maxWidth;
                } else {
                  height = constraints.maxHeight;
                }

                return GridPaper(
                  color: Colors.black38,
                  child: CustomPaint(
                    size: Size(
                      constraints.maxWidth,
                      150,
                    ),
                    foregroundPainter: WaveformPainter2(
                      data,
                      zoomLevel: zoomLevel,
                      startingFrame: data.frameIdxFromPercent(25.0),
                      color: Colors.green,
                      endFrame: data.frameIdxFromPercent(50.0),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 5,
            ),
            LayoutBuilder(
              builder: (context, BoxConstraints constraints) {
                // adjust the shape based on parent's orientation/shape
                // the waveform should always be wider than taller
                double height;
                if (constraints.maxWidth < constraints.maxHeight) {
                  height = constraints.maxWidth;
                } else {
                  height = constraints.maxHeight;
                }

                return GridPaper(
                  color: Colors.black38,
                  child: CustomPaint(
                    size: Size(
                      constraints.maxWidth,
                      150,
                    ),
                    foregroundPainter: WaveformPainter2(
                      data,
                      zoomLevel: zoomLevel,
                      startingFrame: data.frameIdxFromPercent(50.0),
                      color: Colors.green,
                      endFrame: data.frameIdxFromPercent(75.0),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 5,
            ),
            LayoutBuilder(
              builder: (context, BoxConstraints constraints) {
                // adjust the shape based on parent's orientation/shape
                // the waveform should always be wider than taller
                double height;
                if (constraints.maxWidth < constraints.maxHeight) {
                  height = constraints.maxWidth;
                } else {
                  height = constraints.maxHeight;
                }

                return GridPaper(
                  color: Colors.black38,
                  child: CustomPaint(
                    size: Size(
                      constraints.maxWidth,
                      150,
                    ),
                    foregroundPainter: WaveformPainter2(
                      data,
                      zoomLevel: zoomLevel,
                      startingFrame: data.frameIdxFromPercent(75.0),
                      color: Colors.green,
                      endFrame: data.frameIdxFromPercent(100.0),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class EcgReport extends StatelessWidget {
  const EcgReport({Key? key, required this.data}) : super(key: key);

  final dynamic data;
  static dynamic img;
  static GlobalKey globalKey = GlobalKey();
  static double zoomLevel = 1.0;

  Future<void> _capturePng() async {
    RenderRepaintBoundary? boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    ui.Image image = await boundary!.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    var img64 = base64Encode(pngBytes);
    img = pngBytes;
    print(img64);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Patient:  '),
                Text(Provider.of<UserModel>(context).name.toString())
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          WaveSegments(data: data, zoomLevel: zoomLevel, globalKey: globalKey),
          SizedBox(
              height: 70,
              width: 150,
              child: RoundedButton(
                buttonText: 'share',
                buttonColor: Theme.of(context).primaryColor,
                buttonFunction: () async {
                  await _capturePng();
                  //Create a new PDF document.
                  final temp = await getTemporaryDirectory();
                  var path = '${temp.path}/image.png';
                  File(path).writeAsBytesSync(img);
                  await Share.shareFiles([path]);
                },
              )),
        ],
      ),
    );
  }
}
