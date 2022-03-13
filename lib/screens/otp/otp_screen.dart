import 'package:flutter/material.dart';
import '../../utlis/size_config.dart';

import 'components/body.dart';

class OtpScreen extends StatelessWidget {
  static const String routeName = "/otp";

  final String bvn;
  final String jwtToken;
  // final Map<String,dynamic> permissions;
  final String permissions;


  const OtpScreen(
      {Key key,
      @required this.bvn,
      @required this.jwtToken,
      @required this.permissions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new WillPopScope(
      onWillPop: () async => false, 
      child:Scaffold(
      appBar: AppBar(
        title: Text("Step 1"),
      ),
      body: Body(bvn: bvn, jwtToken: jwtToken, permissions: permissions,),
    ));
  }
}

class OtpScreenArguments {
  final String bvn;
  final String jwtToken;
  // final Map<String,dynamic> permissions;
  final String permissions;

  OtpScreenArguments(this.bvn, this.jwtToken,this.permissions);
}
