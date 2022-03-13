// import 'dart:convert';
// import 'dart:io';
// import 'dart:math' as Math;

// import 'package:flutter_native_image/flutter_native_image.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:camera/camera.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_beep/flutter_beep.dart';
// import 'package:http_parser/http_parser.dart';
// import 'package:http/http.dart' as http;
// import 'package:quiver/collection.dart';
// import 'package:flutter/services.dart';
// import 'package:second_app/components/loading_screen.dart';

// import 'detector_painters.dart';
// import 'utils.dart';
// import '../../../utlis/constants.dart';
// import '../../../components/exit_screen.dart';


// class Cam3 extends StatefulWidget {
//   final String bvn;
//   final String jwtToken;
//   const Cam3(
//       {Key key,
//       @required this.bvn,
//       @required this.jwtToken})
//       : super(key: key);
//   @override
//   Cam3State createState() => Cam3State(bvn, jwtToken);
// }

// class Cam3State extends State<Cam3> {
//   String bvn;
//   String jwtToken;
//   Cam3State(this.bvn, this.jwtToken);
//   bool _loading;
//   String _isSmiling = "";
//   String _isBlinking = "";
//   String _ryanAppBarText = "No Face Detected";
//   File jsonFile;
//   dynamic _scanResults;
//   CameraController _camera;
//   var interpreter;
//   bool _isDetecting = false;
//   CameraLensDirection _direction = CameraLensDirection.front;
//   dynamic data = {};
//   double threshold = 1.0;
//   Directory tempDir;
//   List e1;
//   bool _faceFound = false;
//   int minTimeForDetection = 120;
//   int waitTime = 2000;
//   Map <String,List<String>> completed ={
//     "smile": [
//       "Please Smile",
//       "Complete this task by smiling infront of your camera after pressing 'Ok'"
//     ],
//     "look_left": [
//       "Turn your head to the Left",
//       "Complete this task by turning your head to the left after pressing 'Ok'"
//     ],
//     "look_right": [
//       "Turn your head to the Right",
//       "Complete this task by turning your head to the right after pressing 'Ok'"
//     ],
//     "look_top left": [
//       "Turn your head up",
//       "Complete this task by turning your head to the right after pressing 'Ok'"
//     ],
//     "look_top right": [
//       "Turn your head up",
//       "Complete this task by turning your head to the right after pressing 'Ok'"
//     ],
//     "blink": [
//       "Blink",
//       "Complete this task by blinking after pressing 'Ok'"
//     ]
//   };
//   Map<String, List<String>> actionMessages = {
//     "smile": [
//       "Please Smile",
//       "Complete this task by smiling infront of your camera after pressing 'Ok'"
//     ],
//     "look_left": [
//       "Turn your head to the Left",
//       "Complete this task by turning your head to the left after pressing 'Ok'"
//     ],
//     "look_right": [
//       "Turn your head to the Right",
//       "Complete this task by turning your head to the right after pressing 'Ok'"
//     ],
//     "look_top left": [
//       "Turn your head up",
//       "Complete this task by turning your head to the right after pressing 'Ok'"
//     ],
//     "look_top right": [
//       "Turn your head up",
//       "Complete this task by turning your head to the right after pressing 'Ok'"
//     ],
//     "blink": [
//       "Blink",
//       "Complete this task by blinking after pressing 'Ok'"
//     ]
//   };
//   bool justChanged = false;
//   bool oneTimeActionInstructionPopup = true;
//   int noOfRandomTask = 2;
//   bool shouldWaitForPrevious = false;
//   bool workaroundDelay = false;
//   int workaroundDelayTime = 9223372036854775807;
//   int timeSinceNew = 0;
//   int nTime;
//   bool shouldStartTimer = true;
//   int blinky = 100;
//   bool _greenBoundingBox = false;
//   int totalBlinks = 0;

//   @override
//   void initState() {
//     super.initState();

//     SystemChrome.setPreferredOrientations(
//         [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
//     _initializeCamera();
//   }

