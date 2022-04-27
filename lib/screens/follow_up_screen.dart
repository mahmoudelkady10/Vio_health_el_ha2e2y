import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medic_app/model/follow_up_model.dart';
import 'package:medic_app/model/lab_model.dart';
import 'package:medic_app/network/follow_up_api.dart';
import 'package:medic_app/screens/lab_screen.dart';
import 'package:medic_app/screens/medication_screen.dart';
import 'package:medic_app/screens/radiology_screen.dart';
import 'package:medic_app/widgets/graph_drawer.dart';
import 'package:medic_app/widgets/loading_screen.dart';
import 'package:medic_app/widgets/rounded_button.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:intl/intl.dart';

class FollowUpDashboard extends StatelessWidget {
  const FollowUpDashboard({Key? key}) : super(key: key);
  static const id = 'follow_up_dashboard';

  @override
  Widget build(BuildContext context) {
    List options = [
      'Follow up',
      'Lab',
      'Radiology',
      'Medication'
    ];
    List icons = [
      ImageIcon(
        const AssetImage('assets/follow_up.png'),
        size: 75,
        color: Theme.of(context).primaryColor,
      ),
      ImageIcon(
        const AssetImage('assets/lab_icon.png'),
        size: 75,
        color: Theme.of(context).primaryColor,
      ),
      ImageIcon(
        const AssetImage('assets/radicon.png'),
        size: 75,
        color: Theme.of(context).primaryColor,
      ),
      ImageIcon(
        const AssetImage('assets/medication.png'),
        size: 75,
        color: Theme.of(context).primaryColor,
      ),
    ];

    List screens = [FollowUp.id, LabApointments.id, Radiology.id, Medication.id];
    var deviceSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 1,
              mainAxisSpacing: 1,
              crossAxisSpacing: 3),
          itemCount: options.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: optioncardS(deviceSize, icons[index], options[index],
                  screens[index], context),
            );
          }),
    );
  }

  SizedBox optioncardS(Size deviceSize, dynamic icon, String option,
      String screen, BuildContext context) {
    return SizedBox(
      height: deviceSize.height * 0.35,
      width: deviceSize.width * 0.31,
      child: Center(
        child: Card(
          elevation: 10,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(15.0),
            title: icon,
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                option,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, screen);
            },
          ),
        ),
      ),
    );
  }
}

class FollowUp extends StatefulWidget {
  const FollowUp({Key? key}) : super(key: key);
  static const id = 'follow_up_screen';

  @override
  State<FollowUp> createState() => _FollowUpState();
}

class _FollowUpState extends State<FollowUp> {
  DateTime? NDate;

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor, //change your color here
        ),
        centerTitle: true,
        title: Text(
          "Follow Up",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: FollowUpApi.getCategories(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 1,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 3),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, left: 10.0, right: 10.0),
                    child: GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: SizedBox(
                          width: deviceSize.width,
                          height: 110,
                          child: Card(
                            elevation: 10,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  child: Center(
                                    child: Image.network(
                                        snapshot.data[index].image.toString(),
                                        width: 130,
                                        height: 130),
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16.0),
                                    topRight: Radius.circular(16.0),
                                  ),
                                ),
                                Text(snapshot.data[index].name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Theme.of(context).primaryColor)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      onTap: () async {
                        // var readings = await FollowUpApi.getReadings(
                        //     context, snapshot.data[index].categoryId);
                        // NDate = DateTime.parse(readings[0].date);
                        // Map<dynamic, List<Map<String, dynamic>>>
                        //     sortedReadings = {};
                        // // {'sub_category': i.sub_category, 'readings': i.readings}
                        // for (var i in readings) {
                        //   if (sortedReadings[i.date] != null) {
                        //     sortedReadings[i.date]!.add({
                        //       'sub_category': i.sub_category,
                        //       'readings': i.readings
                        //     });
                        //   } else {
                        //     sortedReadings[i.date] = [];
                        //   }
                        // }
                        // print(sortedReadings);
                        var tabs = [];
                        var readings = await FollowUpApi.getReadings(
                            context, snapshot.data[index].categoryId);
                        for (var i in readings) {
                          if (!tabs.contains(i.sub_category)) {
                            tabs.add(i.sub_category.toString());
                          } else {
                            print(tabs);
                            continue;
                          }
                        }
                        print(tabs);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return PastReadings(
                            categoryId: snapshot.data[index].categoryId,
                            tabs: tabs,
                            readings: readings,
                          );
                        }));
                      },
                    ),
                  );
                });
          } else {
            return const Center(
              child: Text('No records found.'),
            );
          }
        },
      ),
    );
  }
}

