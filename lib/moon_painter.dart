//
// MoonPhase.java:
// Calculate the phase of the moon.
//    Copyright 2014 by Audrius Meskauskas
// You may use or distribute this code under the terms of the GPLv3
//https://github.com/andviane/moon.git

import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'moon_phase.dart';

class MoonPainter extends CustomPainter {
  MoonWidget moonWidget;
  ui.Image? moonImage;
  final Paint paintDark = Paint();
  final Paint paintLight = Paint();
  final MoonPhase moon = MoonPhase();

  MoonPainter({required this.moonWidget, this.moonImage});

  @override
  void paint(Canvas canvas, Size size) {
    double radius = moonWidget.resolution;
    double negRadius = radius * -1;

    int width = radius.toInt() * 2;
    int height = radius.toInt() * 2;
    double phaseAngle = moon.getPhaseAngle(moonWidget.date);

    double xCenter = 0;
    double yCenter = 0;

    paintLight.color = moonWidget.surfaceColor;
    if (moonImage != null) {
      try {
        canvas.drawImage(moonImage!, Offset(negRadius, negRadius + 1), Paint());
      } catch (e) {
        canvas.drawCircle(const Offset(0, 1), radius, paintLight);
      }
    } else {
      canvas.drawCircle(const Offset(0, 1), radius, paintLight);
    }

    ///The phase angle is the angle between the sun - the moon - the earth.
    ///So 0 = full phase, 180 = new
    ///What we need is the position angle of the sunrise terminator (Sun - Earth - Moon).
    ///It must be converted because it is in the opposite direction to the phase angle.
    double positionAngle = pi - phaseAngle;
    if (positionAngle < 0.0) {
      positionAngle += 2.0 * pi;
    }

    //Now we need to draw the dark side.
    paintDark.color = moonWidget.shadowColor;

    double cosTerm = cos(positionAngle);

    double rSquared = radius * radius;
    double whichQuarter = ((positionAngle * 2.0 / pi) + 4) % 4;

    for (int j = 0; j < radius; ++j) {
      double rrf = sqrt(rSquared - j * j);
      double rr = rrf;
      double xx = rrf * cosTerm;
      double x1 = xCenter - (whichQuarter < 2 ? rr : xx);
      double w = rr + xx;
      canvas.drawRect(
          Rect.fromLTRB(x1, yCenter - j, w + x1, yCenter - j + 2), paintDark);
      canvas.drawRect(
          Rect.fromLTRB(x1, yCenter + j, w + x1, yCenter + j + 2), paintDark);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
