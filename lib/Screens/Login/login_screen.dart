import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

import 'package:bits/components/rounded_button.dart';
import 'package:bits/components/rounded_input_field.dart';
import 'package:bits/Screens/Login/components/background.dart';

import '../country_picker_screen.dart';
import 'auth_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Country _selectedCountry;

  final controller = TextEditingController();

  @override
  void initState() {
    initCountry();
    super.initState();
  }

  void initCountry() async {
    final country = await getDefaultCountry(context);
    setState(() {
      _selectedCountry = country;
    });
  }

  void countryPicker() async {
    final country = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CountryPickerPage()),
    );
    if (country != null)
      setState(() {
        _selectedCountry = country;
      });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'LOGIN',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              if (_selectedCountry != null)
                TextButton(
                  child: Image.asset(
                    _selectedCountry.flag,
                    package: countryCodePackageName,
                    width: 100,
                  ),
                  onPressed: countryPicker,
                ),
              if (_selectedCountry != null)
                SizedBox(height: size.height * 0.03),
              if (_selectedCountry != null)
                TextButton(
                  child: Text(
                    '${_selectedCountry?.toString() ?? ''}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: countryPicker,
                ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                hintText: 'Your Phone no.',
                onChanged: (value) {},
                controller: controller,
                keyboardType: TextInputType.phone,
              ),
              RoundedButton(
                text: 'LOGIN',
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AuthScreen(
                              phoneNumber: controller.text,
                              callingCode: _selectedCountry.callingCode,
                            )),
                  );
                },
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
