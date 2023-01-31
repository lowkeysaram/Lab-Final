import 'dart:convert';

// ignore: file_names
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../shared/mainmenu.dart';
import '../user.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _nameEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _emailEditingController.text = widget.user.email!;
    _nameEditingController.text = widget.user.name!;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(title: const Text("Profile")),
          body: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                    controller: _emailEditingController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) =>
                        val!.isEmpty || !val.contains("@") || !val.contains(".")
                            ? "enter a valid email"
                            : null,
                    decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(),
                        icon: Icon(Icons.email),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.0)))),
                TextFormField(
                    controller: _nameEditingController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(),
                        icon: Icon(Icons.people),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.0)))),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  minWidth: 115,
                  height: 50,
                  elevation: 10,
                  onPressed: _changeName,
                  color: Theme.of(context).colorScheme.primary,
                  child: const Text('Update'),
                ),
              ],
            ),
          ),
          drawer: MainMenuWidget(
            user: widget.user,
          )),
    );
  }

  void _changeName() {
    http.post(Uri.parse("${Config.SERVER}/php/changeName.php"),
        body: {"email": _emailEditingController.text}).then((response) {
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse['status'] == "success") {
        Fluttertoast.showToast(
            msg: "Update success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      } else {
        Fluttertoast.showToast(
            msg: "Update Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      }
    });
  }
}
