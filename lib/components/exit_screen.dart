import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';


import 'default_button.dart';
// import '../screens/splash/splash_screen.dart';
import '../utlis/size_config.dart';

class ExitScreen extends StatefulWidget {
  static const String routeName = "/exit_screen";

  final bool isSuccessfull;
  final String message;
  const ExitScreen(
      {Key key,
      @required this.isSuccessfull,
      @required this.message})
      : super(key: key);

  @override
  _ExitScreen createState() => _ExitScreen(isSuccessfull,message);
}

class _ExitScreen extends State<ExitScreen> {
  final bool isSuccessfull;
  final String message;
  _ExitScreen(this.isSuccessfull,this.message);

  static String routeName = "/exit_screen";
  static const platform = const MethodChannel('com.genisys.peklaApp/data');

  Future<void> _sendResultsToAndroidiOS(bool isSuccessfull, String message) async {

  Map<String, dynamic> resultMap = Map();
  
  resultMap['status'] = isSuccessfull == true ? '1':'0';
  resultMap['verification_result'] = isSuccessfull == true ? 'success':'failure';
  resultMap['message'] = message;
  
  if(Platform.isAndroid){
    try{
      await platform.invokeMethod("flutterCommunicationChannel", resultMap);
    }catch (e){
      print(e.toString());
    }
  }


}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: SizedBox(),
        ),
        body: Column(
          children: [
            SizedBox(height: SizeConfig.screenHeight * 0.04),
            Image.asset(
              isSuccessfull == true ? "assets/images/success.png" : "assets/images/failure.png",
              height: SizeConfig.screenHeight * 0.4, //40%
            ),
            SizedBox(
                width: double.infinity, height: SizeConfig.screenHeight * 0.08),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: getProportionateScreenWidth(30),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Spacer(),
            SizedBox(
              width: SizeConfig.screenWidth * 0.6,
              child: DefaultButton(
                text: "Back to home",
                press: () async {
                  SystemNavigator.pop();
                  
                  var res = await _sendResultsToAndroidiOS(isSuccessfull,message);
                  // Navigator.pushNamed(
                  //   context,
                  //   SplashScreen.routeName,
                  // );
                },
              ),
            ),
            Spacer(),
          ],
        ));
  }
}

class ExitScreenArguments {

  final bool isSuccessfull;
  final String message;

  ExitScreenArguments(this.isSuccessfull, this.message);
}