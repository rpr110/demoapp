import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  
  LoadingScreen(this.message);

  final String message ;


  @override
  Widget build(BuildContext context) {
    return new WillPopScope( 
    onWillPop: () async => false,
    child:Scaffold(
        backgroundColor: Color(0xFF172247),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
           
          children: [
            Center(             
              child: SpinKitChasingDots(color: Colors.cyanAccent, size: 50),
            ),
            Text("   "),
            // Text("VERYFYING FACE....", style: TextStyle(color: Colors.cyanAccent))
            Text(message, style: TextStyle(color: Colors.cyanAccent))

             ],
        ))));
  }
}
