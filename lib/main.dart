import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app/sign_in/sign_in_page.dart';

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
      home: SignInPage(),
    );
  }
}
