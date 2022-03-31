import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:medic_app/model/health_monitor_model.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/model/wave_data.dart';
import 'package:medic_app/network/health_monitor_api.dart';
import 'package:medic_app/screens/home_screen.dart';
import 'package:medic_app/widgets/graph_drawer.dart';
import 'package:medic_app/widgets/loading_screen.dart';
import 'package:medic_app/widgets/rounded_button.dart';
import 'package:medic_app/widgets/waive_drawer_2.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:medic_app/widgets/wave_drawer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class HmDashBoard extends StatefulWidget {
  const HmDashBoard({Key? key}) : super(key: key);
  static const id = 'hm_dash_screen';

  @override
  _HmDashBoardState createState() => _HmDashBoardState();
}

class _HmDashBoardState extends State<HmDashBoard> {
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

  bool uploaded = false;

  void _clear() async {
    await deleteNativePrefs();
    setState(() {
      bodyTemp = null;
      bgMeasure = null;
      systolicPressure = null;
      diastolicPressure = null;
      heartRateBp = null;
      rrMax = null;
      rrMin = null;
      heartRateEcg = null;
      hrv = null;
      mood = null;
      respiratoryRate = null;
      durationEcg = null;
      ecgWave = null;
      spo2 = null;
      heartRateSpo2 = null;
      dateSpo2 = null;
      dateBt = null;
      dateBp = null;
      dateEcg = null;
      dateBg = null;
      uploaded = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    assignReadings();
  }

  Future<void> deleteNativePrefs() async {
    try {
      var temp = await platform.invokeMethod('deleteData');
    } on PlatformException catch (e) {
      print(e.message);
    }
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
      uploaded = false;
    });
  }

