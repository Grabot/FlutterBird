import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';

Widget getAvatar(double avatarBoxWidth, double avatarBoxHeight, Uint8List? avatar) {
  if (avatar != null) {
    return Image.memory(
      avatar,
      width: avatarBoxWidth * 1,  // some scale that I determined by trial and error
      height: avatarBoxHeight * 1,  // some scale that I determined by trial and error
      gaplessPlayback: true,
      fit: BoxFit.cover,
    );
  } else {
    return Image.asset(
      "assets/images/default_avatar.png",
      width: avatarBoxWidth,
      height: avatarBoxHeight,
      gaplessPlayback: true,
      fit: BoxFit.cover,
    );
  }
}

Widget avatarBox(double avatarBoxWidth, double avatarBoxHeight, Uint8List? avatar) {
  return Stack(
    children: [
      SizedBox(
        width: avatarBoxWidth,
        height: avatarBoxHeight,
        child: Center(
          child: getAvatar(avatarBoxWidth, avatarBoxHeight, avatar)
        ),
      ),
    ],
  );
}

class HexagonClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    final path = Path();
    List point1 = getPointyHexCorner(size, 0);
    List point2 = getPointyHexCorner(size, 1);
    List point3 = getPointyHexCorner(size, 2);
    List point4 = getPointyHexCorner(size, 3);
    List point5 = getPointyHexCorner(size, 4);
    List point6 = getPointyHexCorner(size, 5);

    point2[1] = size.height;
    point3[1] = size.height;
    point5[1] = 0.0;
    point6[1] = 0.0;

    path.moveTo(point1[0], point1[1]);
    path.lineTo(point2[0], point2[1]);
    path.lineTo(point3[0], point3[1]);
    path.lineTo(point4[0], point4[1]);
    path.lineTo(point5[0], point5[1]);
    path.lineTo(point6[0], point6[1]);
    path.close();
    return path;
  }

  List getPointyHexCorner(Size size, double i) {
    double angleDeg = 60 * i;

    double angleRad = pi/180 * angleDeg;
    double pointX = (size.width/2 * cos(angleRad)) + size.width/2;
    double pointY = (size.height/2 * sin(angleRad)) + size.height/2;
    return [pointX, pointY];
  }

  @override
  bool shouldReclip(HexagonClipper oldClipper) => false;
}
