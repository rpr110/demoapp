import 'package:flutter/material.dart';
import 'package:second_app/screens/facial_authentication/components/noactive2.dart';
import 'dart:convert';
import '../../utlis/size_config.dart';

import 'components/active_liveness.dart';
import 'components/no_active_liveness.dart';

class FacialAuthenticationScreen extends StatelessWidget {
  static const String routeName = "/facial_authentication";

  final String bvn;
  final String jwtToken;
  // final Map<String,dynamic> permissions;
  final String permissions;

  const FacialAuthenticationScreen(
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
      body: json.decode(permissions)['active_liveness'] == 1 ?
        // ActiveLivenessScreen(bvn: bvn,jwtToken: jwtToken, permissions: permissions)
          NoActive2(bvn: bvn, jwtToken: jwtToken, permissions: permissions)

         :
        // NoActiveLivenessScreen(bvn: bvn,jwtToken: jwtToken, permissions: permissions),
        NoActive2(bvn: bvn, jwtToken: jwtToken, permissions: permissions)
        // ActiveLivenessScreen(bvn: bvn,jwtToken: jwtToken, permissions: permissions)
    ));
  }
}

class FacialAuthenticationScreenArguments {
  final String bvn;
  final String jwtToken;
  // final Map<String,dynamic> permissions;
  final String permissions;


  FacialAuthenticationScreenArguments(this.bvn, this.jwtToken,this.permissions);
}
