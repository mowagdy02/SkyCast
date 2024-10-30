import 'package:geolocator/geolocator.dart';
import 'package:weatherapi/weatherapi.dart';
import 'package:intl/intl.dart';

class AppConfig {
  static const String weatherApiKey = '5990171156114dbd8b0124534242610';
}

class WeatherService {
  static final WeatherService _instance = WeatherService._internal();
  factory WeatherService() => _instance;

  final WeatherRequest _weatherRequest;
  String? _location;
  double? _temperature;
  int? _humidity;
  double? _windSpeed;
  double? _precipitation;
  DateTime? _lastUpdated;
  double? _maxTemp;
  double? _minTemp;
  List<double>? _hourlyTemperatures;
  List<DailyForecast>? _dailyForecast;
  List<NearbyCity>? _nearbyCities;

  String errorMessage = '';

  WeatherService._internal()
      : _weatherRequest = WeatherRequest(AppConfig.weatherApiKey);

  // Generate nearby city coordinates by applying offsets
  List<Map<String, double>> _generateNearbyCoordinates(double lat, double lon) {
    const offsets = [4, -4, 6, -6]; // Adjust as necessary
    List<Map<String, double>> nearbyCoordinates = [];

    for (var latOffset in offsets) {
      for (var lonOffset in offsets) {
        if (nearbyCoordinates.length >= 6) break;
        nearbyCoordinates.add({'lat': lat + latOffset, 'lon': lon + lonOffset});
      }
    }

    return nearbyCoordinates;
  }

  Future<void> getCurrentWeather() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          errorMessage =
              'Location permissions are denied. Enable them in settings.';
          _location = null;
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final response = await _weatherRequest.getForecastWeatherByLocation(
          position.latitude, position.longitude,
          forecastDays: 7);

      _location = response.location.name;
      _temperature = response.current.tempC;
      _humidity = response.current.humidity;
      _windSpeed = response.current.windKph;
      _precipitation = response.current.precipMm;
      _lastUpdated = DateTime.tryParse('${response.current.lastUpdated}');

      _maxTemp = response.forecast.elementAt(0).day.maxtempC;
      _minTemp = response.forecast.elementAt(0).day.mintempC;

      _hourlyTemperatures = response.forecast
          .elementAt(0)
          .hour
          .map((hour) {
            return hour.tempC;
          })
          .cast<double>()
          .toList();

      _dailyForecast = response.forecast.map((dayForecast) {
        DateTime date = DateTime.parse(dayForecast.date.toString());

        return DailyForecast(
          date: DateFormat('EEEE').format(date),
          maxTemp: dayForecast.day.maxtempC!.toDouble(),
          minTemp: dayForecast.day.mintempC!.toDouble(),
          sunrise: dayForecast.astro.sunrise.toString(),
          sunset: dayForecast.astro.sunset.toString(),
        );
      }).toList();

      // Generate nearby city coordinates and fetch weather data
      await _fetchNearbyCitiesWeather(position.latitude, position.longitude);

      errorMessage = ''; // Clear error message if successful
    } catch (e) {
      errorMessage = 'Error fetching weather data. Please try again.';
      _location = null;
      _temperature = null;
      _humidity = null;
      _windSpeed = null;
      _precipitation = null;
      _lastUpdated = null;
      _maxTemp = null;
      _minTemp = null;
      _hourlyTemperatures = null;
      _dailyForecast = null;
      _nearbyCities = null;
    }
  }

  Future<dynamic> searchCity(String cityName) async {
    final response =
        await _weatherRequest.getForecastWeatherByCityName(cityName);
    return response;
  }

  Future<void> _fetchNearbyCitiesWeather(double lat, double lon) async {
    _nearbyCities = [];
    List<Map<String, double>> nearbyCoordinates =
        _generateNearbyCoordinates(lat, lon);

    for (var coords in nearbyCoordinates) {
      try {
        final response = await _weatherRequest.getForecastWeatherByLocation(
          coords['lat']!,
          coords['lon']!,
          forecastDays: 1,
        );

        _nearbyCities!.add(NearbyCity(
          name: response.location.name.toString(),
          temperature: response.current.tempC!.toDouble(),
          weatherDescription: response.current.condition.text.toString(),
          iconUrl: response.current.condition.icon.toString(),
        ));
      } catch (e) {
        print(
            'Error fetching data for location (${coords['lat']}, ${coords['lon']}): $e');
      }
    }
  }

  // Getters for weather data
  String? get location => _location;
  double? get temperature => _temperature;
  int? get humidity => _humidity;
  double? get windSpeed => _windSpeed;
  double? get precipitation => _precipitation;
  DateTime? get lastUpdated => _lastUpdated;
  double? get maxTemp => _maxTemp;
  double? get minTemp => _minTemp;
  List<double>? get hourlyTemperatures => _hourlyTemperatures;
  List<DailyForecast>? get dailyForecast => _dailyForecast;
  List<NearbyCity>? get nearbyCities => _nearbyCities;

  String? get lastUpdatedHour {
    if (_lastUpdated != null) {
      return DateFormat('HH:mm').format(_lastUpdated!);
    }
    return null;
  }

  bool get isRainy {
    return (_precipitation != null && _precipitation! > 0);
  }
}

// Define a class to hold daily forecast data
class DailyForecast {
  final String date;
  final double maxTemp;
  final double minTemp;
  final String sunrise;
  final String sunset;

  DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.sunrise,
    required this.sunset,
  });
}

// Define a class to hold nearby cities weather data
class NearbyCity {
  final String name;
  final double temperature;
  final String weatherDescription;
  final String iconUrl;

  NearbyCity({
    required this.name,
    required this.temperature,
    required this.weatherDescription,
    required this.iconUrl,
  });
}
