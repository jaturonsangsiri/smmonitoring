import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:smmonitoring/src/configs/route.dart' as custom_route;

class ShowSnackbar {
  static final scaffoldMessengerKey = custom_route.Route.scaffoldMessengerKey;
  static void snackbar(ContentType type, String title, String message) {
    SnackBar snackBar = SnackBar(
      elevation: 0,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(title: title, message: message, contentType: type),
    );
    custom_route.Route.scaffoldMessengerKey.currentState!
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
