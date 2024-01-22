import 'package:flutter/material.dart';
import 'package:pathpal/theme.dart';

import '../colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final BorderSide borderSide;
  final String? hint;

  CustomTextField({
    required this.controller,
    required this.label,
    this.hint,
    this.borderSide = const BorderSide(color: gray200),
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: this.hint,
            hintStyle: appTextTheme().bodyMedium,
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(borderSide: borderSide),
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
