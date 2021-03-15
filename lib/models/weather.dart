import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

enum WeatherCondition {
  snow,
  sleet,
  hail,
  thunderstorm,
  heavyRain,
  lightRain,
  showers,
  heavyCloud,
  lightCloud,
  clear,
  unknown
}

class Weather extends WeatherBase {
  final List<WeatherBase> nextDays;
  final int locationId;
  final String location;

  const Weather({
    required WeatherCondition condition,
    required String formattedCondition,
    required double minTemp,
    required double temp,
    required double maxTemp,
    required double windDirection,
    required double windSpeed,
    required String created,
    required DateTime lastUpdated,
    required DateTime date,
    required int currentDiff,
    required this.location,
    required this.locationId,
    required this.nextDays,
  }) : super(
          condition: condition,
          formattedCondition: formattedCondition,
          minTemp: minTemp,
          temp: temp,
          maxTemp: maxTemp,
          windDirection: windDirection,
          windSpeed: windSpeed,
          created: created,
          lastUpdated: lastUpdated,
          date: date,
          currentDiff: currentDiff,
        );

  @override
  List<Object> get props {
    final props = super.props;
    props.addAll([nextDays, location, locationId]);
    return props;
  }

  static Weather fromJson(dynamic json) {
    final consolidatedDays = json['consolidated_weather'] as List<dynamic>;
    final consolidatedToday = consolidatedDays.removeAt(0);
    final base = WeatherBase.fromJson(
      consolidatedWeather: consolidatedToday,
      currentVal: 0,
    );
    final nextDays = consolidatedDays
        .map((d) =>
            WeatherBase.fromJson(consolidatedWeather: d, currentVal: base.temp))
        .toList();

    return Weather(
      condition: base.condition,
      created: base.created,
      formattedCondition: base.formattedCondition,
      lastUpdated: base.lastUpdated,
      locationId: json['woeid'] as int,
      location: json['title'] as String,
      maxTemp: base.maxTemp,
      minTemp: base.minTemp,
      temp: base.temp,
      windDirection: base.windDirection,
      windSpeed: base.windSpeed,
      nextDays: nextDays,
      date: base.date,
      currentDiff: 0,
    );
  }
}

class WeatherBase extends Equatable {
  final WeatherCondition condition;
  final String formattedCondition;

  final double minTemp;
  final double temp;
  final double maxTemp;
  final int currentDiff;

  final double windSpeed;
  final double windDirection;

  final String created;
  final DateTime lastUpdated;

  final DateTime date;

  const WeatherBase({
    required this.condition,
    required this.formattedCondition,
    required this.minTemp,
    required this.temp,
    required this.maxTemp,
    required this.windDirection,
    required this.windSpeed,
    required this.created,
    required this.lastUpdated,
    required this.date,
    required this.currentDiff,
  });

  @override
  List<Object> get props => [
        condition,
        formattedCondition,
        minTemp,
        temp,
        maxTemp,
        created,
        lastUpdated
      ];

  static WeatherBase fromJson(
      {required dynamic consolidatedWeather, double currentVal = 0}) {
    final formatter = new DateFormat('yyyy-MM-dd');

    final dayTemp = (consolidatedWeather['the_temp'] as double);
    return WeatherBase(
      condition: _mapStringToWeatherCondition(
          consolidatedWeather['weather_state_abbr']),
      formattedCondition: consolidatedWeather['weather_state_name'],
      minTemp: consolidatedWeather['min_temp'] as double,
      temp: dayTemp,
      maxTemp: consolidatedWeather['max_temp'] as double,
      windSpeed: consolidatedWeather['wind_speed'] as double,
      windDirection: consolidatedWeather['wind_direction'] as double,
      created: consolidatedWeather['created'],
      lastUpdated: DateTime.now(),
      currentDiff: dayTemp.round() - currentVal.round(),
      date: formatter.parse(consolidatedWeather['applicable_date']),
    );
  }

  static WeatherCondition _mapStringToWeatherCondition(String input) {
    WeatherCondition state;
    switch (input) {
      case 'sn':
        state = WeatherCondition.snow;
        break;
      case 'sl':
        state = WeatherCondition.sleet;
        break;
      case 'h':
        state = WeatherCondition.hail;
        break;
      case 't':
        state = WeatherCondition.thunderstorm;
        break;
      case 'hr':
        state = WeatherCondition.heavyRain;
        break;
      case 'lr':
        state = WeatherCondition.lightRain;
        break;
      case 's':
        state = WeatherCondition.showers;
        break;
      case 'hc':
        state = WeatherCondition.heavyCloud;
        break;
      case 'lc':
        state = WeatherCondition.lightCloud;
        break;
      case 'c':
        state = WeatherCondition.clear;
        break;
      default:
        state = WeatherCondition.unknown;
    }
    return state;
  }
}
