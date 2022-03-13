// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter_spinkit/flutter_spinkit.dart';


// import 'package:flutter_native_image/flutter_native_image.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';


// import 'package:camera/camera.dart';

// import 'dart:io';
// import 'package:http_parser/http_parser.dart';

// import 'dart:ui' as ui;

// import 'dart:math';
// // import '../../../globals.dart' as globals;
// import "../utlis/constants.dart";

// class CameraScreen extends StatefulWidget {
//   final String entry_type;
//   final String bvn;
//   final String phno;
//   const CameraScreen(
//       {Key key,
//       @required this.entry_type,
//       @required this.bvn,
//       @required this.phno})
//       : super(key: key);
//   @override
//   _CameraScreenState createState() => _CameraScreenState(bvn, phno);
// }

// class _CameraScreenState extends State<CameraScreen> {
//   String bvn;
//   String phno;

//   _CameraScreenState(this.bvn, this.phno);
//  bool loading = false;
//  bool loading1 = false;


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
//       "x-access-token": token,
//       "authorization":basicAuth
//       // "Accept": "*/*",
//       // "Accept-encoding": "gzip,deflate,br",
//       // "Content-Type": "multipart/form-data;boundary:'$boun'"
//     };
    
//     request.files.add(
//       new http.MultipartFile(
//         'Image',
//         image.readAsBytes().asStream(),
//         image.lengthSync(),
//         filename: bvn + "_live.jpg",
//         contentType: MediaType('image', 'jpeg'),
//       ),
//     );

//     request.fields['BVN'] = bvn;
//     //String licenseKey="";
//    // String license="gAAAAABhpIiqJr-EkxaeW9yMn-E2fySgytuLmchGkyqXeSK5aKLKJwRsyfTiUBd8PQF3M6fPmHTKoI0dOkBO5k3xEKF7CzskcefBs5U6sYJchUKFKdFK2LwYlvsDCmll-KDkcU1zJ184rlUKA6T7WdvrIYPFUArfRpckkpO4Ay6R8rYT25ZNqBZv1kiq_Hjt94yo9XxictxlrU5Z2tN3Mo22Ng1NTKOS8351-0JfoPhpDosNHqov27kcBxcCGlYcz25eiHLBfafbyKAGmssFImY64tVot_DqrA==";
//     request.fields['licenseKey']=licenseKey;
//     request.fields['targetFunction']="3";
//     request.headers.addAll(headers);
//     print("request: " + request.toString());
//     // request.send().then((value) => print(value.statusCode));

// ///////////////////////////////end////////////////////
//     /*http.Response response = await http.Response.fromStream(await request.send());
//     print("Result: ${response.statusCode}");
//     return response.body;*/
//     final response = await request.send();
    
    
//     print(response.statusCode);
//     print(response.reasonPhrase);

//     if (response.statusCode != 200) {
//       return {"status": 0};
//     }
//     final res = await http.Response.fromStream(response);


//     return (json.decode(res.body));
//   }

//   @override
//   Widget build(BuildContext context) {
//     //ok=true;
//     return loading == true

//         ? Loading()
//         : Scaffold(

//       backgroundColor: Colors.white,
//       body: Padding(
//           padding: const EdgeInsets.only(bottom: 80.0),
//           child: Center(
//               child: Text(
//                 "Take a picture for Face Recognition",
//                 style: TextStyle(fontSize: 20),
//               ))),
//       floatingActionButton: Padding(
//           padding: const EdgeInsets.only(bottom: 50.0),
//           child: FloatingActionButton(

//             onPressed: () async {

//               final picker = ImagePicker(); // HERE !!!!!!!!

//              // ok=false;
//               final pickedFile =await picker.getImage(source: ImageSource.camera);
//               setState(() {
//                 loading= true;

//                 //                       // Here you can write your code for open new view
//               });
//               // Future<PickedFile> pickedFile({ImageSource.camera, CameraDevice.rear});
//               //final pickedFile= await new ImagePicker().getImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
//               //  Future getImage() async {
//               // final pickedFile = await picker.getImage(source: ImageSource.camera,preferredCameraDevice: CameraDevice.front );  }

//               // ignore: deprecated_member_use

//               // final pickedFile = await ImagePicker.pickImage(source: ImageSource.camera ,preferredCameraDevice: CameraDevice.front);

//               // if(_isPressed==true){
//               //   _myCallback();
//               // }
//               //                   Timer(Duration(seconds:-700), () {
//               // // 5 seconds over, navigate to Page2.


//               //                   // Here you can write your code

//               // setState(() {
//               //   loading = true;

//               //   // Here you can write your code for open new view
//               // });
//               //                   });
            

//               var path = pickedFile.path;
  
//               File image = new File(
//                   path); // Or any other way to get a File instance.
//               final bytes1 = File(path).readAsBytesSync().lengthInBytes;
//               final kb = bytes1 / 1024;
//               final mb = kb / 1024;
//               print(mb);
//               var x = await decodeImageFromList(image.readAsBytesSync());
//               print("original");
//               print('${x.width} x ${x.height}');
//               //-------->function
//               if (x.width > x.height) {
//                 Navigator.pushNamed(context, '/image_dimensions');
//               } else if (x.width < 720 || x.height < 1080) {
//                 Navigator.pushNamed(context, '/image_dimensions');
//               } else {
               

