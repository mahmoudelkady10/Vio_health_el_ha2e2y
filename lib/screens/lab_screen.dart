import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:medic_app/model/lab_model.dart';
import 'package:medic_app/network/lab_api.dart';
import 'package:medic_app/widgets/loading_screen.dart';
import 'package:medic_app/widgets/rounded_button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:medic_app/widgets/validated_text_field.dart';

class Labs extends StatelessWidget {
  const Labs({Key? key}) : super(key: key);
  static const id = 'lab_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder(
        future: LabApi.getLabs(context),
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
                  return Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 6.0),
                      child: Card(
                        elevation: 10,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Test Type:',
                                    ),
                                    Text(snapshot.data[index].name),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Date: ',
                                    ),
                                    Text(
                                      snapshot.data[index].date,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.bottomRight,
                                height: 80,
                                width: 150,
                                child: RoundedButton(
                                  buttonText: 'Check Results',
                                  buttonColor: Theme.of(context).primaryColor,
                                  buttonFunction: () {
                                    if (snapshot.data[index].labLines.isNotEmpty) {
                                      print(snapshot.data[index].labLines);
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return LabResults(
                                            name: snapshot.data[index].name,
                                            date: snapshot.data[index].date,
                                            results:
                                                snapshot.data[index].labLines);
                                      }));
                                    } else {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return LabResults(
                                            name: snapshot.data[index].name,
                                            date: snapshot.data[index].date,
                                            image: snapshot.data[index].image.toString());
                                      }));
                                    }
                                  },
                                ),
                              )
                            ]),
                      ));
                });
          } else {
            return const Center(
              child: Text('try again'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return MyForm();
          }));
        },
      ),
    );
  }
}

class LabResults extends StatelessWidget {
  const LabResults(
      {Key? key,
      required this.name,
      required this.date,
      this.results,
      this.image})
      : super(key: key);
  final String name;
  final String date;
  final List<LabLines>? results;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$name Results'),
        backgroundColor: Theme.of(context).primaryColor,

      ),

      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: Theme.of(context).primaryColor),
                        top:
                            BorderSide(color: Theme.of(context).primaryColor))),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(date)
                  ],
                ),
              ),
            ),
            if (results != null) const SizedBox(
              height: 70,
            ),
            if (results == null)
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    InteractiveViewer(
                        minScale: 1, maxScale: 4, child: Image.network(image!, width: 800, height: 800,)),
                  ],
                ),
              ),
            if (results != null)
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: results!.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 45.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    border: Border(
                                      left: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 3),
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 13.0, horizontal: 35.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        '${results![index].measure.toString()}: ',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          '${results![index].result.toString()} ${results![index].unit.toString()}'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            )
                          ],
                        ),
                      );
                    }),
              ),

          ],
        ),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _nameController;
  static List<String> measurements = [''];
  static List<String> results = [''];
  static List<String> units = [''];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add lab results'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                  icon: const Icon(Icons.add_a_photo_outlined),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const LabImage();
                        },
                      ),
                    );
                  })) // add more IconButton
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LoaderOverlay(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // name textfield
                Padding(
                  padding: const EdgeInsets.only(right: 32.0),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: 'Test Name'),
                    validator: (v) {
                      if (v!.trim().isEmpty) return 'Please enter something';
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Add Results',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                ..._getFriends(),
                const SizedBox(
                  height: 40,
                ),
                FlatButton(
                  onPressed: () async {
                    context.loaderOverlay.show(widget: const LoadingScreen());
                    var status = await LabApi.postLab(context, measurements,
                        results, units, _nameController!.text);
                    context.loaderOverlay.hide();
                    if (status == 200) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Lab results saved'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Lab results not save'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// get firends text-fields
  List<Widget> _getFriends() {
    List<Widget> friendsTextFields = [];
    for (int i = 0; i < measurements.length; i++) {
      friendsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: FriendTextFields(i)),
            const SizedBox(
              width: 6,
            ),
            // we need add button at last friends row
            _addRemoveButton(i == measurements.length - 1, i),
          ],
        ),
      ));
    }
    return friendsTextFields;
  }

  /// add / remove button
  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          measurements.insert(index + 1, '');
          results.insert(index + 1, '');
          units.insert(index + 1, '');
        } else {
          measurements.removeAt(index);
          results.removeAt(index);
          units.removeAt(index);
        }
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }
}

