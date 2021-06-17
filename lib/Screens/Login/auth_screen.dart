import 'package:bits/utils/app_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:flutter/material.dart';

import 'package:bits/components/rounded_button.dart';
import 'package:bits/Screens/Welcome/welcome_screen.dart';
import 'package:bits/Screens/Login/components/background.dart';
import 'package:timer_button/timer_button.dart';

import '../../constants.dart';

class AuthScreen extends StatefulWidget {
  final String callingCode;
  final String phoneNumber;

  const AuthScreen({
    Key key,
    this.callingCode,
    this.phoneNumber,
  }) : super(key: key);

  @override
  State createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _codeController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  String verificationId;
  int resendToken;

  @override
  void initState() {
    super.initState();

    var callingCode = widget.callingCode;
    var phoneNumber = widget.phoneNumber;
    _sendCode('$callingCode$phoneNumber');

    AppPreferences.setString(inCallingCode, callingCode);
    AppPreferences.setString(inPhoneNumber, phoneNumber);
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var callingCode = widget.callingCode;
    var phoneNumber = widget.phoneNumber;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                'assets/icons/login.svg',
                height: size.height * 0.35,
              ),
              Text(
                'VERIFY',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Text(
                '$callingCode-$phoneNumber',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.10),
              Container(
                margin: EdgeInsets.only(left: 48, right: 36),
                child: PinPut(
                  fieldsCount: 6,
                  onSubmit: (String pin) => print,
                  controller: _codeController,
                  submittedFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  selectedFieldDecoration: _pinPutDecoration,
                  followingFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Colors.deepPurpleAccent.withOpacity(.5),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.06),
              RoundedButton(
                text: 'VERIFY',
                press: () {
                  var smsCode = _codeController.text;
                  if (smsCode.length == 6)
                    _onVerification(smsCode);
                  else
                    _showSnackBar('OTP is not valid');
                },
              ),
              SizedBox(height: size.height * 0.05),
              TimerButton(
                label: 'Send OTP Again',
                onPressed: () {
                  var callingCode = widget.callingCode;
                  var phoneNumber = widget.phoneNumber;
                  _sendCode('$callingCode$phoneNumber');
                },
                timeOutInSeconds: 60,
                color: Colors.white,
                disabledColor: Colors.white,
                disabledTextStyle:
                    TextStyle(fontSize: 18.0, color: Colors.grey),
                activeTextStyle: TextStyle(fontSize: 18.0, color: Colors.black),
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        duration: const Duration(seconds: 3),
        content: Container(
          height: 80.0,
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

  void _sendCode(String _phoneNumber) async {
    print('_phoneNumber $_phoneNumber');
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phoneNumber,
      forceResendingToken: resendToken,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        print('PhoneAuthCredential ${credential.asMap()}');

        var user = await auth.signInWithCredential(credential);
        _showSnackBar('verification Completed');
        _verificationCompleted(user);
      },
      verificationFailed: (FirebaseAuthException e) {
        print('FirebaseAuthException $e');
        if (e.code == 'invalid-phone-number') {
          _showSnackBar('phone number is not valid');
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int resendToken) async {
        print('codeSent verificationId $verificationId');
        print('codeSent resendToken $resendToken');
        this.verificationId = verificationId;
        this.resendToken = resendToken;
        _showSnackBar('code Sent successfully');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('codeAutoRetrievalTimeout verificationId $verificationId');
      },
    );
  }

  void _onVerification(String smsCode) async {
    // Update the UI - wait for the user to enter the SMS code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    // Sign the user in (or link) with the credential
    var user = await auth.signInWithCredential(credential);
    _verificationCompleted(user);
  }

  void _verificationCompleted(UserCredential credential) {
    print('credential userId ${credential.user.uid}');
    print('credential phoneNumber ${credential.user.phoneNumber}');

    AppPreferences.setString(userId, credential.user.uid);
    AppPreferences.setString(phoneNumber, credential.user.phoneNumber);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => WelcomeScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