//   void _initializeCamera() async {
//     CameraDescription description = await getCamera(_direction);

//     ImageRotation rotation = rotationIntToImageRotation(
//       description.sensorOrientation,
//     );

//     _camera = CameraController(description, ResolutionPreset.high,
//         enableAudio: false);
//     await _camera.initialize();
//     await Future.delayed(Duration(milliseconds: 500));
//     tempDir = await getApplicationDocumentsDirectory();
//     String _embPath = tempDir.path + '/emb.json';
//     jsonFile = new File(_embPath);
//     if (jsonFile.existsSync()) data = json.decode(jsonFile.readAsStringSync());

//     int startTime = dartTime();
//     Math.Random random = new Math.Random();
//     blinky = dartTime();

//     _camera.startImageStream((CameraImage image) {
//       if (_camera != null) {
//         if (_isDetecting) return;
//         _isDetecting = true;
//         String res;
//         dynamic finalResult = Multimap<String, Face>();
//         detect(image, _getDetectionMethod(), rotation).then(
//           (dynamic result) async {
//             if (parseDartTime(dartTime() - startTime) < minTimeForDetection) {
//               // if (workaroundDelay) {
//               //   if ((dartTime() - workaroundDelayTime) > 2050) {
//               //     oneTimeActionInstructionPopup = true;
//               //     workaroundDelayTime = 9223372036854775807;
//               //     workaroundDelay = false;
//               //   }
//               // }

//               if (result.length == 0) {
//                 _faceFound = false;
//                 _ryanAppBarText = "No Face Visible";
//                 justChanged = false;
//               } else {
//                 _faceFound = true;
//                 _ryanAppBarText = "Blink to Take a Picture";
//               }

//               Face _face;

//               // Check if theres more than one face
//               if (result.length == 1) {
//                 for (_face in result) {
//                   // res = actionMessages[action][0];

//                   var res = "[]|-|2";

//                   finalResult.add(res, _face);
                  
//                     _ryanAppBarText = "Blink to take a picture";
//                     // Take pic (by binking) once actions are performed

//                     if ((dartTime() - blinky) > 1500) {
//                       if (_face.leftEyeOpenProbability < 0.1 &&
//                           _face.rightEyeOpenProbability < 0.1) {
//                         _isBlinking = _isBlinking.toString() + "0";
//                       } else {
//                         _isBlinking = _isBlinking.toString() + "1";
//                       }
//                     }

//                     if (_isBlinking.length > 100) {
//                       setState(() {
//                         _isBlinking = _isBlinking.substring(20);
//                       });
//                     }

//                     if (isBlinkThresholdOscilate(_isBlinking)) {
//                       setState(() {
//                         _loading = true;
//                       });

//                       _greenBoundingBox = true;
//                       FlutterBeep.beep();
//                       var path = '';
//                       String finalImagePath;
//                       List<int> imageBytes;
//                       if (Platform.isAndroid) {
//                         path = (await getExternalStorageDirectory()).path;
//                         var path2 = path + '/' + '${DateTime.now()}.jpg';
//                         await _camera.stopImageStream();
//                         await _camera.takePicture(path2);

//                         // File imagePath = File(path2);
//                         // //get temporary directory
//                         // final tempDir = await getExternalStorageDirectory();
//                         // int rand = new Math.Random().nextInt(10000);
//                         // //reading jpg image
//                         // imglib.Image image =
//                         //     imglib.decodeImage(imagePath.readAsBytesSync());
//                         // //decreasing the size of image- optional
//                         // imglib.Image smallerImage =
//                         //     imglib.copyResize(image, width: 720, height: 1080);
//                         // //get converting and saving in file
//                         // File compressedImage =
//                         //     new File('${tempDir.path}/img_$rand.png')
//                         //       ..writeAsBytesSync(
//                         //           imglib.encodePng(smallerImage, level: 9));

//                         // var pngPath = "${tempDir.path}/img_$rand.png";

