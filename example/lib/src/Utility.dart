import 'package:flutter/widgets.dart';

class Utility {
  /// Simple method to format milliseconds time in mm:ss  minutes:seconds format.
  /// [ms] milliseconds number
  static String parseToMinutesSeconds(int ms) {
    String data;
    Duration duration = Duration(milliseconds: ms);

    int minutes = duration.inMinutes;
    int seconds = (duration.inSeconds) - (minutes * 60);

    data = minutes.toString() + ":";
    if (seconds <= 9) data += "0";

    data += seconds.toString();
    return data;
  }

  static Widget createDefaultInfoWidget(final Widget child) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: child,
        ),
      ],
    );
  }
}
