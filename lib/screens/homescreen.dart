import 'package:flutter/material.dart';
import 'package:graduation_project/widgets/customtext.dart';
import 'package:intl/intl.dart';
import '../shared/api.dart';
import '../shared/assets.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final weatherService = WeatherService();

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<void> getCurrentWeather() async {
    await weatherService.getCurrentWeather();
    setState(() {}); // Update UI after fetching data
  }

  int index = 0;
  final appAssets = AppAssets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: weatherService.location == null
          ? Scaffold(
              body: Center(
                child: Text(
                  "Permission not allowed, Please give me the permission",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            )
          : Center(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(width: 0),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF3E2D8F),
                      Color(0xFF9D52AC),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    weatherService.isRainy
                        ? Container(child: Image.asset(appAssets.sunnyrainImg))
                        : Container(child: Image.asset(appAssets.sunnyImg)),
                    CustomText(
                        text: "${weatherService.temperature} C", fontsize: 36),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(text: "min: ${weatherService.minTemp} C"),
                        SizedBox(width: 10),
                        CustomText(text: "max: ${weatherService.maxTemp} C"),
                      ],
                    ),
                    Image.asset(appAssets.home),
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(bottom: 6, left: 6, right: 6),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.black, blurRadius: 5)
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF3E2D8F),
                                Color(0xFF9D52AC),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                weatherService.hourlyTemperatures?.length ?? 0,
                                (index) {
                                  final temp =
                                      weatherService.hourlyTemperatures![index];
                                  final time = addHourToTime(
                                      weatherService.lastUpdatedHour, index);
                                  return DayCard(
                                    image: appAssets.sunnyImg,
                                    degree: "$temp",
                                    clock: time,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

// ignore: non_constant_identifier_names
Widget DayCard({
  required String image,
  required String degree,
  required String clock,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: 100,
      height: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(text: "$degree C"),
          Image.asset(image),
          CustomText(text: clock),
        ],
      ),
    ),
  );
}

// Function to add hours to `lastUpdatedHour`
String addHourToTime(String? lastUpdatedHour, int hoursToAdd) {
  if (lastUpdatedHour == null) return 'N/A';

  DateTime parsedTime = DateFormat('HH:mm').parse(lastUpdatedHour);
  DateTime updatedTime = parsedTime.add(Duration(hours: hoursToAdd));
  return DateFormat('HH:mm').format(updatedTime);
}