//                         // // imageBytes = await File(pngPath).readAsBytes();
//                         // finalImagePath = pngPath;
//                         // // var x = await decodeImageFromList(imageBytes);
//                         finalImagePath = path2;

//                       } else {
//                         path = (await getApplicationDocumentsDirectory()).path;
//                         var path2 = path + '/' + '${DateTime.now()}.jpg';
//                         // await _camera.stopImageStream();
//                         await _camera.takePicture(path2);
//                         var imageResized =
//                             await FlutterNativeImage.compressImage(path2,
//                                 quality: 100,
//                                 targetWidth: 100,
//                                 targetHeight: 100);
//                         await _camera.stopImageStream();
//                         await _camera.dispose();
//                         imageBytes = imageResized.readAsBytesSync();
//                         finalImagePath = path2;
//                       }

//                       // var photoBase64 = base64Encode(imageBytes);
      

//                       String jwt_token = jwtToken;
//                       String api_url = endpoint_base_url + verify_face_endpoint;

//                       var res = await sendDataToServer(
//                           api_url, jwt_token, bvn, File(finalImagePath));
//                       print(res);
//                       if (res['status'] == 1) {

//                         Navigator.pushNamed(context,"/exit_screen",
//                           arguments: ExitScreenArguments(true, "Face Authentication Success"));

//                       } else {
//                         Navigator.pushNamed(context, '/sign_in_failure');
//                       }

//                       setState(() {
//                         _isBlinking = "";
//                         _camera = null;
//                         _ryanAppBarText = "You Blinked!!";
//                       });
//                     }
                  
//                 }
//               }
//               // print(_isSmiling);
//               setState(() {
//                 _scanResults = finalResult;
//                 _greenBoundingBox = _greenBoundingBox;
//               });

//               _isDetecting = false;
//             } else {
//               // else if youve have crossed the limit to keep the camera open
//               await _camera.stopImageStream();
//               await _camera.dispose();
//               setState(() {
//                 _isDetecting = false;
//                 _camera = null;
//               });
//               Navigator.pushNamed(context, '/sign_in_failure');
//             }
//           },
//         ).catchError(
//           (_) {
//             print(_);
//             print("ERROR!!!!!!");

//             _isDetecting = false;
//           },
//         );
//       }
//     });
//   }

//   int dartTime() {
//     return DateTime.now().millisecondsSinceEpoch;
//   }

//   int parseDartTime(int dartTimeInMilliseconds) {
//     return (dartTimeInMilliseconds / 1000).toInt();
//   }

//   List<String> generateRandomActions(int noOfActions) {
//     Math.Random random = new Math.Random();
//     List<String> actions = new List();

//     // List<String> listOfActions = ['look_right','look_left','smile'];
//     List<String> listOfActions = ['blink','smile'];

//     // if(false){
//     //   listOfActions.add('remove_glasses');
//     // }
//     // if (false){
//     //   // listOfActions.add( <another task> )
//     // }

//     for (int i = 0; i < noOfActions; i++) {
//       int rand = random.nextInt(listOfActions.length);
//       actions.add(listOfActions[rand]);
//       listOfActions.remove(listOfActions[rand]);
//     }
//     return actions;
//   }

//   String peklaEncode(String b64String) {
//     List<String> unsafeStrings = [
//       '!',
//       '"',
//       '#',
//       '\$',
//       '%',
//       '&',
//       "'",
//       '(',
//       ')',
//       '*',
//       '+',
//       ',',
//       '-',
//       '.',
//       '/',
//       ':',
//       ';',
//       '<',
//       '=',
//       '>',
//       '?',
//       '@',
//       '[',
//       '\\',
//       ']',
//       '^',
//       '_',
//       '`',
//       '{',
//       '|',
//       '}',
//       '~',
//       'm0XBCCf'
//     ];
//     var encodedString = b64String;

//     unsafeStrings.asMap().forEach((index, value) =>
//         encodedString = encodedString.replaceAll(value, "pe$index" + "ge"));

