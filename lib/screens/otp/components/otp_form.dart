import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import '../../../components/default_button.dart';
import '../../../utlis/size_config.dart';
import '../../../utlis/constants.dart';

import '../../../components/exit_screen.dart';
import '../../../components/loading_screen.dart';
import '../../facial_authentication/facial_auth_screen.dart';
// import '../../facial_authentication/components/main.dart';


class OtpForm extends StatefulWidget {
  final String bvn;
  final String jwtToken;
  // final Map<String,dynamic> permissions;
  final String permissions;



  const OtpForm(
      {Key key,
      @required this.bvn,
      @required this.jwtToken,
      @required this.permissions})
      : super(key: key);

  @override
  _OtpFormState createState() => _OtpFormState(bvn,jwtToken,permissions);
}

class _OtpFormState extends State<OtpForm> {
  final String bvn;
  final String jwtToken;
  // final Map<String,dynamic> permissions;
  final String permissions;


  //////////////////////////////////////////////////////////////////////////////////////////////////////
  int secondsRemaining = 30;
  bool enableResend = false;
  Timer timer;
  ///////////
  _OtpFormState(this.bvn, this.jwtToken,this.permissions);
  bool clickedOnce = false;

  FocusNode pin2FocusNode;
  FocusNode pin3FocusNode;
  FocusNode pin4FocusNode;
  FocusNode pin5FocusNode;
  FocusNode pin6FocusNode;

  bool loading = false;

