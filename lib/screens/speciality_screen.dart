import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:medic_app/network/services_api.dart';
import 'package:medic_app/network/specialties_api.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:medic_app/widgets/rounded_button.dart';

class Services extends StatelessWidget {
  const Services({Key? key}) : super(key: key);
  static const id = 'services_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(80),
          child: Text("Specialties",style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: FutureBuilder(
          future: SpecialtiesApi.getSpecialties(context),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              return Flex(
                direction: Axis.vertical,
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: SizedBox(
                              height: 120,
                              child: Card(
                                elevation: 4,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: SizedBox(
                                  height: 70,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: Container(
                                                height: 100,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            snapshot.data[index].imageUrl),
                                                        fit: BoxFit.fill)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          title: Text(snapshot.data[index].name, style: TextStyle(color:Theme.of(context).primaryColor)),
                                          subtitle: Text(
                                              snapshot.data[index].description,style: const TextStyle(color: Color(0xFFB22234))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              if (snapshot.data[index].extras != false) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SubServices(
                                              specialty: snapshot
                                                  .data[index].name
                                                  .toString(),
                                              extras: snapshot
                                                  .data[index].extras
                                                  .toString(),
                                            )));
                              }
                            },
                          );
                        }),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No Specialties found'));
            }
          },
        ),
      ),
    );
  }
}

class SubServices extends StatelessWidget {
  const SubServices({Key? key, required this.extras, required this.specialty})
      : super(key: key);
  final String extras;
  final String specialty;

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    Icon icon = const Icon(
      Icons.local_hospital_outlined,
      size: 35,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(specialty),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Html(
          data: extras,
        ),
      ),
    );
  }
}

class Extras {
  final String extras;

  const Extras(this.extras);
}

class Specialty {
  final String specialty;

  const Specialty(this.specialty);
}
