import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'dart:math' as Math;

import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:quiver/collection.dart';
import 'package:flutter/services.dart';
import '../../../components/loading_screen.dart';

import 'detector_painters.dart';
import 'utils.dart';
import '../../../utlis/constants.dart';
import '../../../components/exit_screen.dart';

import 'package:fluttertoast/fluttertoast.dart';
// import 'package:downloads_path_provider/downloads_path_provider.dart';


class NoActive2 extends StatefulWidget {
  final String bvn;
  final String jwtToken;
  // final Map<String,dynamic> permissions;
  final String permissions;

  

  const NoActive2(
      {Key key,
      @required this.bvn,
      @required this.jwtToken,
      @required this.permissions})
      : super(key: key);
  @override
  NoActive2State createState() => NoActive2State(bvn, jwtToken,permissions);
}

class NoActive2State extends State<NoActive2> {
  String bvn;
  String jwtToken;
  // final Map<String,dynamic> permissions;
  final String permissions;


  NoActive2State(this.bvn, this.jwtToken,this.permissions);
  bool _loading;
  bool clickedOnce = false;
  String _isSmiling = "";
  String _isBlinking = "";
  String _ryanAppBarText = "No Face Detected";
  File jsonFile;
  dynamic _scanResults;
  CameraController _camera;
  var interpreter;
  bool _isDetecting = false;
  CameraLensDirection _direction = CameraLensDirection.front;
  dynamic data = {};
  double threshold = 1.0;
  Directory tempDir;
  List e1;
  bool _faceFound = false;
  int minTimeForDetection = 120;

