import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:weather_app/models/models.dart';

class WeatherApiClient {
  static const baseUrl = "www.metaweather.com";

  WeatherApiClient();

  Future<int> getLocationId(String city) async {
    final locationPath = '/api/location/search/';
    final params = {
      'query': city,
    };
    final locationResponse =
        await http.get(Uri.https(baseUrl, locationPath, params));
    if (locationResponse.statusCode != 200) {
      throw Exception('error getting locationId for city');
    }

    final locationJson = jsonDecode(locationResponse.body) as List;
    return (locationJson.first)['woeid'];
  }

  Future<Weather> fetchWeather(int locationId) async {
    final weatherPath = '/api/location/$locationId';
    final weatherResponse = await http.get(Uri.https(baseUrl, weatherPath));

    if (weatherResponse.statusCode != 200) {
      throw Exception('error getting locationId for city');
    }

    final weatherJson = jsonDecode(weatherResponse.body);
    return Weather.fromJson(weatherJson);
  }
}
