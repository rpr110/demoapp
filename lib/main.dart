import 'dart:io';

import 'package:flutter/material.dart';
import 'route_generator.dart';
import 'screens/splash/splash_screen.dart';
import 'utlis/theme.dart';
import 'screens/sign_in/sign_in_screen.dart';


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: theme(),
        // home: SplashScreen(),
        home: SignInScreen(),

        onGenerateRoute: RouteGenerator.generateRoute);
  }
}