class PastReadings extends StatefulWidget {
  const PastReadings(
      {Key? key,
      required this.categoryId,
      required this.tabs,
      required this.readings})
      : super(key: key);
  final int categoryId;
  final List<FollowUpReadingsModel> readings;
  final List tabs;

  @override
  _PastReadingsState createState() => _PastReadingsState();
}

class _PastReadingsState extends State<PastReadings> {
  // Future<void> getSortedReadings() async {
  //   var readings = await FollowUpApi.getReadings(context, widget.categoryId);
  //   Map<dynamic, List> sortedReadings = {};
  //   // {'sub_category': i.sub_category, 'readings': i.readings}
  //   for (var i in readings) {
  //     sortedReadings[i.date]!
  //         .add({'sub_category': i.sub_category, 'readings': i.readings});
  //   }
  //   print(sortedReadings);
  //   _sortedReadings = sortedReadings;
  // }
  // static List<FollowUpReadingsModel> readings = [];
  // static List tabs= [];
  // Future<void> getReadings() async {
  //   PastReadings.readings =
  //       await FollowUpApi.getReadings(context, widget.categoryId);
  //   var j = 0;
  //   for (var i in PastReadings.readings) {
  //     if (PastReadings.readings[j].sub_category != PastReadings.readings.last.sub_category){
  //     if (i.sub_category != PastReadings.readings[j+1].sub_category) {
  //       PastReadings.tabs.add(i.sub_category.toString());
  //     } else {
  //       print(PastReadings.tabs);
  //       break;
  //     }
  //     }
  //     j++;
  //   }
  // }
  final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');
  final DateFormat timeFormatter = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return DefaultTabController(
      length: widget.tabs.length,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor, //change your color here
          ),
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 85),
            child: Text(
              "History",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          bottom: TabBar(
            unselectedLabelStyle: const TextStyle(fontSize: 14.0),
            labelStyle:
                const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            labelPadding: const EdgeInsets.all(8.0),
            isScrollable: true,
            unselectedLabelColor: const Color(0xFF979797),
            labelColor: const Color(0xFF707070),
            indicatorColor: Colors.white,
            indicatorWeight: 0.5,
            tabs: widget.tabs.map((e) {
              return Tab(
                text: e.toString(),
              );
            }).toList(),
          ),
          backgroundColor: Colors.white,
        ),
        body: TabBarView(
          children: widget.tabs.map((e) {
            return FutureBuilder(
                future: FollowUpApi.getReadings(context, widget.categoryId),
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
                                  .where((FollowUpReadingsModel x) =>
                                      x.sub_category == e && x.type == 'single')
                                  .toList()
                                  .length >=
                              7,
                          child: Container(
                            height: 250,
                            width: deviceSize.width,
                            alignment: Alignment.topCenter,
                            child: DrawGraph3(
                                data: snapshot.data
                                            .where((FollowUpReadingsModel x) =>
                                                x.sub_category == e &&
                                                x.type == 'combine')
                                            .toList()
                                            .length >=
                                        7
                                    ? snapshot.data
                                        .where((FollowUpReadingsModel x) =>
                                            x.sub_category == e)
                                        .toList()
                                        .getRange(0, 7).toList().reversed.toList()
                                    : snapshot.data
                                        .where((FollowUpReadingsModel x) =>
                                            x.sub_category == e)
                                        .toList()
                                        .reversed
                                        .toList()),
                          ),
                        ),
                        Visibility(
                          visible: snapshot.data
                                  .where((FollowUpReadingsModel x) =>
                                      x.sub_category == e &&
                                      x.type == 'combine')
                                  .toList()
                                  .length >=
                              7,
                          child: Container(
                            height: 250,
                            width: deviceSize.width,
                            alignment: Alignment.topCenter,
                            child: DrawGraph4(
                                data: snapshot.data
                                            .where((FollowUpReadingsModel x) =>
                                                x.sub_category == e &&
                                                x.type == 'combine')
                                            .toList()
                                            .length >=
                                        7
                                    ? snapshot.data
                                        .where((FollowUpReadingsModel x) =>
                                            x.sub_category == e)
                                        .toList()
                                        .getRange(0, 7).toList()
                                        .reversed
                                        .toList()
                                    : snapshot.data
                                        .where((FollowUpReadingsModel x) =>
                                            x.sub_category == e)
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
                                if (snapshot.data[index].sub_category == e) {
                                  return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0, top: 6.0),
                                      child: Card(
                                        elevation: 10,
                                        child: Column(children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 7.0, vertical: 7.0),
                                            child: Container(
                                              alignment: Alignment.topLeft,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${snapshot.data[index].sub_category}',
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFF707070),
                                                        fontSize: 14),
                                                  ),
                                                  Text(
                                                      '${snapshot.data[index].readings}',
                                                      textAlign: TextAlign.left,
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xFF707070),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18))
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
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
                                        ]),
                                      ));
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }),
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: Text('No records Found'),
                    );
                  }
                });
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Center(
                    child: Icon(
                  Icons.announcement_outlined,
                  color: Theme.of(context).primaryColor,
                  size: 50,
                )),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text('Add your new records',
                        style: TextStyle(color: Colors.black)),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return PostReadings(categoryId: widget.categoryId);
                      }));
                    },
                    child: Text('ok',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.underline)),
                  )
                ],
              ),
            );
          },
          child: Icon(
            Icons.add,
            color: Colors.blue.shade700,
          ),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}

