import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {Key key,
      this.icon,
      this.imageIcon,
      this.focusNode,
      this.keyboardType,
      this.hintText,
      this.labelText,
      this.hasError,
      this.validator,
      this.maxLength,
      this.controller,
      this.maxLines: 1,
      this.obscureText: false,
      this.counterText})
      : super(key: key);

  final IconData icon;
  final ImageIcon imageIcon;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final String hintText;
  final String labelText;
  final bool hasError;
  final Function validator;
  final int maxLength;
  final int maxLines;
  final TextEditingController controller;
  final bool obscureText;
  final String counterText;

  @override
  Widget build(BuildContext context) {
    return (imageIcon == null && icon == null)
        ? ListTile(
            title: TextFormField(
              focusNode: focusNode,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hintText,
                labelText: labelText,
                counterText: counterText,
                suffixIcon: Icon(
                  Icons.error,
                  color: hasError ? Colors.red : Colors.transparent,
                ),
              ),
              validator: validator,
              maxLength: maxLength,
              controller: controller,
              maxLines: maxLines,
              obscureText: obscureText,
            ),
          )
        : ListTile(
            title: TextFormField(
              focusNode: focusNode,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hintText,
                labelText: labelText,
                counterText: counterText,
                suffixIcon: Icon(
                  Icons.error,
                  color: hasError ? Colors.red : Colors.transparent,
                ),
              ),
              maxLines: maxLines,
              validator: validator,
              maxLength: maxLength,
              controller: controller,
              obscureText: obscureText,
            ),
            leading: Padding(
              child: imageIcon == null ? Icon(icon) : imageIcon,
              padding: const EdgeInsets.only(bottom: 16.0),
            ),
          );
  }
}
