
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Color mainColor = const Color(0xff1a202e);
Color secondColor = Colors.blueGrey ;
Color commentBackground =const  Color(0xFFB0BEC5);

void navigateTo(BuildContext context, Widget route) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => route));
}

void navigateAndFinish(BuildContext context, Widget route) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => route), (route) => false);
}



enum ToastState { success, error, warning }

Color chooseToastColor(ToastState state) {
  Color color ;
  switch (state) {
    case ToastState.error:
      color = Colors.red;
      break;

    case ToastState.success:
      color = Colors.green;
      break;

    case ToastState.warning:
      color = Colors.yellow;
      break;
  }
  return color ;
}

Future<bool?> showToast(
    String message,
    ToastState state,
    ) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor:chooseToastColor(state),
  );
}

String? uId ;
