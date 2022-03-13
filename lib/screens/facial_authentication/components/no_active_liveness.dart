import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../components/loading_screen.dart';


import '../../../utlis/constants.dart';
import '../../../components/exit_screen.dart';


class NoActiveLivenessScreen extends StatefulWidget {
  final String bvn;
  final String jwtToken;
  // final Map<String,dynamic> permissions;
  final String permissions;


  const NoActiveLivenessScreen(
      {Key key,
      @required this.bvn,
      @required this.jwtToken,
      @required this.permissions})
      : super(key: key);
  @override
  NoActiveLivenessScreenState createState() => NoActiveLivenessScreenState(bvn, jwtToken,permissions);
}

class NoActiveLivenessScreenState extends State<NoActiveLivenessScreen> {
  String bvn;
  String jwtToken;
  // final Map<String,dynamic> permissions;
  final String permissions;


  NoActiveLivenessScreenState(this.bvn, this.jwtToken,this.permissions);
  bool _loading = false;

  File _image;
  final imagePicker = ImagePicker();


  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    _initializeCamera();
  }

  Future _initializeCamera() async {
    
    final image  = await imagePicker.getImage(source: ImageSource.camera,preferredCameraDevice: CameraDevice.front);
    setState(() {
      _loading = true;
    });
    String apiEndpoint = endpoint_base_url + verify_face_endpoint;
    var res = await sendDataToServer(apiEndpoint, jwtToken, bvn, File(image.path));

    if (res['status'] == 1) {
      Navigator.pushNamed(context,"/exit_screen",
        arguments: ExitScreenArguments(true, "Face Authentication Success"));
    } else {
      Navigator.pushNamed(context,"/exit_screen",
        arguments: ExitScreenArguments(false, "Face Authentication Failed"));
    }
  }

  int dartTime() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  int parseDartTime(int dartTimeInMilliseconds) {
    return (dartTimeInMilliseconds / 1000).toInt();
  }


  Future<Map> sendDataToServer(
      String apiEndpoint, String token, String bvn, File image) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(apiEndpoint),
    );
    String username = 'pekla';
    String password = r'P$KL&(#@412';
    String basicAuth ='Basic ' + base64Encode(utf8.encode('$username:$password'));
    Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      "x-access-token": token,
      "authorization":basicAuth
    };
    request.files.add(
      http.MultipartFile(
        'Image',
        image.readAsBytes().asStream(),
        image.lengthSync(),
        filename: bvn + "_live.jpg",
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    var deviceData = await getDeviceData();

    request.fields['BVN'] = bvn;
    request.fields['deviceData'] = deviceData;
    request.fields['licenseKey']=licenseKey;
    request.fields['targetFunction']="3";
    request.headers.addAll(headers);
    print("request: " + request.toString());
    // request.send().then((value) => print(value.statusCode));

    final response = await request.send();

    if (response.statusCode != 200) {
      return {"status": 0};
    }
    final res = await http.Response.fromStream(response);
    return (json.decode(res.body));
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: _loading == true ? LoadingScreen("Verifying ....") : CircularProgressIndicator(),
        ));
  }
}
