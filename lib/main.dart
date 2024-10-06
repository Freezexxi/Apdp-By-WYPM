import 'package:apdpbywypm/subPage/studentStarPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCUigxH9KJ42CW5elo8Rbi8U8cL_JFpCU8",
            authDomain: "apass1bywypm.firebaseapp.com",
            projectId: "apass1bywypm",
            storageBucket: "apass1bywypm.appspot.com",
            messagingSenderId: "206112462960",
            appId: "1:206112462960:web:9baa1ec5783483c45a7cb5",
            measurementId: "G-4Y5GCB54BX"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Star Education Center by WYPM',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 241, 118)),
        useMaterial3: true,
      ),
      home: StudentStarPage(),
    );
  }
}
