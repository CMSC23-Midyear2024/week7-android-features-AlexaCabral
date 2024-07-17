import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _firstname = TextEditingController();
  TextEditingController _lastname = TextEditingController();
  TextEditingController _number = TextEditingController();
  TextEditingController _email = TextEditingController();

  Permission permission = Permission.camera;
  PermissionStatus permissionStatus = PermissionStatus.denied;
  File? imageFile;

  String? fname;
  String? lname;
  late String emailadd;
  String? number;

  @override
  void initState() {
    super.initState();

    _listenForPermissionStatus();
    _firstname.addListener(() {});
    _lastname.addListener(() {});
    _email.addListener(() {});
    _number.addListener(() {});
  }

  void _listenForPermissionStatus() async {
    final status = await permission.status;
    setState(() => permissionStatus = status);
  }

  @override
  void dispose() {
    super.dispose();
    _firstname.dispose();
    _lastname.dispose();
    _email.dispose();
    _number.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Add Contact')),
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextButton(
                        onPressed: () async {
                          if (permissionStatus == PermissionStatus.granted) {
                            final image = await ImagePicker()
                                .pickImage(source: ImageSource.camera);

                            setState(() {
                              imageFile =
                                  image == null ? null : File(image.path);
                            });
                          } else {
                            requestPermission();
                          }
                        },
                        child: const Icon(
                          Icons.camera_alt,
                          size: 50,
                        ))),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _firstname,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (firstname) {
                      if (firstname!.isEmpty) {
                        return "This is a required field";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "First Name",
                        labelStyle: TextStyle(color: Colors.blueGrey)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _lastname,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "This is a required field";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Last Name",
                        labelStyle: TextStyle(color: Colors.blueGrey)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _number,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Phone Number",
                        labelStyle: TextStyle(color: Colors.blueGrey)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _email,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (mail) {
                      if (mail!.isEmpty) {
                        return "This is a required field";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.blueGrey)),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Contact newContact = Contact();

                        newContact.name.first = _firstname.text;
                        newContact.name.last = _lastname.text;
                        print(_firstname.text);
                        print(_lastname.text);
                        print(_email.text);
                        print(_number.text);


                        newContact.emails.firstOrNull?.address = _email.text;
                        newContact.phones.firstOrNull?.number = _number.text;


                        newContact.insert();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Add contact"))
              ],
            ),
          ),
        ));
  }

  Future<void> requestPermission() async {
    final status = await permission.request();

    setState(() {
      print(status);
      permissionStatus = status;
      print(permissionStatus);
    });
  }
}
