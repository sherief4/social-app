import 'package:flutter/material.dart';
import 'package:social_app/shared/constants.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    Key? key,
    required this.controller,
    required this.obscure,
     this.onSubmit,
    required this.validate,
    required this.prefix,
    this.suffix,
    required this.label,
    this.suffixPressed,
  }) : super(key: key);
  final TextEditingController controller;
  final bool obscure;
   void Function(String)? onSubmit;
  IconData? suffix;
  final IconData prefix;
  final String label;
  final String? Function(String?)? validate;
  void Function()? suffixPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55.0,
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        onFieldSubmitted: onSubmit,
        validator: validate,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            prefixIcon: Icon(
              prefix,
              color: mainColor,
            ),
            labelText: label,
            suffixIcon: IconButton(
              icon: Icon(suffix),
              onPressed: suffixPressed,
            )),
      ),
    );
  }
}
