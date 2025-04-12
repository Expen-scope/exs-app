import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogHelper {
  static void showSuccessDialog({
    required String title,
    required String message,
    VoidCallback? onOkPressed,
  }) {
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      title: title,
      desc: message,
      btnOkOnPress: onOkPressed ?? () {},
      btnOkText: 'OK',
      btnOkColor: Colors.green,
      barrierColor: Colors.transparent,
      dialogBackgroundColor: Colors.white,
      titleTextStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
      descTextStyle: const TextStyle(
        fontSize: 16,
      ),
    ).show();
  }

  static void showErrorDialog({
    required String title,
    required String message,
    VoidCallback? onOkPressed,
  }) {
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: title,
      desc: message,
      barrierColor: Colors.transparent,
      dialogBackgroundColor: Colors.white,
      btnOkOnPress: onOkPressed ?? () {},
      btnOkText: 'OK',
      btnOkColor: Colors.red,
      titleTextStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
      descTextStyle: const TextStyle(
        fontSize: 16,
      ),
    ).show();
  }

  // رسالة تحذير
  static void showWarningDialog({
    required String title,
    required String message,
    VoidCallback? onOkPressed,
    VoidCallback? onCancelPressed,
  }) {
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.warning,
      animType: AnimType.topSlide,
      title: title,
      desc: message,
      btnOkOnPress: onOkPressed ?? () {},
      btnCancelOnPress: onCancelPressed ?? () {},
      btnOkText: 'Yes',
      btnCancelText: 'No',
      btnOkColor: Colors.orange,
      titleTextStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.orange,
      ),
      descTextStyle: const TextStyle(
        fontSize: 16,
      ),
    ).show();
  }

  // رسالة معلومات
  static void showInfoDialog({
    required String title,
    required String message,
    VoidCallback? onOkPressed,
  }) {
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      title: title,
      desc: message,
      btnOkOnPress: onOkPressed ?? () {},
      btnOkText: 'OK',
      btnOkColor: Colors.blue,
      titleTextStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
      descTextStyle: const TextStyle(
        fontSize: 16,
      ),
    ).show();
  }

  // رسالة تأكيد
  static void showConfirmDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.question,
      animType: AnimType.scale,
      title: title,
      desc: message,
      btnOkOnPress: onConfirm,
      btnCancelOnPress: onCancel ?? () {},
      btnOkText: 'Confirm',
      btnCancelText: 'Cancel',
      btnOkColor: Colors.blue,
      titleTextStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
      descTextStyle: const TextStyle(
        fontSize: 16,
      ),
    ).show();
  }
}
