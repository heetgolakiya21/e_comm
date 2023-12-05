import 'package:e_comm/themes.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  String? labelText;
  Widget? suffixIcon;
  TextEditingController? controller;
  bool obscureText;
  Widget? prefixIcon;
  TextInputType? keyboardType;
  bool enableSuggestions;
  int? maxLength;
  String? errorText;
  int? maxLines;
  TextInputAction? textInputAction;
  TextCapitalization textCapitalization;

  CustomTextField({
    super.key,
    required this.labelText,
    this.suffixIcon,
    required this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.keyboardType,
    this.enableSuggestions = true,
    this.maxLength,
    this.errorText,
    this.maxLines = 1,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      enableSuggestions: enableSuggestions,
      maxLength: maxLength,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorText: errorText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.grey, width: 1.5),
            borderRadius: BorderRadius.circular(15.0)),
        filled: true,
        fillColor: Colors.grey[50],
        labelText: labelText,
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
          // backgroundColor: Colors.grey[50],
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
        prefixIconColor: MyColors.grey,
        suffixIconColor: MyColors.grey,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      ),
      maxLines: maxLines,
      cursorColor: MyColors.blue,
      cursorRadius: const Radius.circular(50.0),
      autocorrect: false,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
    );
  }
}
