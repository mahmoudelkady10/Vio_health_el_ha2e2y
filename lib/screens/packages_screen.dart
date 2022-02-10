import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:medic_app/model/doctors_model.dart';
import 'package:medic_app/model/services_model.dart';
import 'package:medic_app/model/specialties_model.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/network/doctors_api.dart';
import 'package:medic_app/network/packages_api.dart';
import 'package:medic_app/network/service_request_api.dart';
import 'package:medic_app/network/services_api.dart';
import 'package:medic_app/network/specialties_api.dart';
import 'package:medic_app/widgets/loading_screen.dart';
import 'package:medic_app/widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:medic_app/model/packages_model.dart';
import 'package:intl/intl.dart';

import 'booking_screen.dart';
import 'home_screen.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({Key? key}) : super(key: key);
  static const id = 'packages_screen';

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Packages'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder(
        future: PackagesApi.getPackages(context),
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
                  return GestureDetector(
                    child: SizedBox(
                      width: deviceSize.width,
                      height: 80,
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 8.0, left: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Package Code',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  // const Text('     '),
                                  Text('Package',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                                  Text("Price",
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                                  Text('Status',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(snapshot.data[index].name.toString()),
                                Text(snapshot.data[index].packageId.toString()),
                                Text(snapshot.data[index].price.toString()),
                                Text(snapshot.data[index].state.toString()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return PackageContent(
                          packageId: snapshot.data[index].id,
                        );
                      }));
                    },
                  );
                });
          } else {
            return const Center(
              child: Text('no packages found'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const BuyPackage()));
        },
        tooltip: 'Buy New Package',
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

class PackageContent extends StatefulWidget {
  const PackageContent({Key? key, required this.packageId}) : super(key: key);
  final int packageId;

  @override
  State<PackageContent> createState() => _PackageContentState();
}

class _PackageContentState extends State<PackageContent> {
  DateTime updatedDate = DateTime.now();

  List<DateTime> getSchedule(context) {
    List<PackagesContentModel> content =
        Provider.of<PackagesContentList>(context).packagesContent;
    List<DateTime> temp = [];
    var i = 0;
    for (var index in content) {
      DateTime? formattedDate = DateFormat('yyyy-MM-dd').parse(index.startDate);
      if (i >= 1) {
        if (formattedDate.toString().split('-')[1] ==
            temp[i - 1].toString().split('-')[1]) {
          continue;
        }
      }
      i++;
      temp.add(formattedDate);
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Package content'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder(
        future: PackagesApi.getPackagesContent(context, widget.packageId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            var dates = getSchedule(context);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Choose Date to view content'),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: dates.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            SizedBox(
                              height: 80,
                              width: 115,
                              child: RoundedButton(
                                  buttonColor: updatedDate == dates[index]
                                      ? Colors.blueGrey
                                      : Theme.of(context).primaryColor,
                                  buttonText:
                                      DateFormat.MMMM().format(dates[index]),
                                  buttonFunction: () {
                                    setState(() {
                                      updatedDate = dates[index];
                                    });
                                  }),
                            ),
                            const SizedBox(
                              width: 4,
                            )
                          ],
                        );
                      }),
                ),
                Text(
                    'Available services in ${DateFormat.MMMM().format(updatedDate)}'),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      if (snapshot.data[index].startDate
                              .toString()
                              .split('-')[1] ==
                          DateFormat('yyyy-MM-dd')
                              .format(updatedDate)
                              .toString()
                              .split('-')[1]) {
                        return SizedBox(
                          width: deviceSize.width,
                          height: 100,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(snapshot.data[index].specialty
                                    .toString()),
                                Text(snapshot.data[index].startDate
                                    .toString()),
                                Text(snapshot.data[index].service.toString()),
                                SizedBox(
                                  height: 70,
                                  width: 90,
                                  child: RoundedButton(
                                    buttonColor:
                                        Theme.of(context).primaryColor,
                                    buttonText: 'Book',
                                    buttonFunction: () async {
                                      var specialties =
                                          await SpecialtiesApi.getSpecialties(
                                              context);
                                      var packageSpecialty = specialties
                                          .where((SpecialtiesModel x) =>
                                              x.name ==
                                              snapshot.data[index].specialty)
                                          .toList();
                                      //TODO filter with service class instead
                                      var services =
                                          await ServicesApi.getServices(
                                              context);
                                      var packageService = services
                                          .where((ServicesModel x) =>
                                              x.name ==
                                              snapshot.data[index].service)
                                          .toList();
                                      print(packageService);
                                      Navigator.push(context,
                                          MaterialPageRoute(
                                              builder: (context) {
                                        return BookingD(
                                          type: packageService.first.id!,
                                          specialtyId:
                                              packageSpecialty.first.id!,
                                          doctorId:
                                              packageService[0].doctorId,
                                          date: DateFormat('yyyy-MM-dd').parse(snapshot.data[index].startDate),
                                        );
                                      }));
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
              ],
            );
          } else {
            return const Center(
              child: Text('Unable to get package content'),
            );
          }
        },
      ),
    );
  }
}

class BuyPackage extends StatelessWidget {
  const BuyPackage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy new Package'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder(
          future: PackagesApi.availablePackages(context),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              return LoaderOverlay(
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: SizedBox(
                          width: deviceSize.width,
                          height: 80,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8.0, left: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        'Package Code',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      // const Text('     '),
                                      Text('Category',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                      Text("Price",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(snapshot.data[index].name.toString()),
                                    Text(snapshot.data[index].mainCategory
                                        .toString()),
                                    Text(snapshot.data[index].price.toString()),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () async {

                          var balance =
                              Provider.of<UserModel>(context, listen: false)
                                  .balance;
                          if (balance < snapshot.data[index].price) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text("Top Up wallet"),
                              ),
                            );
                          } else {
                            await showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Center(
                                    child: Icon(
                                      Icons.monetization_on,
                                      color: Colors.green,
                                      size: 40,
                                    )),
                                content: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'Buy Package using wallet?',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async{
                                      var temp = [snapshot.data[index].id];
                                      Navigator.pop(context);
                                      context.loaderOverlay.show(
                                          widget: const LoadingScreen());
                                      var status = await ServiceRequestApi.serviceRequest(
                                          context,
                                          DateTime.now(),
                                          false,
                                          temp,
                                          6,
                                          snapshot.data[index].mainCategory);
                                      context.loaderOverlay.hide();
                                      if (status != 200) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text("Request Failed"),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            backgroundColor: Colors.green,
                                            content: Text("Request Successful"),
                                          ),
                                        );
                                        Navigator.pushReplacementNamed(
                                            context, MyHomePage.id);
                                      }
                                    },
                                    child: Text('Buy Package',
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
                                    child: Text('Cancel',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor,
                                            decoration: TextDecoration
                                                .underline)),
                                  )
                                ],
                              ),
                            );

                          }
                        },
                      );
                    }),
              );
            } else {
              return const Center(
                child: Text('no packages found'),
              );
            }
          }),
    );
  }
}