  Future<void> _resendCode() async {
    //other code here
    String username = 'test';
    String password = 'W31come@412';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    setState(() {
      clickedOnce = true;
    });

    String api_url = endpoint_base_url + send_otp_endpoint;
    // String deviceData = await getDeviceData();
    var res = await http.post(
      api_url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': basicAuth,
      },
      body: jsonEncode(<String, String>{
        'BVN': bvn,
        // 'deviceData': deviceData,
      }),
    );
    setState(() {
      secondsRemaining = 30;
      enableResend = false;
    });
  }

  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
    super.initState();
    Timer timer = Timer.periodic(Duration(seconds: 1), (_) {
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
  void dispose() {
    super.dispose();
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
    pin5FocusNode.dispose();
    pin6FocusNode.dispose();
    timer.cancel();
    super.dispose();
  }

  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  bool isNumeric(String string) {
    if (string == null || string.isEmpty) {
      return false;
    }

    final number = num.tryParse(string);

    if (number == null) {
      return false;
    }

    return true;
  }

  String otp = "";
  String _v1, _v2, _v3, _v4, _v5, _v6;

  @override
  Widget build(BuildContext context) {
    return loading == true
        ? LoadingScreen("Verifying OTP...")
        : Form(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: getProportionateScreenWidth(50),
                      child: TextFormField(
                        autofocus: true,
                        obscureText: true,
                        style: TextStyle(fontSize: 24),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: otpInputDecoration,
                        onChanged: (value) {
                          otp = otp + value;
                          _v1 = value;
                          nextField(value, pin2FocusNode);
                        },
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(50),
                      child: TextFormField(
                        focusNode: pin2FocusNode,
                        obscureText: true,
                        style: TextStyle(fontSize: 24),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: otpInputDecoration,
                        onChanged: (value) {
                          otp = otp + value;
                          _v2 = value;
                          nextField(value, pin3FocusNode);
                        },
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(50),
                      child: TextFormField(
                        focusNode: pin3FocusNode,
                        obscureText: true,
                        style: TextStyle(fontSize: 24),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: otpInputDecoration,
                        onChanged: (value) {
                          otp = otp + value;
                          _v3 = value;
                          nextField(value, pin4FocusNode);
                        },
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(50),
                      child: TextFormField(
                        focusNode: pin4FocusNode,
                        obscureText: true,
                        style: TextStyle(fontSize: 24),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: otpInputDecoration,
                        onChanged: (value) {
                          otp = otp + value;
                          _v4 = value;
                          nextField(value, pin5FocusNode);
                        },
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(50),
                      child: TextFormField(
                        focusNode: pin5FocusNode,
                        obscureText: true,
                        style: TextStyle(fontSize: 24),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: otpInputDecoration,
                        onChanged: (value) {
                          otp = otp + value;
                          _v5 = value;
                          nextField(value, pin6FocusNode);
                        },
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(50),
                      child: TextFormField(
                        focusNode: pin6FocusNode,
                        obscureText: true,
                        style: TextStyle(fontSize: 24),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: otpInputDecoration,
                        onChanged: (value) {
                          if (value.length == 1) {
                            otp = otp + value;
                            _v6 = value;
                            otp = _v1 + _v2 + _v3 + _v4 + _v5 + _v6;
                            pin6FocusNode.unfocus();

                            // Then you need to check is the code is correct or not
                          }
                        },
                      ),
                    ),
                  ],
                ),
                ////////////////////////////////////////////////////////////////////////
                //         SizedBox(height: 30),
                //         FlatButton(
                //   child: Text('Resend Code'),
                //   onPressed: enableResend ? _resendCode : null,
                // ),
                // Text(
                //   'after $secondsRemaining seconds',
                //   style: TextStyle(color: Colors.black, fontSize: 10),
                // ),

                SizedBox(height: SizeConfig.screenHeight * 0.15),
                DefaultButton(
                  text: "Continue",
                  press: () async {

                    if (otp.length < 6 || !isNumeric(otp)) {
                      Fluttertoast.showToast(
                        msg: "Please Enter the OTP",
                        backgroundColor: Colors.grey,
                      );
                    } else {
                      if (!clickedOnce) {
                        setState(() {
                          clickedOnce = true;
                        });

                        String jwt_token = jwtToken;
                        String api_url =
                            endpoint_base_url + verify_otp_endpoint;
                        var deviceData = await getDeviceData();
                     
                        final res = await http.post(
                          api_url,
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                            'x-access-token': jwt_token,
                          },
                          body: jsonEncode(<String, String>{
                            'BVN': bvn,
                            'OTP': otp,                        
                            'deviceData': deviceData
                          }),
                        );

                        String exit_screen_message;
                        bool isSucessfull,gotToExitScreen;

                        if(res.statusCode == 200){
                          var response = json.decode(res.body);
                          print("imheeree --> "+res.statusCode.toString());
                          print("imheeree --> "+response.toString());
                          print("imheeree --> "+permissions.toString());
                          print("imheeree --> "+bvn.toString());
                          print("imheeree --> "+jwtToken.toString());



                          var license_permissions = json.decode(permissions);
                          bool facialAuthentication = (
                            license_permissions['face_compare'] == 0 &&
                            license_permissions['active_liveness'] == 0 &&
                            license_permissions['passive_liveness'] == 0
                            ) ? false : true ; 
                          
                        print("imheeree --> "+facialAuthentication.toString());

                          if (response["status"] == 1) {
                            if(facialAuthentication){
                              gotToExitScreen = false;
                              isSucessfull = true;
                              Navigator.pushNamed(context, "/facial_authentication",
                                  arguments: FacialAuthenticationScreenArguments(bvn, jwt_token,permissions));
                            }else{
                              gotToExitScreen = true;
                              isSucessfull = true;
                              exit_screen_message = "OTP verification succeeded"; 
                            }

                          } else {
                            gotToExitScreen = true;
                            isSucessfull = false;
                            exit_screen_message = "OTP verification failed";                            
                          }

                        }else{
                          gotToExitScreen = true;
                          isSucessfull = false;
                          exit_screen_message = "There seems to be an issue with the server, Please try again later";
                        }

                        if(gotToExitScreen){
                          Navigator.pushNamed(context,"/exit_screen",
                              arguments: ExitScreenArguments(isSucessfull, exit_screen_message));
                        }

                      } else {
                        Fluttertoast.showToast(
                          msg: "Please Wait",
                          backgroundColor: Colors.grey,
                        );
                      }
                    }

                    //  #######
                  },
                )
              ],
            ),
          );
  }
}

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int secondsRemaining = 30;
  bool enableResend = false;
  Timer timer;

  @override
  initState() {
    super.initState();
    Timer timer = Timer.periodic(Duration(seconds: 1), (_) {
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
        FlatButton(
          child: Text('Submit'),
          color: Colors.blue,
          onPressed: () {
            //submission code here
          },
        ),
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
    setState(() {
      secondsRemaining = 30;
      enableResend = false;
    });
  }

  @override
  dispose() {
    timer.cancel();
    super.dispose();
  }
}