import 'dart:math';

import 'package:flutter/widgets.dart';

const BorderRadius kBorderRadius = BorderRadius.all(Radius.circular(8.0));
const List<BoxShadow> kElevatedBoxShadow = <BoxShadow>[
  BoxShadow(
    color: Color(0xffdddddd),
    offset: Offset(1, 1),
    blurRadius: 20,
    spreadRadius: 1,
  )
];

double getLogoSize(BuildContext context) =>
    min(400.0, MediaQuery.of(context).size.width / 3 * 2);
