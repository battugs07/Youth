import 'dart:ui' as prefix0;

import 'package:flutter/material.dart';

const Color backgroundColor = Color.fromARGB(255, 255, 241, 159);
const Color commentColor = Color.fromARGB(255, 255, 246, 196);

const Color bgColor = Color(0xfff1f2f2);
const Color bgSecondColor = Color(0xffF5F6FB);
const Color primaryColor = Color(0xff1F49B0);
const Color secondaryColor = Color(0xffFFB118);
const Color secondaryDarken = Color(0xff8f6b29);
const Color secondaryLighten = Color(0xffdf9f28);
const Color textColor = Color(0xff666666);
const Color volunteerColor = Color.fromRGBO(66, 34, 166, 1);
const Color lawColor = Color.fromRGBO(179, 56, 56, 1);
const Color knowLedgeColor = Color(0xFF576574);
const Color eLearnColor = Color(0xFF5f58CC);
const Color podCastColor = Color.fromRGBO(0, 144, 140, 1);
const Color eventColor = Color.fromRGBO(234, 185, 83, 1);
const Color partTimeColor = Color(0xFF02b557);

const Color volunteerWorkColor = Color(0xFF4323a7);

const Gradient mainGradient = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  stops: [0, 0.9],
  colors: [Color(0xaa005fc2), Color(0xaa0074f2)],
);

const Gradient verticalMainGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: [0, 0.92],
  colors: [primaryColor, Color(0xaa0074f2)],
);

const Gradient blueGradient = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  stops: [0, 0.5, 0.9],
  colors: [Color(0xff8f6b29), Color(0xfffde08d), Color(0xffdf9f28)],
);

const BoxShadow shadow = BoxShadow(
  color: Color(0x12222222),
  blurRadius: 10.0,
  spreadRadius: .7,
  offset: Offset(3.0, 5.0),
);
