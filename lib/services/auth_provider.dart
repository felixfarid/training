// [217]

// import 'package:flutter/material.dart';
// import 'auth.dart';

// // [217]
// class AuthProvider extends InheritedWidget {
//   final AuthBase auth;
//   final Widget child;

//   const AuthProvider({Key? key, required this.auth, required this.child})
//       : super(key: key, child: child);

//   @override
//   bool updateShouldNotify(covariant InheritedWidget oldWidget) {
//     return false;
//   }

//   // static - means that we can call this method directly of class
//   // we do not need to create an object of type provider to call this method
//   static AuthBase of(BuildContext context) {
//     AuthProvider? provider =
//         context.dependOnInheritedWidgetOfExactType<AuthProvider>();
//     return provider!.auth;
//   }
// }
