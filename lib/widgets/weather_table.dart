import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/models.dart';
import 'package:weather_app/widgets/widgets.dart';

class WeatherTable extends StatelessWidget {
  final List<WeatherBase> days;

  WeatherTable({required this.days});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days
          .map((
            day,
          ) =>
              ListTile(
                  leading: _leadingIcon(day: day),
                  title: Text(DateFormat('EEEE').format(day.date)),
                  trailing: Container(
                      width: 80,
                      child: Row(children: [
                        Text(
                          '${_formattedTemperature(day.temp)}°',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                        WeatherConditions(condition: day.condition, width: 30),
                      ]))))
          .toList(),
    ));
  }

  Widget _leadingIcon({required WeatherBase day}) {
    if (day.currentDiff > 0) {
      return Icon(Icons.trending_up, color: Colors.red);
    } else if (day.currentDiff < 0) {
      return Icon(Icons.trending_down, color: Colors.blue);
    }
    return Icon(Icons.trending_flat);
  }

  int _formattedTemperature(double t) => t.round();
}