class PostReadings extends StatefulWidget {
  const PostReadings({Key? key, required this.categoryId}) : super(key: key);
  final int categoryId;

  @override
  _PostReadingsState createState() => _PostReadingsState();
}

class _PostReadingsState extends State<PostReadings> {
  Map<int, TextEditingController> controllers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 70),
          child: Text(
            "New Readings",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: LoaderOverlay(
        child: FutureBuilder(
            future: FollowUpApi.getSubCategories(context, widget.categoryId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListView.builder(
                        itemCount: snapshot.data.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          controllers[snapshot.data[index].subCategoryId] =
                              TextEditingController();
                          if (snapshot.data[index].type == 'single') {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 10,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(snapshot.data[index].name,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor)),
                                    Center(
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: controllers[
                                            snapshot.data[index].subCategoryId],
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                        decoration: InputDecoration(
                                          hintText: snapshot.data[index].name
                                              .toString(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else if (snapshot.data[index].type == 'combine') {
                            TextEditingController temp =
                                TextEditingController();
                            TextEditingController temp2 =
                                TextEditingController();
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 10,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(snapshot.data[index].name,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor)),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 60,
                                          width: 100,
                                          child: TextField(
                                            keyboardType: TextInputType.number,
                                            controller: temp2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                            decoration: InputDecoration(
                                              hintText: snapshot
                                                  .data[index].name
                                                  .toString(),
                                            ),
                                            onChanged: (String x) {
                                              controllers[snapshot.data[index]
                                                          .subCategoryId]!
                                                      .text =
                                                  '${temp2.text}${snapshot.data[index].operator.toString()}${temp.text}';
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(snapshot
                                              .data[index].operator
                                              .toString()),
                                        ),
                                        SizedBox(
                                          height: 60,
                                          width: 100,
                                          child: TextField(
                                            keyboardType: TextInputType.number,
                                            controller: temp,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                            decoration: InputDecoration(
                                              hintText: snapshot
                                                  .data[index].name
                                                  .toString(),
                                            ),
                                            onChanged: (String x) {
                                              controllers[snapshot.data[index]
                                                          .subCategoryId]!
                                                      .text =
                                                  '${temp2.text}${snapshot.data[index].operator.toString()}${temp.text}';
                                            },
                                          ),
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
                    SizedBox(
                      width: 100,
                      height: 60,
                      child: RoundedButton(
                        buttonText: 'Submit',
                        buttonColor: Theme.of(context).primaryColor,
                        buttonFunction: () async {
                          bool successful = false;
                          context.loaderOverlay
                              .show(widget: const LoadingScreen());
                          print(DateFormat("yyyy-MM-dd HH:mm")
                              .parse(DateTime.now().toLocal().toString()));
                          for (var key in controllers.keys) {
                            if (controllers[key]!.text.isNotEmpty) {
                              var status = await FollowUpApi.postReadings(
                                  context,
                                  widget.categoryId,
                                  key,
                                  controllers[key]!.text,
                                  DateFormat("yyyy-MM-dd HH:mm").parse(
                                      DateTime.now().toLocal().toString()));
                              if (status == 200) {
                                successful = true;
                              } else {
                                successful = false;
                              }
                            }
                          }
                          context.loaderOverlay.hide();
                          if (successful == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text("readings submitted"),
                              ),
                            );
                            Navigator.pushReplacementNamed(
                                context, FollowUp.id);
                          }
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text('No records found'),
                );
              }
            }),
      ),
    );
  }
}
