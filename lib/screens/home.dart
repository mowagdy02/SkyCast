import 'package:flutter/material.dart';
import 'package:graduation_project/screens/cityscreen.dart';
import 'package:graduation_project/screens/dayscreen.dart';
import 'package:graduation_project/screens/homescreen.dart';
import '../shared/api.dart';
import '../shared/assets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final weatherService = WeatherService();

  List<Widget> screen = [
    HomeScreen(),
    CityScreen(),
    DayScreen(),
  ];
  int index = 0;
  final appAssets = AppAssets();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[index],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: Color(0xFF9D52AC),
                style: BorderStyle.solid,
                strokeAlign: BorderSide.strokeAlignCenter,
                width: 4)),
        child: BottomNavigationBar(
            elevation: 0,
            currentIndex: index,
            onTap: (value) {
              setState(() {
                index = value;
                print(index);
              });
            },
            backgroundColor: Color(0xFF9D52AC),
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home,
                      color: Color.fromARGB(255, 255, 255, 255)),
                  label: "Home"),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.location_city,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                label: "City",
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month,
                      color: Color.fromARGB(255, 255, 255, 255)),
                  label: "Day"),
            ]),
      ),
    );
  }
}
