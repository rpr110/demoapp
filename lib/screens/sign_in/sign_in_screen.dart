import 'package:flutter/material.dart';
import 'components/body.dart';
import '../../utlis/size_config.dart';

class SignInScreen extends StatelessWidget {
  static const String routeName = "/sign_in";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return new WillPopScope(
      onWillPop: () async => false, 
      child: Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: Body(),
    )
      );

  }
}
