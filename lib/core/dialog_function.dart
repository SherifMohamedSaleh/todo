import 'package:flutter/material.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:todo_app/core/theme/colors.dart';

class CustomDialogs {
  static const TextStyle _white16Style =
      TextStyle(color: Colors.white, fontSize: 12);
  static const TextStyle _titleStyle =
      TextStyle(fontSize: 12, fontWeight: FontWeight.bold);

  static const TextStyle _msgStyle = TextStyle(fontSize: 12);

  static const double _iconSize = 18;
  static showConfirm({
    required String confirmMsg,
    required BuildContext context,
    required Function() onOkFunction,
    String? okText,
    Color? okTextColor,
    IconData? okButtonIcon,
    Color? okIconColor,
    String? cancelText,
    Color? cancelTextColor,
    IconData? cancelButtonIcon,
    Color? cancelIconColor,
  }) {
    Dialogs.materialDialog(
      msg: confirmMsg,
      title: "Confirm",
      color: CustomColors.primaryBackGround,
      context: context,
      titleStyle: _titleStyle,
      msgStyle: _msgStyle,
      actions: [
        MaterialButton(
          onPressed: onOkFunction,
          color: CustomColors.primary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check,
                color: okTextColor ?? Colors.white,
                size: _iconSize,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                okText ?? "Ok",
                style: _white16Style,
              ),
            ],
          ),
        ),
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: CustomColors.primary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check,
                color: okTextColor ?? Colors.white,
                size: _iconSize,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                cancelText ?? "Cancel",
                style: _white16Style,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static showError(String errorText,
      {String? title, required BuildContext context}) {
    title ??= "error";

    Dialogs.materialDialog(
      msg: errorText,
      title: title,
      color: Colors.white,
      context: context,
      titleStyle: _titleStyle,
      msgStyle: _msgStyle,
      actions: [
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.red,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.white,
                size: _iconSize,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                "ok",
                style: _white16Style,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static showWarning(String warningText,
      {String? title, required BuildContext context}) {
    title ??= "warning";

    Dialogs.materialDialog(
      msg: warningText,
      title: title,
      color: Colors.white,
      context: context,
      titleStyle: _titleStyle,
      msgStyle: _msgStyle,
      actions: [
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.orange,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_amber_outlined,
                color: Colors.white,
                size: _iconSize,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                "ok",
                style: _white16Style,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
