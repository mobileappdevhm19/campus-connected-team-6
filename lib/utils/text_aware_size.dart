import 'package:flutter/material.dart';

double textAwareSize(double size, BuildContext context) {
  final double textFactor = MediaQuery.of(context).textScaleFactor;
  return (size / textFactor);
}
