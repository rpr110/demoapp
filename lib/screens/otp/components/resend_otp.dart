import 'dart:async';

import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int secondsRemaining = 7;
  
  bool enableResend = false;
  Timer _timer=Timer(Duration(seconds: 3), () {  });

  @override
  initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(),
        const SizedBox(height: 10),
        // FlatButton(
        //   child: Text('Submit'),
        //   color: Colors.blue,
        //   onPressed: () {
        //     //submission code here
        //   },
        // ),
        const SizedBox(height: 30),
        FlatButton(
          child: Text('Resend Code'),
          onPressed: enableResend ? _resendCode : null,
        ),
        Text(
          'after $secondsRemaining seconds',
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
      ],
    );
  }
  
  void _resendCode() {
    //other code here
    setState((){
      secondsRemaining = 30;
      enableResend = false;
    });
  }
  
  @override
  dispose(){
    _timer.cancel();
    super.dispose();
  }
  
}