  Offset left_Cheek_pos; //300
  Offset right_Cheek_pos;
bool inPlace = false;
  int waitTime = 2000;
  Map <String,List<String>> completed ={
    "smile": [
      "Please Smile",
      "Complete this task by smiling infront of your camera after pressing 'Ok'"
    ],
    "look_left": [
      "Turn your head to the Left",
      "Complete this task by turning your head to the left after pressing 'Ok'"
    ],
    "look_right": [
      "Turn your head to the Right",
      "Complete this task by turning your head to the right after pressing 'Ok'"
    ],
    "look_top left": [
      "Turn your head up",
      "Complete this task by turning your head to the right after pressing 'Ok'"
    ],
    "look_top right": [
      "Turn your head up",
      "Complete this task by turning your head to the right after pressing 'Ok'"
    ],
    "blink": [
      "Blink",
      "Complete this task by blinking after pressing 'Ok'"
    ]
  };
  Map<String, List<String>> actionMessages = {
    "smile": [
      "Please Smile",
      "Complete this task by smiling infront of your camera after pressing 'Ok'"
    ],
    "look_left": [
      "Turn your head to the Left",
      "Complete this task by turning your head to the left after pressing 'Ok'"
    ],
    "look_right": [
      "Turn your head to the Right",
      "Complete this task by turning your head to the right after pressing 'Ok'"
    ],
    "look_top left": [
      "Turn your head up",
      "Complete this task by turning your head to the right after pressing 'Ok'"
    ],
    "look_top right": [
      "Turn your head up",
      "Complete this task by turning your head to the right after pressing 'Ok'"
    ],
    "blink": [
      "Blink",
      "Complete this task by blinking after pressing 'Ok'"
    ]
  };
  bool justChanged = false;
  bool oneTimeActionInstructionPopup = true;
  int noOfRandomTask = 2;
  bool shouldWaitForPrevious = false;
  bool workaroundDelay = false;
  int workaroundDelayTime = 9223372036854775807;
  int timeSinceNew = 0;
  int nTime;
  bool shouldStartTimer = true;
  int blinky = 0;
  bool _greenBoundingBox = false;
  int totalBlinks = 0;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    _initializeCamera();
  }

  void _initializeCamera() async {
    CameraDescription description = await getCamera(_direction);

    ImageRotation rotation = rotationIntToImageRotation(
      description.sensorOrientation,
    );

    _camera = CameraController(description, ResolutionPreset.high,
        enableAudio: false);
    await _camera.initialize();
    await Future.delayed(Duration(milliseconds: 500));
    tempDir = await getApplicationDocumentsDirectory();
    String _embPath = tempDir.path + '/emb.json';
    jsonFile = new File(_embPath);
    if (jsonFile.existsSync()) data = json.decode(jsonFile.readAsStringSync());

    int startTime = dartTime();
    Math.Random random = new Math.Random();

    _camera.startImageStream((CameraImage image) {
      if (_camera != null) {
        if (blinky==0){
          blinky = dartTime();
        }
        if (_isDetecting) return;
        _isDetecting = true;
        String res;
        dynamic finalResult = Multimap<String, Face>();
        detect(image, _getDetectionMethod(), rotation).then(
          (dynamic result) async {
            if (parseDartTime(dartTime() - startTime) < minTimeForDetection) {

              if (result.length == 0) {
                _faceFound = false;
                _ryanAppBarText = "No Face Visible";
                justChanged = false;
              } else {
                _faceFound = true;
                _ryanAppBarText = "Blink to Take a Picture";
              }

              Face _face;

              // Check if theres more than one face
              if (result.length == 1) {
                for (_face in result) {
                  // res = actionMessages[action][0];

                  var res = "[]|-|2";


                  finalResult.add(res, _face);
                  print("-->"+_face.boundingBox.toString());
                  
                  Offset left_Cheek_pos = _face.getLandmark(FaceLandmarkType.leftCheek).position; //300
                  Offset right_Cheek_pos = _face.getLandmark(FaceLandmarkType.rightCheek).position;

                  print("lcp --> $left_Cheek_pos || dx -> ${left_Cheek_pos.dx} || dy -> ${left_Cheek_pos.dy}");
                  print("rcp --> $right_Cheek_pos || dx -> ${right_Cheek_pos.dx} || dy -> ${right_Cheek_pos.dy}");

                    _ryanAppBarText = "Blink to take a picture";
                    // Take pic (by binking) once actions are performed

                    if(left_Cheek_pos.dx < 250 && right_Cheek_pos.dx>460){
                    setState(() {
                      inPlace=true;
                    });
                    }else{
                      inPlace=false;
                    }
                    if ((dartTime() - blinky) > 1000) {
                      if(left_Cheek_pos.dx < 250 && right_Cheek_pos.dx>460){

                      if (_face.leftEyeOpenProbability < 0.175 &&
                          _face.rightEyeOpenProbability < 0.175) {
                        _isBlinking = _isBlinking.toString() + "1";
                      } else {
                        _isBlinking = _isBlinking.toString() + "1";
                      }
                      }

                    }

                    if (_isBlinking.length > 100) {
                      setState(() {
                        _isBlinking = _isBlinking.substring(20);
                      });
                    }

                    if (isBlinkThresholdOscilate(_isBlinking)) {
                      setState(() {
                        _loading = true;
                      });

                      // TO-DO logging post api here
                      logActiveLiveness(5);
                      
                      var licensePermissions = json.decode(permissions);
                      bool shouldHitVerifyFaceEndpoint = (licensePermissions['passive_liveness'] == 1 || licensePermissions['face_compare'] == 1) ? true:false;

                      if(shouldHitVerifyFaceEndpoint){

                        _greenBoundingBox = true;
                        FlutterBeep.beep();
                        var path = '';
                        String finalImagePath;
                        List<int> imageBytes;
                        if (Platform.isAndroid) {
                          path = (await getExternalStorageDirectory()).path;
                          var path2 = path + '/' + '${DateTime.now()}.jpg';
                          await _camera.stopImageStream();
                          await _camera.takePicture(path2);

                          // File imagePath = File(path2);
                          // //get temporary directory
                          // final tempDir = await getExternalStorageDirectory();
                          // int rand = new Math.Random().nextInt(10000);
                          // //reading jpg image
                          // imglib.Image image =
                          //     imglib.decodeImage(imagePath.readAsBytesSync());
                          // //decreasing the size of image- optional
                          // imglib.Image smallerImage =
                          //     imglib.copyResize(image, width: 720, height: 1080);
                          // //get converting and saving in file
                          // File compressedImage =
                          //     new File('${tempDir.path}/img_$rand.png')
                          //       ..writeAsBytesSync(
                          //           imglib.encodePng(smallerImage, level: 9));

                          // var pngPath = "${tempDir.path}/img_$rand.png";

                          // // imageBytes = await File(pngPath).readAsBytes();
                          // finalImagePath = pngPath;
                          // // var x = await decodeImageFromList(imageBytes);
                          finalImagePath = path2;

                        } else {
                          path = (await getApplicationDocumentsDirectory()).path;
                          var path2 = path + '/' + '${DateTime.now()}.jpg';
                          // await _camera.stopImageStream();
                          await _camera.takePicture(path2);
                          // var imageResized =
                          //     await FlutterNativeImage.compressImage(path2,
                          //         quality: 100,
                          //         targetWidth: 100,
                          //         targetHeight: 100);
                          await _camera.stopImageStream();
                          await _camera.dispose();
                          // imageBytes = imageResized.readAsBytesSync();
                          finalImagePath = path2;
                        }

                        // var photoBase64 = base64Encode(imageBytes);
        

                        String jwt_token = jwtToken;
                        String api_url = endpoint_base_url + verify_face_endpoint;

                        String target;
                        if(licensePermissions['passive_liveness'] == 1 && licensePermissions['face_compare'] == 1){
                          target = "3";
                        }else if (licensePermissions['passive_liveness'] == 0 && licensePermissions['face_compare'] == 1){
                          target = "2";
                        }else if(licensePermissions['passive_liveness'] == 1 && licensePermissions['face_compare'] == 0){
                          target = "1";
                        }else{
                          target = "-1";
                        }

                        target = "2";

                        var res = await sendDataToServer(
                            api_url, jwt_token, bvn, File(finalImagePath),target);

                        if (res['status'] == 1) {
                          Navigator.pushNamed(context,"/exit_screen",
                            arguments: ExitScreenArguments(true, "Face Authentication Success"));
                        } else {
                          Navigator.pushNamed(context,"/exit_screen",
                            arguments: ExitScreenArguments(false, "Face Authentication Failed"));
                        }

                        setState(() {
                          _isBlinking = "";
                          _camera = null;
                          _ryanAppBarText = "You Blinked!!";
                        });

                      }else{
                        Navigator.pushNamed(context,"/exit_screen",
                          arguments: ExitScreenArguments(true, "Active Liveness Successful"));
                      }
                    }
                  
                }
              }
              // print(_isSmiling);
              setState(() {
                _scanResults = finalResult;
                _greenBoundingBox = _greenBoundingBox;
              });

              _isDetecting = false;
            } else {
              // else if youve have crossed the limit to keep the camera open
              await _camera.stopImageStream();
              await _camera.dispose();
              setState(() {
                _isDetecting = false;
                _camera = null;
              });
              // TO-DO negative logging post api here
              logActiveLiveness(6);
              Navigator.pushNamed(context,"/exit_screen",
                arguments: ExitScreenArguments(false, "Face Authentication Failed"));              
            }
          },
        ).catchError(
          (_) {
            print(_);
            print("ERROR!!!!!!");

            _isDetecting = false;
          },
        );
      }
    });
  }

  int dartTime() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  int parseDartTime(int dartTimeInMilliseconds) {
    return (dartTimeInMilliseconds / 1000).toInt();
  }

  List<String> generateRandomActions(int noOfActions) {
    Math.Random random = new Math.Random();
    List<String> actions = new List();

    // List<String> listOfActions = ['look_right','look_left','smile'];
    List<String> listOfActions = ['blink','smile'];

    // if(false){
    //   listOfActions.add('remove_glasses');
    // }
    // if (false){
    //   // listOfActions.add( <another task> )
    // }

    for (int i = 0; i < noOfActions; i++) {
      int rand = random.nextInt(listOfActions.length);
      actions.add(listOfActions[rand]);
      listOfActions.remove(listOfActions[rand]);
    }
    return actions;
  }

  // static Future<void> save( String content) async {
  //   String filename = "pekla_b64_img.txt";
  //   final directory = await DownloadsPathProvider.downloadsDirectory;
  //   final path = '${directory.path}/$filename';
  //   final file = File(path);
  //   print("Saving $path");
  //   await file.writeAsString(content);
  // }

  Future<void> logActiveLiveness(int status) async {
    String apiUrl =  endpoint_base_url + log_active_liveness_url;
    // success 5  fail -> 6
    final res = await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': jwtToken,
      },
      body: jsonEncode(<String, dynamic>{
        'bvn': bvn,
        'licenseKey': licenseKey,                        
        'status': status
      }),
    );
  }

  String peklaEncode(String b64String) {
    List<String> unsafeStrings = [
      '!',
      '"',
      '#',
      '\$',
      '%',
      '&',
      "'",
      '(',
      ')',
      '*',
      '+',
      ',',
      '-',
      '.',
      '/',
      ':',
      ';',
      '<',
      '=',
      '>',
      '?',
      '@',
      '[',
      '\\',
      ']',
      '^',
      '_',
      '`',
      '{',
      '|',
      '}',
      '~',
      'm0XBCCf'
    ];
    var encodedString = b64String;

    unsafeStrings.asMap().forEach((index, value) =>
        encodedString = encodedString.replaceAll(value, "pe$index" + "ge"));

    return encodedString;
  }

  void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

  Future<Map> sendDataToServer(
      String apiEndpoint, String token, String bvn, File image,String target) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(apiEndpoint),
    );
    String username = 'pekla';
    // String password = r'P$KL&(#@412';
    String password = general_api_password;
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
    request.fields['targetFunction']=target;
    request.fields['device_os']=getDeviceOs();
    
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

  bool isSmileThresholdOscilate(String str) {
    RegExp exp = new RegExp(r"01");
    Iterable<Match> matches = exp.allMatches(str);
    if (matches.length > 0) {
      return (true);
    }
    return (false);
  }

  bool isBlinkThresholdOscilate(String str) {
    // return false;
    RegExp exp = new RegExp(r"10+1");

    Iterable<Match> matches = exp.allMatches(str);
    if (matches.length > 0) {
      return (true);
    }
    return (false);
  }

  HandleDetection _getDetectionMethod() {
    final faceDetector = FirebaseVision.instance.faceDetector(
      FaceDetectorOptions(
        enableClassification: true,
        enableLandmarks: true,
        enableTracking: true,
        minFaceSize: 1.0,
        mode: FaceDetectorMode.accurate,
      ),
    );
    return faceDetector.processImage;
  }

  Widget _buildResults() {
    const Text noResultsText = const Text('');
    if (_scanResults == null ||
        _camera == null ||
        !_camera.value.isInitialized) {
      return noResultsText;
    }
    CustomPainter painter;

    final Size imageSize = Size(
      _camera.value.previewSize.height,
      _camera.value.previewSize.width,
    );
    painter = FaceDetectorPainter(imageSize, _scanResults, _greenBoundingBox);
    return CustomPaint(
      painter: painter,
    );
  }

  Widget _buildImage() {
    if (_camera == null || !_camera.value.isInitialized) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
      constraints: const BoxConstraints.expand(),
      child: _camera == null
          ? const Center(child: null)
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CameraPreview(_camera),
                _buildResults(),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          // appBar: _loading == true
          //     ? null
          //     : AppBar(
          //         title: Text("$_ryanAppBarText",textAlign: TextAlign.center,style: new TextStyle(fontWeight: FontWeight.bold)),
          //       ),
          // body: _loading == true ? LoadingScreen("Verifying ....") : _buildImage(),
          body: _loading == true ? LoadingScreen("Verifying ....") : ClipOval(
            child: _buildImage(),
            clipper: MyClip(),
          ),
          floatingActionButton: new Visibility(visible: !clickedOnce, child : new FloatingActionButton(
            child: new Icon(Icons.camera),
            
            onPressed: () async {

              

              if( !clickedOnce){

              if(inPlace){
                
                setState(() {
                  _loading = true;
                  clickedOnce = true;
                });
                


                var licensePermissions = json.decode(permissions);
                bool shouldHitVerifyFaceEndpoint = (licensePermissions['passive_liveness'] == 1 || licensePermissions['face_compare'] == 1) ? true:false;

                if(shouldHitVerifyFaceEndpoint){

                  _greenBoundingBox = true;
                  FlutterBeep.beep();
                  var path = '';
                  String finalImagePath;
                  List<int> imageBytes;
                  if (Platform.isAndroid) {
                    path = (await getExternalStorageDirectory()).path;
                    var path2 = path + '/' + '${DateTime.now()}.jpg';
                    await _camera.stopImageStream();
                    await _camera.takePicture(path2);
                    finalImagePath = path2;

                  } else {
                    path = (await getApplicationDocumentsDirectory()).path;
                    var path2 = path + '/' + '${DateTime.now()}.jpg';
                    // await _camera.stopImageStream();
                    await _camera.takePicture(path2);
                    var imageResized =
                        await FlutterNativeImage.compressImage(path2,
                            quality: 100,
                            targetWidth: 100,
                            targetHeight: 100);
                    await _camera.stopImageStream();
                    await _camera.dispose();
                    imageBytes = imageResized.readAsBytesSync();
                    finalImagePath = path2;
                  }

                  // var photoBase64 = base64Encode(imageBytes);
  

                  String jwt_token = jwtToken;
                  String api_url = endpoint_base_url + verify_face_endpoint;

                  String target;
                  // if(licensePermissions['passive_liveness'] == 1 && licensePermissions['face_compare'] == 1){
                  //   target = "3";
                  // }else if (licensePermissions['passive_liveness'] == 0 && licensePermissions['face_compare'] == 1){
                  //   target = "2";
                  // }else if(licensePermissions['passive_liveness'] == 1 && licensePermissions['face_compare'] == 0){
                  //   target = "1";
                  // }else{
                  //   target = "-1";
                  // }

                  target = "3";

                  final bytes = File(finalImagePath).readAsBytesSync();
                  String img64 = base64Encode(bytes);
                  // await save(img64);

                  var res = await sendDataToServer(
                      api_url, jwt_token, bvn, File(finalImagePath),target);
                  
                  // await save(res.toString());
                  
                  if (res['status'] == 1) {
                    Navigator.pushNamed(context,"/exit_screen",
                      arguments: ExitScreenArguments(true, "Face Authentication Success"));
                  } else {
                    Navigator.pushNamed(context,"/exit_screen",
                      arguments: ExitScreenArguments(false, "Face Authentication Failed"));
                  }
                }

              }else{
                print("Out of Oval");
                  Fluttertoast.showToast(
                        msg: "Please Enter the Oval",
                        backgroundColor: Colors.grey,
                      );
              }
              }              
            },
          )),

          // floatingActionButton: new FloatingActionButton(
          //   child: new Icon(Icons.camera),
            
          //   onPressed: () async {

              

          //     if( !clickedOnce){

          //     if(inPlace){
                
          //       setState(() {
          //         _loading = true;
          //       });
          //       clickedOnce = true;


          //       var licensePermissions = json.decode(permissions);
          //       bool shouldHitVerifyFaceEndpoint = (licensePermissions['passive_liveness'] == 1 || licensePermissions['face_compare'] == 1) ? true:false;

          //       if(shouldHitVerifyFaceEndpoint){

          //         _greenBoundingBox = true;
          //         FlutterBeep.beep();
          //         var path = '';
          //         String finalImagePath;
          //         List<int> imageBytes;
          //         if (Platform.isAndroid) {
          //           path = (await getExternalStorageDirectory()).path;
          //           var path2 = path + '/' + '${DateTime.now()}.jpg';
          //           await _camera.stopImageStream();
          //           await _camera.takePicture(path2);
          //           finalImagePath = path2;

          //         } else {
          //           path = (await getApplicationDocumentsDirectory()).path;
          //           var path2 = path + '/' + '${DateTime.now()}.jpg';
          //           // await _camera.stopImageStream();
          //           await _camera.takePicture(path2);
          //           var imageResized =
          //               await FlutterNativeImage.compressImage(path2,
          //                   quality: 100,
          //                   targetWidth: 100,
          //                   targetHeight: 100);
          //           await _camera.stopImageStream();
          //           await _camera.dispose();
          //           imageBytes = imageResized.readAsBytesSync();
          //           finalImagePath = path2;
          //         }

          //         // var photoBase64 = base64Encode(imageBytes);
  

          //         String jwt_token = jwtToken;
          //         String api_url = endpoint_base_url + verify_face_endpoint;

          //         String target;
          //         // if(licensePermissions['passive_liveness'] == 1 && licensePermissions['face_compare'] == 1){
          //         //   target = "3";
          //         // }else if (licensePermissions['passive_liveness'] == 0 && licensePermissions['face_compare'] == 1){
          //         //   target = "2";
          //         // }else if(licensePermissions['passive_liveness'] == 1 && licensePermissions['face_compare'] == 0){
          //         //   target = "1";
          //         // }else{
          //         //   target = "-1";
          //         // }

          //         target = "2";

          //         var res = await sendDataToServer(
          //             api_url, jwt_token, bvn, File(finalImagePath),target);
                  
          //         if (res['status'] == 1) {
          //           Navigator.pushNamed(context,"/exit_screen",
          //             arguments: ExitScreenArguments(true, "Face Authentication Success"));
          //         } else {
          //           Navigator.pushNamed(context,"/exit_screen",
          //             arguments: ExitScreenArguments(false, "Face Authentication Failed"));
          //         }
          //       }

          //     }else{
          //       print("Out of Oval");
          //         Fluttertoast.showToast(
          //               msg: "Please Enter the Oval",
          //               backgroundColor: Colors.grey,
          //             );
          //     }




          //     }              
          //   },
          // ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        )
      );
  }
}

