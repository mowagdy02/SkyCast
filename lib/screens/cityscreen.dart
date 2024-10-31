import 'package:flutter/material.dart';
import 'package:graduation_project/shared/api.dart';
import 'package:graduation_project/widgets/customtext.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  final WeatherService weatherService = WeatherService();
  final TextEditingController _searchController = TextEditingController();
  List<NearbyCity>? nearbyCities = [];
  NearbyCity? searchedCity;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchNearbyCities();
  }

  Future<void> _fetchNearbyCities() async {
    await weatherService.getCurrentWeather();
    setState(() {
      nearbyCities = weatherService.nearbyCities;
    });
  }

  Future<void> _searchCity() async {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      try {
        final response = await weatherService.searchCity(query);
        setState(() {
          searchedCity = NearbyCity(
            name: response.location.name,
            temperature: response.current.tempC,
            weatherDescription: response.current.condition.text,
            iconUrl: response.current.condition.icon,
          );
          errorMessage = '';
        });
      } catch (e) {
        setState(() {
          searchedCity = null;
          errorMessage = 'City not found';
        });
      }
    }
  }

  String _getWeatherIcon(String description) {
    if (description.toLowerCase().contains('rain')) {
      return 'assets/rainy.png';
    } else if (description.toLowerCase().contains('cloud')) {
      return 'assets/cloud_y.png';
    } else {
      return 'assets/sunny.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.all(23),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3E2D8F), Color(0xFF9D52AC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(1, 10, 20, 15),
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9D52AC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const Text(
                  'Search for City',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(width: 48), // Space for alignment
              ],
            ),
            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(17),
                ),
                filled: true,
                fillColor: const Color(0xFF9D52AC),
                hintText: 'Search city',
                hintStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
              onSubmitted: (value) => _searchCity(),
            ),
            const SizedBox(height: 20),

            // Display searched city weather information
            if (searchedCity != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "${searchedCity!.name}: ${searchedCity!.temperature}°C, ${searchedCity!.weatherDescription}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  errorMessage,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16,
                  ),
                ),
              ),

            // Display nearby cities list
            Expanded(
              child: ListView.builder(
                itemCount: nearbyCities?.length ?? 0,
                itemBuilder: (context, index) {
                  final city = nearbyCities![index];
                  final weatherIcon = _getWeatherIcon(city.weatherDescription);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 100,
                          margin: const EdgeInsets.only(
                              bottom: 10, top: 10, left: 10, right: 150),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  const Color.fromARGB(131, 255, 255, 255),
                                  Color.fromARGB(16, 255, 255, 255)
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: city.name,
                                fontsize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              CustomText(
                                text:
                                    "${city.temperature}°C - ${city.weatherDescription}",
                                fontsize: 16,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 100),
                          child: Image.asset(
                            weatherIcon,
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
