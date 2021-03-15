import 'package:flutter/material.dart';

import 'package:weather_app/models/models.dart';

class WeatherConditions extends StatelessWidget {
  final WeatherCondition condition;
  final double width;

  WeatherConditions({Key? key, required this.condition, this.width = 80})
      : super(key: key);

  @override
  Widget build(BuildContext context) => _mapConditionToImage(condition);

  Image _mapConditionToImage(WeatherCondition condition) {
    Image image;
    switch (condition) {
      case WeatherCondition.clear:
        image = Image.asset('assets/sunny.png', width: width);
        break;
      case WeatherCondition.hail:
      case WeatherCondition.snow:
      case WeatherCondition.sleet:
        image = Image.asset(
          'assets/snow.png',
          width: width,
        );
        break;
      case WeatherCondition.heavyCloud:
        image = Image.asset('assets/cloudy.png', width: width);
        break;
      case WeatherCondition.thunderstorm:
      case WeatherCondition.heavyRain:
      case WeatherCondition.lightRain:
      case WeatherCondition.showers:
        image = Image.asset('assets/rain.png', width: width);
        break;
      case WeatherCondition.lightCloud:
        image = Image.asset('assets/partiallySunny.png', width: width);
        break;
      case WeatherCondition.unknown:
        image = Image.asset('assets/clear.png', width: width);
        break;
    }
    return image;
  }
}