class FriendTextFields extends StatefulWidget {
  final int index;

  FriendTextFields(this.index);

  @override
  _FriendTextFieldsState createState() => _FriendTextFieldsState();
}

class _FriendTextFieldsState extends State<FriendTextFields> {
  TextEditingController? _nameController;
  TextEditingController? _resultController;
  TextEditingController? _unitController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _resultController = TextEditingController();
    _unitController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController!.dispose();
    _resultController!.dispose();
    _unitController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   _nameController!.text = _MyFormState.measurements[widget.index] ?? '';
    // });

    return Row(
      children: [
        SizedBox(
          width: 150,
          child: TextFormField(
            controller: _nameController,
            onChanged: (v) => _MyFormState.measurements[widget.index] = v,
            decoration: const InputDecoration(hintText: 'type'),
            validator: (v) {
              if (v!.trim().isEmpty) return 'Please enter something';
              return null;
            },
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        SizedBox(
          width: 100,
          child: TextFormField(
            controller: _resultController,
            onChanged: (v) => _MyFormState.results[widget.index] = v,
            decoration: const InputDecoration(hintText: 'result'),
            validator: (v) {
              if (v!.trim().isEmpty) return 'Please enter something';
              return null;
            },
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        SizedBox(
          width: 50,
          child: TextFormField(
            controller: _unitController,
            onChanged: (v) => _MyFormState.units[widget.index] = v,
            decoration: const InputDecoration(hintText: 'unit'),
            validator: (v) {
              if (v!.trim().isEmpty) return 'Please enter something';
              return null;
            },
          ),
        ),
      ],
    );
  }
}

class LabImage extends StatefulWidget {
  const LabImage({Key? key}) : super(key: key);

  @override
  _LabImageState createState() => _LabImageState();
}

class _LabImageState extends State<LabImage> {
  dynamic image;
  final picker = ImagePicker();
  int ctImage = 0;
  static dynamic img64;
  final myController = TextEditingController();

  void _pickImageCamera() async {
    final pickedImage =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      image = pickedImageFile;
      img64 = base64Encode(pickedImageFile.readAsBytesSync());
    });
  }

  void _pickImageGallery() async {
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      image = pickedImageFile;
      img64 = base64Encode(pickedImageFile.readAsBytesSync());
    });
  }

  void _cropImage() async {
    File? cropped = await ImageCropper.cropImage(
      sourcePath: image.path.toString(),
    );
    setState(() {
      image = cropped ?? image;
      image = File(cropped!.path);
      img64 = base64Encode(image.readAsBytesSync());
    });
  }

  void _clear() {
    setState(() {
      image = null;
      img64 = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.photo_camera),
              onPressed: () => _pickImageCamera(),
            ),
            IconButton(
              icon: const Icon(Icons.photo_library),
              onPressed: () => _pickImageGallery(),
            )
          ],
        ),
      ),
      body: LoaderOverlay(
        child: ListView(
          children: [
            if (image != null) ...[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child:
                    SizedBox(height: 500, width: 500, child: Image.file(image)),
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
                labelText: 'Test Name',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: RoundedButton(
                    buttonText: 'Upload',
                    buttonColor: Theme.of(context).primaryColor,
                    buttonFunction: () async {
                      context.loaderOverlay.show(widget: const LoadingScreen());
                      var status = await LabApi.postLabImage(
                          context, img64, myController.text);
                      context.loaderOverlay.hide();
                      if (status == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text("image uploaded successfully"),
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("Failed to Upload your image"),
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
