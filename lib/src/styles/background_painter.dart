import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/src/styles/timetable_style.dart';

class BackgroundPainter extends CustomPainter {
  final TimetableStyle timetableStyle;

  BackgroundPainter({
    required this.timetableStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = timetableStyle.mainBackgroundColor,
    );
    if (timetableStyle.visibleTimeBorder) {
      for (int hour = 1; hour < 24; hour++) {
        double leftOffset = calculateLeftOffset(hour);
        canvas.drawLine(
          Offset(leftOffset, 0),
          Offset(leftOffset, size.height),
          Paint()
            ..color = timetableStyle.timelineBorderColor
            ..strokeWidth = 0.25,
        );
      }
    }

    // if (timetableStyle.visibleTimeBorder) {
    //   for (int hour = 1; hour < 24; hour++) {
    //     double topOffset = calculateTopOffset(hour);
    //     canvas.drawLine(
    //       Offset(0, topOffset),
    //       Offset(size.width, topOffset),
    //       Paint()..color = timetableStyle.timelineBorderColor,
    //     );
    //   }
    // }

    // if (timetableStyle.visibleDecorationBorder) {
    //   final drawLimit = size.width / timetableStyle.decorationLineWidth;
    //   for (double count = 0; count < drawLimit; count += 1) {
    //     double leftOffset = calculateDecorationVerticalLineOffset(count);
    //     final paint = Paint()..color = timetableStyle.decorationLineBorderColor;
    //     final dashWidth = timetableStyle.decorationLineDashWidth;
    //     final dashSpace = timetableStyle.decorationLineDashSpaceWidth;
    //     var startX = 0.0;
    //     while (startX < size.width) {
    //       canvas.drawLine(
    //         Offset(startX, leftOffset),
    //         Offset(startX + timetableStyle.decorationLineDashWidth, leftOffset),
    //         paint,
    //       );
    //       startX += dashWidth + dashSpace;
    //     }
    //   }
    // }
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDayViewBackgroundPainter) {
    return (timetableStyle.mainBackgroundColor !=
            oldDayViewBackgroundPainter.timetableStyle.mainBackgroundColor ||
        timetableStyle.timelineBorderColor !=
            oldDayViewBackgroundPainter.timetableStyle.timelineBorderColor);
  }

  double calculateTopOffset(int hour) => hour * timetableStyle.timeItemHeight;

  double calculateLeftOffset(int hour) => hour * timetableStyle.timeItemWidth;

  double calculateDecorationHorizontalLineOffset(double count) =>
      count * timetableStyle.decorationLineHeight;

  double calculateDecorationVerticalLineOffset(double count) =>
      count * timetableStyle.decorationLineWidth;
}
