import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_provider_state/constants/constants.dart';
import 'package:weather_provider_state/exceptions/weather_exception.dart';
import 'package:weather_provider_state/models/weather.dart';
import 'package:weather_provider_state/services/http_error_handler.dart';

class WeatherApiservices {
  final http.Client httpClient;

  WeatherApiservices({
    required this.httpClient,
  });

  Future<int> getWoeid(String city) async {
    final Uri uri = Uri(
      scheme: 'https',
      host: kHost,
      path: '/api/location/search/',
      queryParameters: {'query': city},
    );

    try {
      final http.Response response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception(httpErrorHandler(response));
      }

      final responseBody = json.decode(response.body);
      print('responseBody: $responseBody');
      print('responseBody[0]: ${responseBody[0]}');

      if (responseBody.isEmpty) {
        throw WeatherException('Cannot get the woeid of $city');
      }

      if (responseBody.length > 1) {
        throw WeatherException(
            'There are multiple candidates for city, please specify furthur!');
      }

      return responseBody[0]['woeid'];
    } catch (e) {
      rethrow;
    }
  }

  Future<Weather> getWeather(int woeid) async {
    final Uri uri = Uri(
      scheme: 'https',
      host: kHost,
      path: '/api/location/$woeid',
    );

    try {
      final http.Response response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception(httpErrorHandler(response));
      }

      final weatherJson = json.decode(response.body);
      print('weatherJson: $weatherJson');
      final Weather weather = Weather.fromJson(weatherJson);
      print(weather);

      return weather;
    } catch (e) {
      rethrow;
    }
  }
}