class MyClip extends CustomClipper<Rect> {

  Rect getClip(Size size) {

    var pixelRatio = window.devicePixelRatio;

    //Size in physical pixels
    var physicalScreenSize = window.physicalSize;
    var physicalWidth = physicalScreenSize.width;
    var physicalHeight = physicalScreenSize.height;

    //Size in logical pixels
    var logicalScreenSize = window.physicalSize / pixelRatio;
    var logicalWidth = logicalScreenSize.width;
    var logicalHeight = logicalScreenSize.height;

    //Padding in physical pixels
    var padding = window.padding;

    //Safe area paddings in logical pixels
    var paddingLeft = window.padding.left / window.devicePixelRatio;
    var paddingRight = window.padding.right / window.devicePixelRatio;
    var paddingTop = window.padding.top / window.devicePixelRatio;
    var paddingBottom = window.padding.bottom / window.devicePixelRatio;

    //Safe area in logical pixels
    var safeWidth = logicalWidth - paddingLeft - paddingRight;
    var safeHeight = logicalHeight - paddingTop - paddingBottom;
    Offset center = new Offset(safeWidth/2, safeHeight/2);

    var circleWidth = safeWidth - (0.175 * safeWidth) ;
    var circleHeight = safeHeight - (0.325 * safeHeight) ;


    // return Rect.fromLTWH(25, 140, 350, 550);
    return Rect.fromCenter(center: center, width: circleWidth ,height: circleHeight);
  }

  bool shouldReclip(oldClipper) {
    return false;
  }
}