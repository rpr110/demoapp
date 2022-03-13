// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'screens/otp/otp_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/sign_up/components/upload_picture.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';
// import 'screens/facial_authentication/components/main.dart';
import 'screens/facial_authentication/facial_auth_screen.dart';
import 'components/exit_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {

      // Splash Screen
      case SplashScreen.routeName:
        if (true) {
          return MaterialPageRoute(
            builder: (_) => SplashScreen(),
          );
        }
        return _errorRoute();

      // Sign in screen
      case SignInScreen.routeName:
        if (true) {
          return MaterialPageRoute(
            builder: (_) => SignInScreen(),
          );
        }
        return _errorRoute();    

      case SignUpScreen.routeName:
        if (true) {
          return MaterialPageRoute(
            builder: (_) => SignUpScreen(),
          );
        }
        return _errorRoute();

      case "/uploadPicture":
        return MaterialPageRoute(builder: (_) {
          UploadPictureScreenArguments argument = args;
          return UploadPictureScreen(
              firstname: argument.firstName,
              bvn: argument.bvn,
              phno: argument.phno,
              email: argument.email);
        });
        
      case OtpScreen.routeName:
        return MaterialPageRoute(builder: (_) {
          OtpScreenArguments argument = args;
          return OtpScreen(
              bvn: argument.bvn,
              jwtToken: argument.jwtToken,
              permissions: argument.permissions);
        });

      case ExitScreen.routeName:
        return MaterialPageRoute(builder: (_) {
          ExitScreenArguments argument = args;
          return ExitScreen(
              isSuccessfull: argument.isSuccessfull,
              message: argument.message);
        });


      case FacialAuthenticationScreen.routeName:
        return MaterialPageRoute(builder: (_) {
          FacialAuthenticationScreenArguments argument = args;
          return FacialAuthenticationScreen(
              bvn: argument.bvn,
              jwtToken: argument.jwtToken,
              permissions: argument.permissions,);
        });    

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('FAILED'),
        ),
        body: Center(
          child: Text('UNSUCESSFULL !!'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(
              (_),
              SplashScreen.routeName,
            );
          },
        ),
      );
    });
  }
}
