import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String? selectedWeatherType;
  final TextEditingController feedback = TextEditingController();

  final List<Map<String, dynamic>> weatherOptions = [
    {'icon': Icons.wb_sunny, 'label': 'Sunny'},
    {'icon': Icons.cloud, 'label': 'Cloudy'},
    {'icon': Icons.bolt, 'label': 'Stormy'},
    {'icon': Icons.ac_unit, 'label': 'Snowy'},
    {'icon': Icons.water_drop, 'label': 'Rainy'},
  ];

  Future<void> _sendEmail(String feedbackText, String? weatherType) async {
    final String subject = 'User Feedback';
    final String body = Uri.encodeComponent(
      'Feedback: $feedbackText\nSelected Weather: ${weatherType ?? "None"}',
    ).replaceAll('+', '%20');

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'ziadsameh036@gmail.com', 
      query: 'subject=$subject&body=$body',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the email app')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Feedback',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
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

            // Expanded Feedback Text Field
            const Text(
              'Your Feedback',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TextField(
                maxLines: null,
                expands: true,
                controller: feedback,
                style: const TextStyle(color: Colors.white),
                textAlignVertical: TextAlignVertical.top, // Aligns text to top
                decoration: InputDecoration(
                  hintText: 'Type your feedback here...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF5E4C97),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(
                      10), // Padding to control text position
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (feedback.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Feedback is required.'),
                      ),
                    );
                  } else {
                    _sendEmail(feedback.text, selectedWeatherType);
                    feedback.clear();
                    setState(() {
                      selectedWeatherType = null;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3E2D8F),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
    );
  }
}
