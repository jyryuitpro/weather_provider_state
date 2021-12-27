import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:weather_provider_state/pages/home_page.dart';
import 'package:weather_provider_state/providers/temp_settings_provider.dart';
import 'package:weather_provider_state/providers/theme_provider.dart';
import 'package:weather_provider_state/providers/weather_provider.dart';
import 'package:weather_provider_state/repositories/weather_repository.dart';
import 'package:weather_provider_state/services/weather_api_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<WeatherRepository>(
          create: (context) {
            final WeatherApiservices weatherApiServices =
                WeatherApiservices(httpClient: http.Client());
            return WeatherRepository(weatherApiservices: weatherApiServices);
          },
        ),
        StateNotifierProvider<WeatherProvider, WeatherState>(
          create: (context) => WeatherProvider(),
        ),
        StateNotifierProvider<TempSettingsProvider, TempSettingsState>(
          create: (context) => TempSettingsProvider(),
        ),
        StateNotifierProvider<ThemeProvider, ThemeState>(
          create: (context) => ThemeProvider(),
        ),
      ],
      builder: (context, _) => MaterialApp(
        title: 'Weather App',
        debugShowCheckedModeBanner: false,
        theme: context.watch<ThemeState>().appTheme == AppTheme.light
            ? ThemeData.light()
            : ThemeData.dark(),
        home: HomePage(),
      ),
    );
  }
}
