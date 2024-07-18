import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    super.key,
    this.labelText,
    this.hintText,
    required this.controller,
    required this.validator,
    this.onTap,
    this.isEmail = false,
    this.isPassword = false,
    this.isLast = false,
    this.readOnly = false,
    this.suffixIcon,
    this.maxLines = 1,
  });

  final String? labelText;
  final String? hintText;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final Function()? onTap;
  final bool isEmail;
  final bool isPassword;
  final bool isLast;
  final bool readOnly;
  final Widget? suffixIcon;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
      obscureText: isPassword,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        labelText: labelText,
        hintText: hintText,
        suffixIcon: suffixIcon,
      ),
      maxLines: maxLines,
      onTap: onTap,
      readOnly: readOnly,
      validator: validator,
    );
  }
}
