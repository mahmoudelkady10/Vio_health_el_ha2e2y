import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medic_app/network/follow_up_api.dart';
import 'package:medic_app/widgets/loading_screen.dart';
import 'package:medic_app/widgets/rounded_button.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:expandable/expandable.dart';

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
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 85),
          child: Text(
            "Follow Up",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
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
                          height: 100,
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
                                        height: 140),
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16.0),
                                    topRight: Radius.circular(16.0),
                                  ),
                                ),
                                Text(snapshot.data[index].name,
                                    style:
                                        const TextStyle(color: Colors.black)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      onTap: () async {
                        var readings = await FollowUpApi.getReadings(
                            context, snapshot.data[index].categoryId);
                        NDate = DateTime.parse(readings[0].date);
                        Map<dynamic, List<Map<String, dynamic>>>
                            sortedReadings = {};
                        // {'sub_category': i.sub_category, 'readings': i.readings}
                            for (var i in readings) {
                                if (sortedReadings[i.date] != null) {
                                  sortedReadings[i.date]!.add({
                                    'sub_category': i.sub_category,
                                    'readings': i.readings
                                  });
                                } else {
                                  sortedReadings[i.date] = [];
                                }
                            }
                        print(sortedReadings);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return PastReadings(
                            categoryId: snapshot.data[index].categoryId,
                            sortedReadings: sortedReadings,
                          );
                        }));
                      },
                    ),
                  );
                });
          } else {
            return const Center(
              child: Text('try again'),
            );
          }
        },
      ),
    );
  }
}

class PastReadings extends StatefulWidget {
  const PastReadings(
      {Key? key, required this.categoryId, required this.sortedReadings})
      : super(key: key);
  final int categoryId;
  final Map<dynamic, List> sortedReadings;

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

  // @override
  // void initState() {
  //   super.initState();
  //   getSortedReadings();
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 85),
          child: Text(
            "History",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder(
          future: FollowUpApi.getReadings(context, widget.categoryId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Card(
                            elevation: 10,
                            child: ExpandablePanel(
                                header: Padding(
                                  padding: const EdgeInsets.only(top: 9.0),
                                  child: Text(snapshot.data[index].date,
                                      textAlign: TextAlign.center,
                                      style:
                                          const TextStyle(color: Colors.black)),
                                ),
                                collapsed: const SizedBox.shrink(),
                                expanded: ListView.builder(
                                    itemCount: widget
                                        .sortedReadings[
                                            snapshot.data[index].date]!
                                        .length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, j) {
                                      return Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                    '${widget.sortedReadings[snapshot.data[index].date]![j]['sub_category']}: '),
                                                Text(widget.sortedReadings[
                                                snapshot.data[index]
                                                    .date]![j]
                                                ['readings']),
                                              ],
                                            ),
                                          ]);
                                    }))),
                      );
                    } else if (snapshot.data[index].date !=
                        snapshot.data[index - 1].date) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Card(
                            elevation: 10,
                            child: ExpandablePanel(
                                header: Padding(
                                  padding: const EdgeInsets.only(top: 9.0),
                                  child: Text(snapshot.data[index].date,
                                      textAlign: TextAlign.center,
                                      style:
                                          const TextStyle(color: Colors.black)),
                                ),
                                collapsed: const SizedBox.shrink(),
                                expanded: ListView.builder(
                                    itemCount: widget
                                        .sortedReadings[
                                            snapshot.data[index].date]!
                                        .length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, j) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                        child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                      '${widget.sortedReadings[snapshot.data[index].date]![j]['sub_category']}: '),
                                                  Text(widget.sortedReadings[
                                                  snapshot.data[index]
                                                      .date]![j]
                                                  ['readings']),
                                                ],
                                              ),
                                            ]),
                                      );
                                    }))),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  });
            } else {
              return const Center(
                child: Text('try again'),
              );
            }
          }),
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
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
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
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            controllers[snapshot.data[index].subCategoryId] =
                                TextEditingController();
                            return Card(
                              elevation: 10,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(snapshot.data[index].name,
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                                  Center(
                                    child: TextField(
                                      controller: controllers[
                                          snapshot.data[index].subCategoryId],
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                      decoration: InputDecoration(
                                        hintText: snapshot.data[index].name
                                            .toString(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
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
                          for (var key in controllers.keys) {
                            var status = await FollowUpApi.postReadings(
                                context,
                                widget.categoryId,
                                key,
                                controllers[key]!.text,
                                DateTime.now());
                            if (status == 200) {
                              successful = true;
                            } else {
                              successful = false;
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
                  child: Text('try again'),
                );
              }
            }),
      ),
    );
  }
}
