import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint =
        Paint()
          ..color =
              Colors
                  .blue // 曲线的颜色
          ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height * 1.2); // 开始曲线的点
    path.quadraticBezierTo(
      size.width / 2,
      size.height * 0.85,
      size.width,
      size.height*1.2,
    ); // 贝塞尔曲线控制点
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
