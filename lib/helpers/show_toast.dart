
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';


enum ToastType { error, success, information, normal }

class ToastUtils {
  static void showSuccessToast(
    BuildContext context,
    String message,
    String? desc, {
    Position? toastPosition,
  }) {
    CherryToast.success(
      title: Text(message),
      // backgroundColor: _getToastBgColor(ToastType.success),
      autoDismiss: true,
      toastPosition: toastPosition ?? Position.top,
      description: Text(desc ?? ''),
    ).show(context);
  }

  static Color? _getToastBgColor(ToastType toastType) {
    switch (toastType) {
      case ToastType.normal:
        return null;
      case ToastType.success:
        return Colors.green;
      case ToastType.error:
        return Colors.red;
      default:
        return null;
    }
  }

  /* display error */
  static void showErrorToast(
    BuildContext context,
    String message,
    String? desc,
    {bool autoDismiss = true}) {
    CherryToast.error(
      title: Text(message),
      autoDismiss: autoDismiss,
      description: Text(desc ?? ''),
    ).show(context);
  }

  static void showInfoToast(
    BuildContext context,
    String message,
    String? desc,
  ) {
    CherryToast.info(
      title: Text(message),
      autoDismiss: true,
      description: Text(desc ?? ''),
    ).show(context);
  }
}
