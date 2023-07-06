import 'package:flutter/material.dart';

class AppWidgets {
  static Widget outlineButton({
    required String keyValue,
    required Function()? onPressed,
    required String text,
  }) {
    return OutlinedButton(
      key: Key(keyValue),
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            //side: BorderSide(color: Colors.red),
          ),
        ),
        fixedSize: MaterialStateProperty.all<Size>(
          Size.fromHeight(45),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  static Widget textFormField({
    required TextEditingController controller,
    required String? labelText,
    IconData? prefixIcon,
    Widget? suffixIcon,
    int? maxLength,
    int? maxLines,
    bool obscureText = false,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?)? validator,
    required String keyValue,
  }) {
    return TextFormField(
      enabled: enabled,
      key: Key(keyValue),
      controller: controller,
      showCursor: true,
      maxLength: maxLength,
      maxLines: maxLines ?? 1,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 12),
      decoration: InputDecoration(
        errorMaxLines: 2,
        helperText: " ",
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        labelText: labelText,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
        suffixIcon: suffixIcon,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
    );
  }
}