  /// Creates an image from the given widget by first spinning up a element and render tree,
  /// then waiting for the given [wait] amount of time and then creating an image via a [RepaintBoundary].
  ///
  /// The final image will be of size [imageSize] and the the widget will be layout, ... with the given [logicalSize].
  Future<Uint8List> createImageFromWidget(Widget widget,
      {Duration? wait, Size? logicalSize, Size? imageSize}) async {
    final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

    logicalSize ??= ui.window.physicalSize / ui.window.devicePixelRatio;
    imageSize ??= ui.window.physicalSize;

    assert(logicalSize.aspectRatio == imageSize.aspectRatio);

    final RenderView renderView = RenderView(
      window: WidgetsBinding.instance!.window,
      child: RenderPositionedBox(
          alignment: Alignment.center, child: repaintBoundary),
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

    final RenderObjectToWidgetElement<RenderBox> rootElement =
    RenderObjectToWidgetAdapter<RenderBox>(
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

    final ui.Image image = await repaintBoundary.toImage(
        pixelRatio: imageSize.width / logicalSize.width);
    final ByteData? byteData =
    await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    var userId = Provider.of<UserModel>(context).partnerId;
    var token = Provider.of<UserModel>(context).token;
    var deviceSize = MediaQuery.of(context).size;
    final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');
    final DateFormat timeFormatter = DateFormat('HH:mm');
    dynamic readings = {
      'Blood Glucose': ['${bgMeasure.toString()} mg/dL', 'date: $dateBg'],
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
    var categories = [
      'Blood Glucose',
      'Blood Pressure',
      'Body Temperature',
      'ECG',
      'SPO2'
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor, //change your color here
        ),
        centerTitle: true,
        title: Text(
          'Health Monitor',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: () {
                _refreshIndicatorKey.currentState!.show();
              }),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: LoaderOverlay(
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RoundedButton(
                    buttonText: 'History',
                    textColor: Theme.of(context).primaryColor,
                    buttonColor: const Color(0xFFCBCFD1),
                    buttonFunction: () {
                      Navigator.pushNamed(context, HealthMonitor.id);
                    },
                  ),
                  RoundedButton(
                    buttonText: 'Instructions',
                    textColor: Theme.of(context).primaryColor,
                    buttonColor: const Color(0xFFCBCFD1),
                    buttonFunction: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                        return const HmInstructions();
                      }));
                    },
                  ),
                ],
              ),
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
                                    itemCount: readings[categories[i]].length,
                                    itemBuilder: (context, j) {
                                      var temp = readings[categories[i]][j]
                                          .toString()
                                          .split(' ');
                                      var n = temp.length;
                                      if (n < 3) {
                                        if (temp[0] == 'null' ||
                                            temp[1] == 'null' ||
                                            temp[1] == 'null%') {
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
                                          readings[categories[i]][j].toString(),
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
              LoaderOverlay(
                child: Visibility(
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
                                buttonText: 'Save',
                                buttonColor: uploaded == false
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                                buttonFunction: () async {
                                  if (uploaded == false) {
                                    var img64 = null;
                                    if (ecgWave != null) {
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
                                      var img = await createImageFromWidget(
                                          WaveSegments(
                                              data: waveData,
                                              zoomLevel: 1.0,
                                              globalKey: globalKey));
                                      img64 = base64Encode(img);
                                    }
                                    var dateTimeBg = dateBg.toString() != 'null'
                                        ? DateFormat('yyyy-MM-dd HH:mm:ss')
                                        .parse(dateBg)
                                        .toLocal()
                                        : null;
                                    var dateTimeBp = dateBp.toString() != 'null'
                                        ? DateFormat('yyyy-MM-dd HH:mm:ss')
                                        .parse(dateBp)
                                        .toLocal()
                                        : null;
                                    var dateTimeBt = dateBt.toString() != 'null'
                                        ? DateFormat('yyyy-MM-dd HH:mm:ss')
                                        .parse(dateBt)
                                        .toLocal()
                                        : null;
                                    var dateTimeEcg =
                                    dateEcg.toString() != 'null'
                                        ? DateFormat('yyyy-MM-dd HH:mm:ss')
                                        .parse(dateEcg)
                                        .toLocal()
                                        : null;
                                    var dateTimeSpo2 =
                                    dateSpo2.toString() != 'null'
                                        ? DateFormat('yyyy-MM-dd HH:mm:ss')
                                        .parse(dateSpo2)
                                        .toLocal()
                                        : null;
                                    var data = {
                                      'token': Provider.of<UserModel>(context,
                                          listen: false)
                                          .token
                                          .toString(),
                                      'blood_glucose': {
                                        'bg_measure': bgMeasure,
                                        'date_bg':
                                        dateTimeBg.toString().split('.')[0]
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
                                        'date_ecg': dateTimeEcg
                                            .toString()
                                            .split('.')[0],
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
                                    setState(() {
                                      uploaded = true;
                                    });
                                    context.loaderOverlay
                                        .show(widget: const LoadingScreen());
                                    var response =
                                    await HmApi.postReadings(data);
                                    context.loaderOverlay.hide();
                                    int status =
                                    json.decode(response.body)['result']
                                    ['status'];
                                    if (status == 200) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.green,
                                          content: Text("Data Uploaded"),
                                        ),
                                      );
                                      _clear();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text("Data Upload Failed!"),
                                        ),
                                      );
                                      setState(() {
                                        uploaded = false;
                                      });
                                    }
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
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                  visible: !checkReadings(),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Launch Health Monitor\n',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF707070)
                          ),),
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: GestureDetector(
                            child: const Image(image: AssetImage('assets/powericon.png'), width: 300, height: 300,),
                            onTap: () async {
                              await openHealthMonitor(context);
                              assignReadings();
                            },
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class HmInstructions extends StatefulWidget {
  const HmInstructions({Key? key}) : super(key: key);

  @override
  _HmInstructionsState createState() => _HmInstructionsState();
}

class _HmInstructionsState extends State<HmInstructions> {
  String dropdownvalue = 'Blood Glucose';
  var categories = [
    'Blood Glucose',
    'Blood Pressure',
    'Body Temperature',
    'ECG',
    'SPO2'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor, //change your color here
        ),
        centerTitle: true,
        title: Text(
          'Instructions',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          DropdownButton(
            // Initial Value
            value: dropdownvalue,
            // Down Arrow Icon
            icon: const Icon(Icons.keyboard_arrow_down),
            // Array list of items
            items: categories.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            // After selecting the desired option,it will
            // change button value to selected value
            onChanged: (String? newValue) {
              setState(() {
                dropdownvalue = newValue!;
              });
            },
          ),
          Visibility(
            visible: dropdownvalue == 'Blood Glucose',
            child: Expanded(
              child: ListView(
                shrinkWrap: true,
                children: const [
                  Image(
                    image: AssetImage('assets/bg_inst.png'),
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: dropdownvalue == 'Blood Pressure',
            child: Expanded(
              child: ListView(
                shrinkWrap: true,
                children: const [
                  Image(
                    image: AssetImage('assets/bp_inst1.png'),
                  ),
                  Image(
                    image: AssetImage('assets/bp_inst2.png'),
                  ),
                  Image(
                    image: AssetImage('assets/bp_inst3.png'),
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: dropdownvalue == 'Body Temperature',
            child: Expanded(
              child: ListView(
                shrinkWrap: true,
                children: const [
                  Image(
                    image: AssetImage('assets/temp_inst.png'),
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: dropdownvalue == 'ECG',
            child: Expanded(
              child: ListView(
                shrinkWrap: true,
                children: const [
                  Image(
                    image: AssetImage('assets/ecg_inst.png'),
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: dropdownvalue == 'SPO2',
            child: Expanded(
              child: ListView(
                shrinkWrap: true,
                children: const [
                  Image(
                    image: AssetImage('assets/spo2_inst.png'),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



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

  bool uploaded = false;

  void _clear() async {
    await deleteNativePrefs();
    setState(() {
      bodyTemp = null;
      bgMeasure = null;
      systolicPressure = null;
      diastolicPressure = null;
      heartRateBp = null;
      rrMax = null;
      rrMin = null;
      heartRateEcg = null;
      hrv = null;
      mood = null;
      respiratoryRate = null;
      durationEcg = null;
      ecgWave = null;
      spo2 = null;
      heartRateSpo2 = null;
      dateSpo2 = null;
      dateBt = null;
      dateBp = null;
      dateEcg = null;
      dateBg = null;
      uploaded = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    assignReadings();
  }

  Future<void> deleteNativePrefs() async {
    try {
      var temp = await platform.invokeMethod('deleteData');
    } on PlatformException catch (e) {
      print(e.message);
    }
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
      uploaded = false;
    });
  }

  /// Creates an image from the given widget by first spinning up a element and render tree,
  /// then waiting for the given [wait] amount of time and then creating an image via a [RepaintBoundary].
  ///
  /// The final image will be of size [imageSize] and the the widget will be layout, ... with the given [logicalSize].
  Future<Uint8List> createImageFromWidget(Widget widget,
      {Duration? wait, Size? logicalSize, Size? imageSize}) async {
    final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

    logicalSize ??= ui.window.physicalSize / ui.window.devicePixelRatio;
    imageSize ??= ui.window.physicalSize;

    assert(logicalSize.aspectRatio == imageSize.aspectRatio);

    final RenderView renderView = RenderView(
      window: WidgetsBinding.instance!.window,
      child: RenderPositionedBox(
          alignment: Alignment.center, child: repaintBoundary),
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

    final RenderObjectToWidgetElement<RenderBox> rootElement =
    RenderObjectToWidgetAdapter<RenderBox>(
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

    final ui.Image image = await repaintBoundary.toImage(
        pixelRatio: imageSize.width / logicalSize.width);
    final ByteData? byteData =
    await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  String dropdownvalue = 'Blood Glucose';

  @override
  Widget build(BuildContext context) {
    var userId = Provider.of<UserModel>(context).partnerId;
    var token = Provider.of<UserModel>(context).token;
    var deviceSize = MediaQuery.of(context).size;
    final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');
    final DateFormat timeFormatter = DateFormat('HH:mm');
    dynamic readings = {
      'Blood Glucose': ['${bgMeasure.toString()} mg/dL', 'date: $dateBg'],
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
    var categories = [
      'Blood Glucose',
      'Blood Pressure',
      'Body Temperature',
      'ECG',
      'SPO2'
    ];
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor, //change your color here
          ),
          centerTitle: true,
          title: Text(
            'History',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
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
              Text('Blood Glucose History'),
              Text('Blood Pressure History'),
              Text('Body Temperature History'),
              Text('ECG History'),
              Text('SPO2 History')
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FutureBuilder(
                future: HmApi.getReadings(context, userId, token),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.data != null) {
                    return Column(
                      children: [
                        Visibility(
                          visible: snapshot.data
                              .where((HmModel x) =>
                          x.category == 'blood_glucose')
                              .toList()
                              .length >=
                              3,
                          child: Container(
                            height: 250,
                            width: deviceSize.width,
                            alignment: Alignment.topCenter,
                            child: DrawGraph(
                                data: snapshot.data
                                    .where((HmModel x) =>
                                x.category == 'blood_glucose')
                                    .toList()
                                    .reversed
                                    .toList()),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                if (snapshot.data[index].category ==
                                    'blood_glucose') {
                                  return Card(
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  const Text(
                                                    'Blood Glucose',
                                                    style: TextStyle(
                                                        color:
                                                        Color(0xFF707070)),
                                                  ),
                                                  Text(
                                                      '${snapshot.data[index].bgMeasure} mg/dL',
                                                      style: const TextStyle(
                                                          color:
                                                          Color(0xFF707070),
                                                          fontSize: 18,
                                                          fontWeight:
                                                          FontWeight.bold))
                                                ],
                                              ),
                                              ImageIcon(
                                                const AssetImage(
                                                    'assets/bg_icon.png'),
                                                size: 30,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              const Icon(
                                                Icons.calendar_today_rounded,
                                                size: 20,
                                                color: Color(0xFFCBCFD1),
                                              ),
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(7.0),
                                                child: Text(
                                                    dateFormatter.format(
                                                        DateTime.parse(snapshot
                                                            .data[index].date)),
                                                    style: const TextStyle(
                                                        color:
                                                        Color(0xFF707070))),
                                              ),
                                              const Icon(
                                                Icons.access_time,
                                                size: 20,
                                                color: Color(0xFFCBCFD1),
                                              ),
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(7.0),
                                                child: Text(
                                                    timeFormatter.format(
                                                        DateTime.parse(snapshot
                                                            .data[index].date)),
                                                    style: const TextStyle(
                                                        color:
                                                        Color(0xFF707070))),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
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
                    return Column(
                      children: [
                        Visibility(
                          visible: snapshot.data
                              .where((HmModel x) =>
                          x.category == 'blood_pressure')
                              .toList()
                              .length >=
                              3,
                          child: Container(
                            height: 250,
                            width: deviceSize.width,
                            alignment: Alignment.topCenter,
                            child: DrawGraph2(
                                data: snapshot.data
                                    .where((HmModel x) =>
                                x.category == 'blood_pressure')
                                    .toList()
                                    .reversed
                                    .toList()),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Sysytolic P.',
                                style: TextStyle(color: Colors.blue)),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Diastolic P.',
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                if (snapshot.data[index].category ==
                                    'blood_pressure') {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14.0, vertical: 6.5),
                                    child: Card(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      const Text('Systolic',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF707070),
                                                              fontSize: 13)),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(7.0),
                                                        child: Text(
                                                            snapshot.data[index]
                                                                .systolicPressure,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF707070),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize: 18)),
                                                      ),
                                                      const Text('mmHg',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF707070),
                                                              fontSize: 13))
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      bottom: 13.0),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 120,
                                                    width: 90,
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color: Theme.of(context)
                                                                    .primaryColor),
                                                            left: BorderSide(
                                                                color: Theme.of(context)
                                                                    .primaryColor),
                                                            right: BorderSide(
                                                                color: Theme.of(
                                                                    context)
                                                                    .primaryColor),
                                                            top: BorderSide(
                                                                color: Theme.of(
                                                                    context)
                                                                    .primaryColor))),
                                                    child: Column(
                                                      mainAxisSize:
                                                      MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          CupertinoIcons
                                                              .heart_circle,
                                                          size: 40,
                                                          color:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                        ),
                                                        const Text('Heart rate',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF707070),
                                                                fontSize: 16)),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .all(6.0),
                                                          child: Text(
                                                              snapshot
                                                                  .data[index]
                                                                  .heartRate,
                                                              style: const TextStyle(
                                                                  color: Color(
                                                                      0xFF707070),
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize:
                                                                  18)),
                                                        ),
                                                        const Text('BPM',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF707070),
                                                                fontSize: 16))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      const Text('Diastolic',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF707070),
                                                              fontSize: 13)),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(7.0),
                                                        child: Text(
                                                            snapshot.data[index]
                                                                .diastolicPressure,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF707070),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize: 18)),
                                                      ),
                                                      const Text('mmHg',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF707070),
                                                              fontSize: 13))
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              const Icon(
                                                Icons.calendar_today_rounded,
                                                size: 20,
                                                color: Color(0xFFCBCFD1),
                                              ),
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(7.0),
                                                child: Text(
                                                    dateFormatter.format(
                                                        DateTime.parse(snapshot
                                                            .data[index].date)),
                                                    style: const TextStyle(
                                                        color:
                                                        Color(0xFF707070))),
                                              ),
                                              const Icon(
                                                Icons.access_time,
                                                size: 20,
                                                color: Color(0xFFCBCFD1),
                                              ),
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(7.0),
                                                child: Text(
                                                    timeFormatter.format(
                                                        DateTime.parse(snapshot
                                                            .data[index].date)),
                                                    style: const TextStyle(
                                                        color:
                                                        Color(0xFF707070))),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
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
                    return Column(
                      children: [
                        Visibility(
                          visible: snapshot.data
                              .where((HmModel x) =>
                          x.category == 'body_temperature')
                              .toList()
                              .length >=
                              3,
                          child: Container(
                            height: 250,
                            width: deviceSize.width,
                            alignment: Alignment.topCenter,
                            child: DrawGraph(
                                data: snapshot.data
                                    .where((HmModel x) =>
                                x.category == 'body_temperature')
                                    .toList()
                                    .reversed
                                    .toList()),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                if (snapshot.data[index].category ==
                                    'body_temperature') {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 8.0),
                                    child: Card(
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 40.0, left: 15.0),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Body Temperature',
                                                  style: TextStyle(
                                                      color: Color(0xFF707070),
                                                      fontSize: 14),
                                                ),
                                                Text(
                                                    '${snapshot.data[index].bodyTemp} C',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color:
                                                        Color(0xFF707070),
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 18))
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                    left: 25.0,
                                                  ),
                                                  child: Icon(
                                                    CupertinoIcons.thermometer,
                                                    size: 50,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 7.0,
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      top: 8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .calendar_today_rounded,
                                                        size: 20,
                                                        color:
                                                        Color(0xFFCBCFD1),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(7.0),
                                                        child: Text(
                                                            dateFormatter.format(
                                                                DateTime.parse(
                                                                    snapshot
                                                                        .data[
                                                                    index]
                                                                        .date)),
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF707070))),
                                                      ),
                                                      const Icon(
                                                        Icons.access_time,
                                                        size: 20,
                                                        color:
                                                        Color(0xFFCBCFD1),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(7.0),
                                                        child: Text(
                                                            timeFormatter.format(
                                                                DateTime.parse(
                                                                    snapshot
                                                                        .data[
                                                                    index]
                                                                        .date)),
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF707070))),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
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
                          if (snapshot.data[index].category.toString() ==
                              'ecg' &&
                              snapshot.data[index].rrMax != null) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14.0, vertical: 6.5),
                              child: Card(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: 100,
                                              width: 100,
                                              color: const Color(0xFFEDEBEB),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Text('R-R',
                                                      style: TextStyle(
                                                          color:
                                                          Color(0xFF707070),
                                                          fontSize: 14)),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        3.0),
                                                    child: Text(
                                                        'Max: ${snapshot.data[index].rrMax}',
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xFF707070),
                                                            fontSize: 11)),
                                                  ),
                                                  Text(
                                                      'Min: ${snapshot.data[index].rrMin}',
                                                      style: const TextStyle(
                                                          color:
                                                          Color(0xFF707070),
                                                          fontSize: 11))
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 120,
                                              width: 90,
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Theme.of(
                                                              context)
                                                              .primaryColor),
                                                      left: BorderSide(
                                                          color: Theme.of(
                                                              context)
                                                              .primaryColor),
                                                      right: BorderSide(
                                                          color:
                                                          Theme.of(context)
                                                              .primaryColor),
                                                      top: BorderSide(
                                                          color: Theme.of(
                                                              context)
                                                              .primaryColor))),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ImageIcon(
                                                    const AssetImage(
                                                        'assets/lungs_icon.png'),
                                                    size: 40,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  const Text('Respiratory Rate',
                                                      style: TextStyle(
                                                          color:
                                                          Color(0xFF707070),
                                                          fontSize: 8)),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        3.0),
                                                    child: Text(
                                                        snapshot.data[index]
                                                            .respiratoryRate,
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xFF707070),
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 18)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: 100,
                                              width: 100,
                                              color: const Color(0xFFEDEBEB),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                      'Duration: ${snapshot.data[index].durationEcg}',
                                                      style: const TextStyle(
                                                          color:
                                                          Color(0xFF707070),
                                                          fontSize: 11)),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        3.0),
                                                    child: Text(
                                                        'Mood: ${snapshot.data[index].mood}',
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xFF707070),
                                                            fontSize: 11)),
                                                  ),
                                                  Text(
                                                      'HRV: ${snapshot.data[index].hrv}',
                                                      style: const TextStyle(
                                                          color:
                                                          Color(0xFF707070),
                                                          fontSize: 11)),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        3.0),
                                                    child: Text(
                                                        'Heart Rate: ${snapshot.data[index].heartRate}',
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xFF707070),
                                                            fontSize: 11)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          height: 60,
                                          width: 130,
                                          child: RoundedButton(
                                            buttonText: 'View ECG',
                                            buttonFunction: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                        return EcgReport(
                                                            img: snapshot
                                                                .data[index].ecgWave);
                                                      }));
                                            },
                                          ),
                                        ),
                                        const Icon(
                                          Icons.calendar_today_rounded,
                                          size: 20,
                                          color: Color(0xFFCBCFD1),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(7.0),
                                          child: Text(
                                              dateFormatter.format(
                                                  DateTime.parse(snapshot
                                                      .data[index].date)),
                                              style: const TextStyle(
                                                  color: Color(0xFF707070))),
                                        ),
                                        const Icon(
                                          Icons.access_time,
                                          size: 20,
                                          color: Color(0xFFCBCFD1),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(7.0),
                                          child: Text(
                                              timeFormatter.format(
                                                  DateTime.parse(snapshot
                                                      .data[index].date)),
                                              style: const TextStyle(
                                                  color: Color(0xFF707070))),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
                    return Column(
                      children: [
                        Visibility(
                          visible: snapshot.data
                              .where((HmModel x) => x.category == 'spo2')
                              .toList()
                              .length >=
                              3,
                          child: Container(
                            height: 250,
                            width: deviceSize.width,
                            alignment: Alignment.topCenter,
                            child: DrawGraph(
                                data: snapshot.data
                                    .where((HmModel x) => x.category == 'spo2')
                                    .toList()
                                    .reversed
                                    .toList()),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                if (snapshot.data[index].category == 'spo2') {
                                  return Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Card(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Column(
                                                  children: [
                                                    const Text('Spo2',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF707070))),
                                                    Text(
                                                        '${snapshot.data[index].spo2}%',
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xFF707070),
                                                            fontSize: 18,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold)),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    const Text('Heart Rate',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF707070))),
                                                    Text(
                                                        '${snapshot.data[index].heartRate} BPM',
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xFF707070),
                                                            fontSize: 18,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold))
                                                  ],
                                                ),
                                                Icon(
                                                  Icons.bloodtype,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  size: 40,
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: [
                                                const Icon(
                                                  Icons.calendar_today_rounded,
                                                  size: 20,
                                                  color: Color(0xFFCBCFD1),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.all(7.0),
                                                  child: Text(
                                                      dateFormatter.format(
                                                          DateTime.parse(
                                                              snapshot
                                                                  .data[index]
                                                                  .date)),
                                                      style: const TextStyle(
                                                          color: Color(
                                                              0xFF707070))),
                                                ),
                                                const Icon(
                                                  Icons.access_time,
                                                  size: 20,
                                                  color: Color(0xFFCBCFD1),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.all(7.0),
                                                  child: Text(
                                                      timeFormatter.format(
                                                          DateTime.parse(
                                                              snapshot
                                                                  .data[index]
                                                                  .date)),
                                                      style: const TextStyle(
                                                          color: Color(
                                                              0xFF707070))),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
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

                return Transform.rotate(
                  angle: math.pi,
                  child: GridPaper(
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

                return Transform.rotate(
                  angle: math.pi,
                  child: GridPaper(
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

                return Transform.rotate(
                  angle: math.pi,
                  child: GridPaper(
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

                return Transform.rotate(
                  angle: math.pi,
                  child: GridPaper(
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
  const EcgReport({Key? key, required this.img}) : super(key: key);

  final dynamic img;
  static GlobalKey globalKey = GlobalKey();
  static dynamic image_final;

  Future<void> _capturePng() async {
    RenderRepaintBoundary? boundary =
    globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    ui.Image image = await boundary!.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    var img64 = base64Encode(pngBytes);
    image_final = pngBytes;
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
            height: 5,
          ),
          RepaintBoundary(
            key: globalKey,
            child: Image(
              image: NetworkImage(img),
            ),
          ),
          SizedBox(
              height: 70,
              width: 150,
              child: RoundedButton(
                buttonText: 'share',
                buttonColor: Theme.of(context).primaryColor,
                buttonFunction: () async {
                  await _capturePng();
                  final temp = await getTemporaryDirectory();
                  var path = '${temp.path}/image.png';
                  File(path).writeAsBytesSync(image_final);
                  await Share.shareFiles([path]);
                },
              )),
        ],
      ),
    );
  }
}
