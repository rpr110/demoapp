import 'package:flutter/material.dart';
import '../../screens/splash/components/body.dart';
import '../../utlis/size_config.dart';


class SplashScreen extends StatelessWidget {
  static const String routeName = "/splash";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
      body: Body(),
    )
    );
  }
}
