import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bits/Screens/Login/login_screen.dart';
import 'package:bits/components/rounded_button.dart';
import 'package:bits/components/rounded_input_field.dart';
import 'package:bits/utils/app_preferences.dart';
import 'package:bits/utils/image_utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State createState() => _WelcomeState();
}

class _WelcomeState extends State<WelcomeScreen> {
  final controllerEmailId = TextEditingController();
  final controllerPhone = TextEditingController();
  final controllerName = TextEditingController();

  String _userImage;
  String _userId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    _userId = await AppPreferences.getString(userId);
    String source = await AppPreferences.getString(_userId);
    String _phoneNumber = await AppPreferences.getString(phoneNumber);
    controllerPhone.text = _phoneNumber;

    if (source?.isNotEmpty ?? false) {
      var object = jsonDecode(source);
      if (object['userId'] == _userId) {
        controllerName.text = object['name'];
        controllerPhone.text = object['phone'];
        controllerEmailId.text = object['email'];

        _userImage = object['image'];
      }
    }
    setState(() {
      print('_userId => $_userId, _userImage => $_userImage');
    });
  }

  _imagePicker(int witch) async {
    var path = (await ImageCropperPicker(witch).filePicker()).path;
    if (path != null)
      setState(() {
        _userImage = path;
      });
  }

  // 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
  //${_userId ?? ''}
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: [
          IconButton(
            onPressed: () {
              AwesomeDialog(
                  context: context,
                  dialogType: DialogType.INFO,
                  btnCancelOnPress: () {},
                  body: Container(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Are you sure want to logout!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  btnOkText: 'Logout',
                  btnOkOnPress: () {
                    AppPreferences.setString(userId, null);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    );
                  }).show();
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: InkWell(
                      onTap: () {
                        AwesomeDialog(
                                context: context,
                                dialogType: DialogType.NO_HEADER,
                                body: Container(
                                  padding: EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      Text(
                                        'SELECT',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Divider(),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop(context);
                                          _imagePicker(0);
                                        },
                                        child: Text(
                                          'Camera',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop(context);
                                          _imagePicker(1);
                                        },
                                        child: Text(
                                          'Gallery',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                ),
                                btnCancelOnPress: () {})
                            .show();
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            margin: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              border: Border.all()
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(72),
                              child: (_userImage?.isEmpty ?? true)
                                  ? Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 80,
                                    )
                                  : Image.file(
                                      File(_userImage),
                                      fit: BoxFit.cover,
                                      width: 120,
                                      height: 120,
                                    ),
                            ),
                          ),
                          Positioned.fill(
                            right: 12,
                            bottom: 24,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Icon(
                                Icons.edit,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  RoundedInputField(
                    hintText: 'Your Name',
                    onChanged: (value) {},
                    icon: Icons.person,
                    controller: controllerName,
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(height: size.height * 0.01),
                  RoundedInputField(
                    hintText: 'Your Phone no.',
                    onChanged: (value) {},
                    controller: controllerPhone,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: size.height * 0.01),
                  RoundedInputField(
                    hintText: 'Your Email Id',
                    onChanged: (value) {},
                    icon: Icons.email,
                    controller: controllerEmailId,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),
            ),
          ),
          RoundedButton(
            text: 'Save',
            press: () {
              if (controllerName.text.length == 0) {
                _showSnackBar('Can\'t save empty name');
                return;
              }
              if (controllerPhone.text.length == 0) {
                _showSnackBar('Can\'t save empty Phone No.');
                return;
              }
              if (controllerEmailId.text.length == 0) {
                _showSnackBar('Can\'t save empty Email Id');
                return;
              }
              var object = {
                'name': controllerName.text,
                'phone': controllerPhone.text,
                'email': controllerEmailId.text,
                'image': _userImage,
                'userId': _userId,
              };
              String params = jsonEncode(object);
              AppPreferences.setString(_userId, params);
              _showSnackBar('Save data successfully');
            },
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        duration: const Duration(seconds: 3),
        content: Container(
          height: 60.0,
          child: Center(
            child: Text(
              message,
              style: const TextStyle(fontSize: 25.0),
            ),
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ));
  }
}
