import 'package:flutter/material.dart';
import 'package:weather_app/models/models.dart' as model;

import 'widgets.dart';

class WeatherInfo extends StatelessWidget {
  final model.Weather weather;

  WeatherInfo({required this.weather});

  @override
  build(BuildContext context) {
    return ClipPath(
        clipper: _WeatherInfoClipper(),
        child: Container(
            height: 400,
            decoration: BoxDecoration(
                image: new DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/cityBackground.jpg'))),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Center(
                    child: Location(location: weather.location),
                  ),
                ),
                Center(
                  child: LastUpdated(dateTime: weather.lastUpdated),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: CombinedWeatherTemperature(
                              weather: weather,
                            )),
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: Wind(
                              direction: weather.windDirection,
                              speed: weather.windSpeed,
                            )),
                      ],
                    )),
              ],
            )));
  }
}

class _WeatherInfoClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