//     return encodedString;
//   }

//   Future<Map> sendDataToServer(
//       String apiEndpoint, String token, String bvn, File image) async {
//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse(apiEndpoint),
//     );
//     String username = 'pekla';
//     String password = r'P$KL&(#@412';
//     String basicAuth ='Basic ' + base64Encode(utf8.encode('$username:$password'));
//     Map<String, String> headers = {
//       "Content-type": "multipart/form-data",
//       "x-access-token": token,
//       "authorization":basicAuth
//     };
//     request.files.add(
//       http.MultipartFile(
//         'Image',
//         image.readAsBytes().asStream(),
//         image.lengthSync(),
//         filename: bvn + "_live.jpg",
//         contentType: MediaType('image', 'jpeg'),
//       ),
//     );
//     var deviceData = await getDeviceData();

//     request.fields['BVN'] = bvn;
//     request.fields['deviceData'] = deviceData;
//     request.fields['licenseKey']=licenseKey;
//     request.fields['targetFunction']="3";
//     request.headers.addAll(headers);
//     print("request: " + request.toString());
//     // request.send().then((value) => print(value.statusCode));

//     final response = await request.send();

//     if (response.statusCode != 200) {
//       return {"status": 0};
//     }
//     final res = await http.Response.fromStream(response);
//     return (json.decode(res.body));
//   }

//   bool isSmileThresholdOscilate(String str) {
//     RegExp exp = new RegExp(r"01");
//     Iterable<Match> matches = exp.allMatches(str);
//     if (matches.length > 0) {
//       return (true);
//     }
//     return (false);
//   }

//   bool isBlinkThresholdOscilate(String str) {
//     RegExp exp = new RegExp(r"10+1");

//     Iterable<Match> matches = exp.allMatches(str);
//     if (matches.length > 0) {
//       return (true);
//     }
//     return (false);
//   }

//   HandleDetection _getDetectionMethod() {
//     final faceDetector = FirebaseVision.instance.faceDetector(
//       FaceDetectorOptions(
//         enableClassification: true,
//         enableLandmarks: true,
//         enableTracking: true,
//         minFaceSize: 1.0,
//         mode: FaceDetectorMode.accurate,
//       ),
//     );
//     return faceDetector.processImage;
//   }

//   Widget _buildResults() {
//     const Text noResultsText = const Text('');
//     if (_scanResults == null ||
//         _camera == null ||
//         !_camera.value.isInitialized) {
//       return noResultsText;
//     }
//     CustomPainter painter;

//     final Size imageSize = Size(
//       _camera.value.previewSize.height,
//       _camera.value.previewSize.width,
//     );
//     painter = FaceDetectorPainter(imageSize, _scanResults, _greenBoundingBox);
//     return CustomPaint(
//       painter: painter,
//     );
//   }

//   Widget _buildImage() {
//     if (_camera == null || !_camera.value.isInitialized) {
//       return Center(
//         child: CircularProgressIndicator(),
//       );
//     }

//     return Container(
//       constraints: const BoxConstraints.expand(),
//       child: _camera == null
//           ? const Center(child: null)
//           : Stack(
//               fit: StackFit.expand,
//               children: <Widget>[
//                 CameraPreview(_camera),
//                 _buildResults(),
//               ],
//             ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new WillPopScope(
//         onWillPop: () async => false,
//         child: Scaffold(
//           // appBar: _loading == true
//           //     ? null
//           //     : AppBar(
//           //         title: Text("$_ryanAppBarText",textAlign: TextAlign.center,style: new TextStyle(fontWeight: FontWeight.bold)),
//           //       ),
//           body: _loading == true ? LoadingScreen("Verifying ....") : _buildImage(),
//         ));
//   }
// }


// class FacialAuthenticationScreenArguments {
//   final String bvn;
//   final String jwtToken;

//   FacialAuthenticationScreenArguments(this.bvn, this.jwtToken);
// }
