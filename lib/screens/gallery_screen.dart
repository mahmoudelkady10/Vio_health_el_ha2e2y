import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/network/appointments_api.dart';
import 'package:medic_app/network/gallery_api.dart';
import 'package:medic_app/widgets/loading_screen.dart';
import 'package:medic_app/widgets/rounded_button.dart';
import 'package:medic_app/widgets/unit_request_card.dart';
import 'package:medic_app/widgets/validated_text_field.dart';
import 'package:provider/provider.dart';
import 'package:loader_overlay/loader_overlay.dart';

class PastAppointments extends StatelessWidget {
  const PastAppointments({Key? key}) : super(key: key);
  static const id = 'history_screen';

  @override
  Widget build(BuildContext context) {
    int? userId = Provider.of<UserModel>(context).partnerId;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Choose appointment'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: FutureBuilder(
          future: AppointmentsApi.getAppointments(
              context, userId, Provider.of<UserModel>(context).token),
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
                                      builder: (context) => Gallery(
                                            appId: snapshot.data[index].id,
                                            doctorId:
                                                snapshot.data[index].doctorId,
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

class Gallery extends StatefulWidget {
  const Gallery({Key? key, required this.appId, required this.doctorId})
      : super(key: key);
  static const id = 'gallery_screen';
  final int appId;
  final int doctorId;

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(80),
          child: Text('Gallery',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.add_a_photo_outlined),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PickImage(
                              appId: widget.appId,
                              doctorId: widget.doctorId,
                            )));
              },
            ),
          ),
          // add more IconButton
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder(
          future: GalleryApi.getGallery(context, widget.appId),
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Card(
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            child: Center(
                              child: Image.network(
                                  snapshot.data[index].image.toString()),
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Text(snapshot.data[index].comment.toString(),
                                      style: const TextStyle(
                                          color: Color(0xFFB22234))),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(snapshot.data[index].date,
                                          style: const TextStyle(
                                              color: Color(0xFFB22234))),
                                      if (snapshot.data[index].doctor != null)
                                        Text(snapshot.data[index].doctor,
                                            style: const TextStyle(
                                                color: Color(0xFFB22234))),
                                    ],
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('no posts found'));
            }
          }),
    );
  }
}

class AppId {
  final int appId;

  const AppId(this.appId);
}

class PickImage extends StatefulWidget {
  const PickImage({Key? key, required this.appId, required this.doctorId})
      : super(key: key);
  final int appId;
  final int doctorId;

  @override
  _PickImageState createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  static Uint8List? _image;
  static dynamic img64;
  final _picker = ImagePicker();
  final myController = TextEditingController();
  static dynamic _imagefile;
  static DateTime date = DateTime.now();

  Future<void> _pickImageCamera(context) async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = File(image!.path).readAsBytesSync();
      _imagefile = File(image.path);
      img64 = base64Encode(_image!);
      date = DateTime.now();
    });
  }

  Future<void> _pickImageGallery(context) async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = File(image!.path).readAsBytesSync();
      _imagefile = File(image.path);
      img64 = base64Encode(_image!);
      date = DateTime.now();
    });
  }

  Future<void> _cropImage() async {
    File? cropped = await ImageCropper.cropImage(
      sourcePath: _imagefile.path.toString(),
    );
    setState(() {
      _imagefile = cropped ?? _imagefile;
      _image = File(cropped!.path).readAsBytesSync();
      img64 = base64Encode(_image!);
      date = DateTime.now();
    });
  }

  void _clear() {
    setState(() {
      _imagefile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    int? userId = Provider.of<UserModel>(context).partnerId;
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.photo_camera),
              onPressed: () => _pickImageCamera(context),
            ),
            IconButton(
              icon: const Icon(Icons.photo_library),
              onPressed: () => _pickImageGallery(context),
            )
          ],
        ),
      ),
      body: LoaderOverlay(
        child: ListView(
          children: [
            if (_imagefile != null) ...[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(height: 500, width: 500, child: Image.file(_imagefile)),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: const Icon(Icons.crop),
                      onPressed: () {
                        _cropImage();
                      }),
                  FloatingActionButton(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: const Icon(Icons.close),
                      onPressed: () {
                        _clear();
                      }),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              ValidatedTextField(
                fieldController: myController,
                labelText: 'Caption',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: RoundedButton(
                    buttonText: 'Upload',
                    buttonColor: Theme.of(context).primaryColor,
                    buttonFunction: () async {
                      context.loaderOverlay.show(widget: const LoadingScreen());
                      dynamic appointments =
                          await AppointmentsApi.getAppointments(
                              context,
                              userId,
                              Provider.of<UserModel>(context, listen: false)
                                  .token);
                      int status = await GalleryApi.postGallery(context, img64,
                          date, myController.text, widget.appId, widget.doctorId);
                      context.loaderOverlay.hide();
                      if (status == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text("Photo uploaded to gallery"),
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("Failed to Upload photo"),
                          ),
                        );
                      }
                    }),
              )
            ]
          ],
        ),
      ),
    );
  }
}

class DoctorId {
  final int doctorId;

  const DoctorId(this.doctorId);
}

