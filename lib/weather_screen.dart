import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  @override
  void initState() {
    super.initState();
    weather = getCurrentWeatherData();
  }

  Future<Map<String, dynamic>> getCurrentWeatherData () async {
    final String apiKey = dotenv.env['OPEN_WEATHER_API_KEY']!;
    const String cityName = 'Bangalore';

    try {
      final res = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey"
      ));

      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw('Something went wrong while fetching weather data');
      }
      return data;
    } catch (e) {
      throw(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold
          )
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeatherData();
              });
            },
            icon: const Icon(Icons.refresh)
          )
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {

          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if(snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
            );
          }

          final data = snapshot.data!;
          final currentWeatherInfo = data['list'][0];
          final currentTemperature = currentWeatherInfo['main']['temp'];
          final currentWeather = currentWeatherInfo['weather'][0]['main'];
          final currentHumidity = currentWeatherInfo['main']['humidity'];
          final currentWindSpeed = currentWeatherInfo['wind']['speed'];
          final currentPressure = currentWeatherInfo['main']['pressure'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemperature K',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(height: 16),
                              Icon(
                                currentWeather == 'Clouds' || currentWeather == 'Rain' ? Icons.cloud : Icons.sunny,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                currentWeather,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // weather forecast card
                const Text(
                  'Weather Forecast',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    itemCount: data['list'].length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final weatherInfo = data['list'][index];
                      final time = DateTime.parse(weatherInfo['dt_txt'].toString());
                      final temperature = weatherInfo['main']['temp'];
                      final weather = weatherInfo['weather'][0]['main'];
                  
                      return HourlyForecastItem(
                        time: DateFormat.j().format(time),
                        icon: weather == 'Clouds' || weather == 'Rain' ? Icons.cloud : Icons.sunny,
                        temperature: '$temperature K',
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // additional info card
                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: currentHumidity.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.waves,
                      label: 'Wind Speed',
                      value: currentWindSpeed.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: currentPressure.toString(),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      )
    );
  }
}