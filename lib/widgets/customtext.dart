import 'package:flutter/material.dart';

Widget CustomText({
  Color color = Colors.white,
  FontWeight fontWeight = FontWeight.w400,
  double fontsize = 24,
  required String text,
}) {
  return Text(
    text.toUpperCase(),
    style: TextStyle(
      color: color,
      fontSize: fontsize,
      fontWeight: fontWeight,
    ),
  );
}