//                 print(path);

//                 ///////////////////////////////end////////////////////cd
//                 // setState(() {
//                 //   loading = true;
//                 // });

//                 final ratio = (x.height) / (x.width);
//                 final w = ((1080) / ratio).round();
//                 //  List<int> imageBytes = File(path).readAsBytesSync();
//                 File imageResized =
//                 await FlutterNativeImage.compressImage(
//                   path,
//                   quality: 100,
//                   targetHeight: 1080,
//                   targetWidth: w,
//                 );

//                 var x1 = await decodeImageFromList(
//                     imageResized.readAsBytesSync());
//                 print("after");
//                 print('${x1.width}x${x1.height}');

//                 if(x1.width>x1.height)
//                 {
//                   imageResized = await FlutterNativeImage.compressImage(
//                     path,
//                     quality: 100,
//                     targetWidth:1080,
//                     targetHeight:w,
//                   );
//                 }

//                 final bytes2 =
//                     imageResized.readAsBytesSync().lengthInBytes;
//                 final kb1 = bytes2 / 1024;
//                 final mb1 = kb1 / 1024;
//                 /////////////////////////////////////////////////////
//                 //iif size greater --->page
//                 print(mb1);

//                 //var lk=null;
//                 //if(lk=="gAAAAABhpIiqJr-EkxaeW9yMn-E2fySgytuLmchGkyqXeSK5aKLKJwRsyfTiUBd8PQF3M6fPmHTKoI0dOkBO5k3xEKF7CzskcefBs5U6sYJchUKFKdFK2LwYlvsDCmll-KDkcU1zJ184rlUKA6T7WdvrIYPFUArfRpckkpO4Ay6R8rYT25ZNqBZv1kiq_Hjt94yo9XxictxlrU5Z2tN3Mo22Ng1NTKOS8351-0JfoPhpDosNHqov27kcBxcCGlYcz25eiHLBfafbyKAGmssFImY64tVot_DqrA==")
//                 String api_url = endpoint_base_url + verify_face_endpoint;
//                 //String licenceKey="gAAAAABhpIiqJr-EkxaeW9yMn-E2fySgytuLmchGkyqXeSK5aKLKJwRsyfTiUBd8PQF3M6fPmHTKoI0dOkBO5k3xEKF7CzskcefBs5U6sYJchUKFKdFK2LwYlvsDCmll-KDkcU1zJ184rlUKA6T7WdvrIYPFUArfRpckkpO4Ay6R8rYT25ZNqBZv1kiq_Hjt94yo9XxictxlrU5Z2tN3Mo22Ng1NTKOS8351-0JfoPhpDosNHqov27kcBxcCGlYcz25eiHLBfafbyKAGmssFImY64tVot_DqrA==";
//                 // String api_url = 'https://facenigeria.peklasolutions.com/pekla/api/faceCompare';
//                 // String api_url ='https://facenigeria.peklasolutions.com/pekla/api/faceRekognition';
//                 // String api_url ='http://ec2-13-245-35-53.af-south-1.compute.amazonaws.com/pekla/api/faceRekognition';

//                 // http://ec2-13-245-35-53.af-south-1.compute.amazonaws.com/pekla/api/faceRekognition

//                 // final res = await http.post(
//                 //   api_url,
//                 //   headers: <String, String>{
//                 //     'Content-Type': 'application/json; charset=UTF-8',
//                 //   },
//                 //   body: jsonEncode(<String, String>{
//                 //     'BVN': bvn.toString(),
//                 //     'Image': photoBase64
//                 //   }),
//                 // );
//                 try {
                
//                   final res = await sendDataToServer(
//                       api_url, phno, bvn, imageResized);
                
//                   print("%%%%%%%%");
//                   print(res);

//                   if (res['status'] == 0) {
//                     print("Face verify fail");
//                     Navigator.pushNamed(context, '/sign_in_failure');
//                   } else if (res['status'] == 1) {
//                     Navigator.pushNamed(
//                       context,
//                       LoginSuccessScreen.routeName,
//                     );
//                   } else if (res['status'] == 2) {
//                     print("Liveness Detection Failed");
//                     Navigator.pushNamed(context, '/liveness_failure');
//                   } else {
//                     print("Face verify fail");
//                     Navigator.pushNamed(context, '/sign_in_failure');
//                   }
//                 } catch (e) {
//                   print("Exception ,try again");
//                   Navigator.pushNamed(context, '/liveness_failure');
//                 }
//               }
//             },
//             child: new Icon(Icons.camera_alt_sharp),
//             backgroundColor: Color(0xFF172247),
//           )),
//       floatingActionButtonLocation:
//       FloatingActionButtonLocation.centerDocked,
//     );
// }
  
// }
