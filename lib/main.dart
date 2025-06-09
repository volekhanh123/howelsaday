import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCws5nk8EOvJ8p-RevmbOzWIFhizqv2azU",
      authDomain: "how-s-elsa-day.firebaseapp.com",
      projectId: "how-s-elsa-day",
      storageBucket: "how-s-elsa-day.appspot.com",
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
      backgroundColor: Colors.pink[50],
      appBar: AppBar(title: Text("How's Elsa Day?"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(moodText, style: TextStyle(fontSize: 40)),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                const Text("😢", style: TextStyle(fontSize: 30)),
                const Text("😊", style: TextStyle(fontSize: 30)),
              ],
            ),
            Slider(
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
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _sendMood,
              child: Text("Gửi cảm xúc 💌"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
