import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class CountryPickerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Country'),
      ),
      body: Container(
        child: CountryPickerWidget(
          showSeparator: true,
          onSelected: (country) => Navigator.pop(context, country),
        ),
      ),
    );
  }
}
