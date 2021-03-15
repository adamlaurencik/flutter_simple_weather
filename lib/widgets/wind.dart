import 'package:flutter/material.dart';

class Wind extends StatelessWidget {
  final double speed;
  final double direction;

  Wind({required this.speed, required this.direction});

  @override
  Widget build(BuildContext context) {
    final String directionText = _directionToString(direction);
    return Padding(
      padding: EdgeInsets.only(right: 10.0),
      child: Row(children: [
        Text(
          '${_formattedWind(speed)}',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        Text(
          'mph',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        Text(
          ' $directionText',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        )
      ]),
    );
  }

  String _directionToString(double direction) {
    final index = ((direction / 22.5) + .5).round();
    final arr = [
      "N",
      "NNE",
      "NE",
      "ENE",
      "E",
      "ESE",
      "SE",
      "SSE",
      "S",
      "SSW",
      "SW",
      "WSW",
      "W",
      "WNW",
      "NW",
      "NNW"
    ];
    return arr[index % 16];
  }

  int _formattedWind(double t) => t.round();
}
