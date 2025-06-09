import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCws5nk8EOvJ8p-RevmbOzWIFhizqv2azU",
      authDomain: "how-s-elsa-day.firebaseapp.com",
      projectId: "how-s-elsa-day",
      storageBucket: "how-s-elsa-day.firebasestorage.app",
      messagingSenderId: "210380627605",
      appId: "1:210380627605:web:ff10c40cb64cc7a906459c",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "How's Elsa Day?",
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const MoodSliderScreen(),
    );
  }
}

class MoodSliderScreen extends StatefulWidget {
  const MoodSliderScreen({super.key});
  @override
  _MoodSliderScreenState createState() => _MoodSliderScreenState();
}

class _MoodSliderScreenState extends State<MoodSliderScreen> {
  double _moodValue = 50;

  String get moodText {
    if (_moodValue < 25) return "😢 Buồn";
    if (_moodValue < 75) return "😐 Bình thường";
    return "😊 Vui";
  }

  Future<void> _sendMood() async {
    final moodData = {
      'value': _moodValue,
      'text': moodText,
      'timestamp': Timestamp.now(),
    };

    await FirebaseFirestore.instance.collection('moods').add(moodData);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Đã gửi cảm xúc: $moodText")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("How's Elsa Day?"),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFCE4EC), Color(0xFFFFCDD2)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    moodText,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("😢", style: TextStyle(fontSize: 30)),
                      Text("😊", style: TextStyle(fontSize: 30)),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.pink,
                      inactiveTrackColor: Colors.pinkAccent.withOpacity(0.3),
                      thumbColor: Colors.pinkAccent,
                      overlayColor: Colors.pinkAccent.withOpacity(0.2),
                    ),
                    child: Slider(
                      value: _moodValue,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      label: _moodValue.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _moodValue = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _sendMood,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Gửi cảm xúc 💌",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
