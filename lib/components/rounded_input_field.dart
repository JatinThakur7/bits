import 'package:flutter/material.dart';
import 'package:bits/components/text_field_container.dart';
import 'package:bits/constants.dart';

class RoundedInputField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final String hintText;
  final IconData icon;

  const RoundedInputField({
    Key key,
    this.hintText,
    this.onChanged,
    this.controller,
    this.icon = Icons.phone_iphone,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        controller: controller,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
        keyboardType: keyboardType,
      ),
    );
  }
}
