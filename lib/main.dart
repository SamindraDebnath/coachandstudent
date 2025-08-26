import 'package:coachandstudent/firebase_options.dart';
import 'package:coachandstudent/splashScreen.dart';
import 'package:coachandstudent/style/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


const SIGNAL_URL = String.fromEnvironment(
  'SIGNAL_URL',
  defaultValue: 'http://10.0.2.2:8080', // Android emulator localhost
);

const STUN = {
  'iceServers': [
    {'urls': 'stun:stun.l.google.com:19302'},
    // In production, add TURN servers for better NAT traversal:
    // {'urls': 'turn:your.turn.server:3478', 'username': 'user', 'credential': 'pass'}
  ]
};

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coaching Live',
      theme: isDarkMode ? MyAppTheme.darkTheme : MyAppTheme.lightTheme,
      home: SplashScreen(),
    );
  }
}
