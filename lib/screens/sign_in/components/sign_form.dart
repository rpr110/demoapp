
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'dart:convert';

import '../../../utlis/constants.dart';

import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../components/default_button.dart';
import '../../../components/exit_screen.dart';

import '../../../utlis/size_config.dart';
import '../../otp/otp_screen.dart';
// import '../../facial_authentication/components/main.dart';
import '../../facial_authentication/facial_auth_screen.dart';





class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  String bvn;
  bool remember = false;
  bool clickedOnce = false;


  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildBVNField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              // Checkbox(
              //   value: remember,
              //   activeColor: kPrimaryColor,
              //   onChanged: (value) {
              //     setState(() {
              //       remember = value;
              //     });
              //   },
              // ),
              // Text("Remember me"),
              Spacer(),
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Continue",
            press: clickedOnce ? (){
              showToast(context, "Please Wait");
            } : () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                
                setState(() {
                  clickedOnce = true;
                });

                String exit_screen_message;
                bool isSucessfull = false;
                bool gotToExitScreen = true;

                String username = 'pekla';
                String password = general_api_password;
                String basicAuth =
                    'Basic ' + base64Encode(utf8.encode('$username:$password'));

                String jwtApiUrl = endpoint_base_url + get_jwt_endpoint;
                print(jwtApiUrl);
                var res = await http.post(
                  jwtApiUrl,
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                    'authorization': basicAuth,
                  },
                  body: jsonEncode(<String, String>{
                    'bvn': bvn,
                    'licenseKey':licenseKey,
                  }),
                );

                print("HERE --> "+res.statusCode.toString());
                // print(json.decode(res.body));
                // var res = TempRes();

                if (res.statusCode==500 || res.statusCode == 502){
                  exit_screen_message = "There seems to be an issue with the server. Please try again later";
                  isSucessfull = false;
                  gotToExitScreen = true;
                }
                else if (res.statusCode == 404){
                  exit_screen_message = "BVN not found";
                  isSucessfull = false;
                  gotToExitScreen = true;
                }else if (res.statusCode == 200){
                  String jwtToken = json.decode(res.body)['token'];
                  Map<String,dynamic> permissions = jsonDecode(res.body)['license_permission'];

                  // bool otpPermission = permissions['otp'] == 1 ? true: false; 

                  bool otpPermission = permissions['otp'] == 1 ? false: false; 
                 

                  bool facialAuthentication = (
                    permissions['face_compare'] == 0 &&
                    permissions['active_liveness'] == 0 &&
                     permissions['passive_liveness'] == 0 &&
                     permissions['face_compare'] ==0
                     ) ? false : true ; // facialAuthentication = true , if either liveness or fac_compare = true  

                  if(otpPermission){

                    String apiUrl = endpoint_base_url + send_otp_endpoint;
                    String deviceData = await getDeviceData();
                    password = 'W31come@412';

                    basicAuth =
                        'Basic ' + base64Encode(utf8.encode('$username:$password'));

                    var res = await http.post(
                      apiUrl,
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                        'authorization': basicAuth,
                      },
                      body: jsonEncode(<String, String>{
                        'BVN': bvn,
                        'deviceData': deviceData,
                        'licenseKey':licenseKey,
                      }),
                    );

                    if(res.statusCode == 200){
                      var apiResponse = json.decode(res.body);
                      if (apiResponse['status'] == 0) {
                        exit_screen_message = "This BVN does not exist\nUse correct spellings and avoid trailing spaces";
                        isSucessfull = false;
                        gotToExitScreen = true;
                      } 
                      else if (apiResponse['status'] == 2) {
                        exit_screen_message = "Email not found";
                        isSucessfull = false;
                        gotToExitScreen = true;
                      } 
                      else if (apiResponse['status'] == 3) {
                        // exit_screen_message = "OTP service failed. Please try again!";
                        exit_screen_message = "API issue. Please inform the Devs!";

                        isSucessfull = false;
                        gotToExitScreen = true;
                      } 
                      else {
                        isSucessfull = true;
                        gotToExitScreen = false;
                        Navigator.pushNamed(context, "/otp",
                            arguments: OtpScreenArguments(bvn, jwtToken, json.encode(permissions) ));
                      }
                    }else{
                      exit_screen_message = "There seems to be an issue with the server please try again";
                      isSucessfull = false;
                      gotToExitScreen = true;
                    }

                  }else if (facialAuthentication){
                    isSucessfull = true;
                    gotToExitScreen = false;
                    Navigator.pushNamed(context,"/facial_authentication",
                      arguments: FacialAuthenticationScreenArguments(bvn, jwtToken, json.encode(permissions)));

                  }else{
                    exit_screen_message = "License doesn't have the permission to do anything!";
                    isSucessfull = false;
                    gotToExitScreen = true;
                  }
                }

                if(gotToExitScreen){
                  Navigator.pushNamed(context,"/exit_screen",
                      arguments: ExitScreenArguments(isSucessfull, exit_screen_message));
                }

              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildBVNField() {
    return TextFormField(
      // keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => bvn = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kUUIDNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kUUIDNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "BVN No.",
        hintText: "Enter your BVN Number",
        
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }
}


// Temporary Fix
class TempRes{
  int statusCode = 200;
  var body = json.encode({"token":"no-token","license_permission":{
    "face_compare":1,
    "active_liveness":1,
    "passive_liveness":0,
    "otp":0
  }});

}