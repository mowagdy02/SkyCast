import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String? selectedWeatherType;

  final List<Map<String, dynamic>> weatherOptions = [
    {'icon': Icons.wb_sunny, 'label': 'Sunny'},
    {'icon': Icons.cloud, 'label': 'Cloudy'},
    {'icon': Icons.bolt, 'label': 'Stormy'},
    {'icon': Icons.ac_unit, 'label': 'Snowy'},
    {'icon': Icons.water_drop, 'label': 'Rainy'},
  ];
  TextEditingController email = TextEditingController();
  TextEditingController feedback = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Feedback',
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF3E2D8F), Color(0xFF9D52AC)],
              stops: [0.7, 1.0],
            ),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              const Text(
                'We Value Your Feedback!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Let us know how we can improve or if you encountered any issues.',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 20),

              // Weather Experience Selector
              const Text(
                'Your Weather Experience',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: weatherOptions.map((weather) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedWeatherType = weather['label'];
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: selectedWeatherType == weather['label']
                              ? Colors.white24
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              weather['icon'],
                              color: Colors.white,
                              size: 30,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              weather['label'],
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Feedback Text Field
              const Text(
                'Your Feedback',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                maxLines: 6,
                controller: feedback,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Type your feedback here...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF5E4C97),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Email (Optional)
              const Text(
                'Email (Optional)',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                style: const TextStyle(color: Colors.white),
                controller: email,
                decoration: InputDecoration(
                  hintText: 'Enter your email if you would like a response',
                  hintStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF5E4C97),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    feedback.clear();
                    email.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Thank you for your feedback!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3E2D8F),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
