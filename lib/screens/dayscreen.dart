import 'package:flutter/material.dart';
import 'package:graduation_project/shared/api.dart';

class DayScreen extends StatelessWidget {
  const DayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    await _weatherService.getCurrentWeather();
    setState(() {}); // Refresh UI with the new data
  }

  void _onLocationTap() {}
  void _onAirQualityTap() {}

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3E2D8F), Color(0xFF9D52AC)],
            stops: [0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  // Location Card
                  InkWell(
                    onTap: _onLocationTap,
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            _weatherService.location ?? 'Unknown Location',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _weatherService.dailyForecast != null
                                ? "Max: ${_weatherService.dailyForecast![0].maxTemp}°   Min: ${_weatherService.dailyForecast![0].minTemp}°"
                                : 'Loading...',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 7-Days Forecast Text
                  const Text(
                    '7-Days Forecasts',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // 7-Day Forecast Cards
                  SizedBox(
                    height: 160,
                    child: _weatherService.dailyForecast != null
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _weatherService.dailyForecast!.length,
                            itemBuilder: (context, index) {
                              final dayForecast =
                                  _weatherService.dailyForecast![index];
                              return _buildDayCard(
                                day: dayForecast.date,
                                temp:
                                    "${dayForecast.maxTemp}° / ${dayForecast.minTemp}°",
                                iconPath: _getWeatherIcon(dayForecast),
                              );
                            },
                          )
                        : Center(child: CircularProgressIndicator()),
                  ),
                  const SizedBox(height: 30),

                  // Air Quality Card
                  InkWell(
                    onTap: _onAirQualityTap,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 30),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF9D52AC), Color(0xFF3E2D8F)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AIR QUALITY',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            '3 - Low Health Risk',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'See more',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Info Cards (Sunrise/Sunset, UV Index)
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          'SUNRISE',
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _weatherService.dailyForecast?[0].sunrise ??
                                    'N/A',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Sunset: ${_weatherService.dailyForecast?[0].sunset ?? 'N/A'}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          withBorder: true,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildInfoCard(
                          'UV INDEX',
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '4',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Moderate',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          withBorder: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayCard({
    required String day,
    required String temp,
    required String iconPath,
  }) {
    return Container(
      width: 130,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3E2D8F), Color(0xFF9D52AC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Image.asset(
            iconPath,
            width: 34,
            height: 34,
          ),
          const SizedBox(height: 8),
          Text(
            temp,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // Helper to determine the correct icon based on forecast
  String _getWeatherIcon(DailyForecast forecast) {
    // This is a placeholder logic. Adjust based on forecast conditions
    if (forecast.maxTemp > 25) {
      return 'assets/sunny.png';
    } else if (forecast.maxTemp > 15) {
      return 'assets/cloudy.png';
    } else {
      return 'assets/rainy.png';
    }
  }

  Widget _buildInfoCard(String title, Widget content,
      {bool withBorder = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3E2D8F), Color(0xFF9D52AC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: withBorder ? Border.all(color: Colors.white, width: 2) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }
}
