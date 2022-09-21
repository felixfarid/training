import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/services/auth.dart';
import 'app/landing_page.dart';

// void main() {
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // we can run our app only after the previous code line is complete
  // we need to add 'await' keyword
  // after adding 'await', all the code that follows this line
  // will only execute after the future has completed.
  // we can use 'await' only inside async methods.
  // the return type of async method should be Future
  runApp(MyApp());
}

// when extending StatelessWidget
// you have to implement a build method
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // override tells compiler that we've actually
  // overriding a method on the superclass (parent - stateless)
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracker',
      // Some wages will inherit some of their visual
      // properties from theme data.
      // Whenever you ask yourself where a certain color or
      // textile comes from - it’s from ThemeData
      theme: ThemeData(primarySwatch: Colors.indigo),
      // AuthBase is an abstract class we cannot pass it
      home: LandingPage(auth: Auth()),
    );
  }
}
