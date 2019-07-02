import 'package:flutter/material.dart';

//double baseHeight = 640;
//TODO: screenAware is only useful for Device Orientation change. Since device Orientation is deactivated, its useless
double screenAwareSize(double size, BuildContext context) {
  if (MediaQuery.of(context).orientation == Orientation.portrait) {
    return size; //* MediaQuery.of(context).size.height / baseHeight;
  } else {
    return (size); //* MediaQuery.of(context).size.height / baseHeight);
  }
}
