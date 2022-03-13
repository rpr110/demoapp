import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http_parser/http_parser.dart';


import 'dart:convert';
import 'dart:io';
import 'dart:math' as Math;


import '../../../utlis/constants.dart';
import '../../../components/loading_screen.dart';
import '../../../components/exit_screen.dart';

class UploadPictureScreen extends StatefulWidget {
  static const routeName = "/uploadPicture";

  final String firstname;
  final String bvn;
  final String phno;
  final String email;
  const UploadPictureScreen(
      {Key key,
      @required this.firstname,
      @required this.bvn,
      @required this.phno,
      @required this.email
       })
      : super(key: key);
  @override
  _UploadPictureScreenState createState() =>
      _UploadPictureScreenState(bvn, firstname, phno, email);
}

class _UploadPictureScreenState extends State<UploadPictureScreen> {
  String bvn;
  String firstName;
  String phno;
  String email;
  _UploadPictureScreenState(this.bvn, this.firstName, this.phno, this.email);
  bool loading = false;

  Future<Map> sendrequest(String apiEndpoint, String bvn, String name, String phoneNumber,String email,File image)async{
  
    var request = http.MultipartRequest('POST', Uri.parse('http://ec2-13-245-35-53.af-south-1.compute.amazonaws.com/pekla/api/registerUser'));
    request.fields.addAll({
      'BVN': bvn,
      'Name': name,
      'Phone_Number': phoneNumber,
      'email':email
    });
    Map<String, String> headers = {};
    // "Content-type": "multipart/form-data","Accept":"*/*"
        request.files.add(
          http.MultipartFile(
            'Image',
            image.readAsBytes().asStream(),
            image.lengthSync(),
            filename: "$bvn.jpg",
            contentType: MediaType('image', 'jpeg'),
          ),
        );
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      
      final res = await http.Response.fromStream(response);
      return(json.decode(res.body));
    }
    else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading == true
        ? LoadingScreen("Uploading Your Picture .....")
        : Scaffold(
            appBar: AppBar(
              title: Text("Step 2"),
            ),
            backgroundColor: Colors.indigo[900],
            body: Padding(
                padding: const EdgeInsets.only(bottom: 80.0),
                child: Center(
                    child: Text(
                  "Upload your Picture",
                  style: TextStyle(fontSize: 20),
                ))),
            floatingActionButton: Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: FloatingActionButton(
                  onPressed: () async {
                    final picker = ImagePicker(); // HERE !!!!!!!!
                    final pickedFile =
                        await picker.getImage(source: ImageSource.gallery);
                    var path = pickedFile.path;
                    List<int> bytes;
                    
                    setState(() {
                      loading = true;
                    });

                    String finalImagePath="";
                    if (Platform.isAndroid) {
                      File imagePath = File(path);
                      final tempDir = await getExternalStorageDirectory();
                      int rand = new Math.Random().nextInt(10000);
                      //reading jpg image
                      var pngPath = "${tempDir.path}/img_$rand.jpg";
                      File tmpFile = File (pickedFile.path);
                      final File newImage = await tmpFile.copy("${tempDir.path}/img_$rand.jpg");
                      bytes = await File("${tempDir.path}/img_$rand.jpg").readAsBytes();
                      pngPath="${tempDir.path}/img_$rand.jpg";
                      finalImagePath = pngPath.toString();
                    } else if (Platform.isIOS) {
                      var imageResized = await FlutterNativeImage.compressImage(
                          path,
                          quality: 100,
                          targetWidth: 300,
                          targetHeight: 300);
                      bytes = imageResized.readAsBytesSync();
                      finalImagePath = path.toString();
                    }

                    String apiUrl = endpoint_base_url + register_endpoint;

                    final res= await sendrequest(apiUrl, bvn, firstName, phno, email, File(finalImagePath));
                      String exit_screen_message;
                      bool isSuccessfull;
                      if(res==null){
                        exit_screen_message = "Bad Image Quality";
                        isSuccessfull = false;
                      }
                      else if (res["status"] == 1) {
                        exit_screen_message = "Signed Up Seccessfully";
                        isSuccessfull = true;
                      } else if (res["message"] ==
                          "Profile already exists") {
                            exit_screen_message = "Profile already exists";
                          isSuccessfull = false;

                      } else {
                        exit_screen_message = "Bad Image Quality";
                        isSuccessfull = false;
                      }
                      
                      if(isSuccessfull){
                        Navigator.pushNamed(context,"/exit_screen",
                          arguments: ExitScreenArguments(true, exit_screen_message));
                      }else{
                        Navigator.pushNamed(context,"/exit_screen",
                          arguments: ExitScreenArguments(false, exit_screen_message));
                      }

                  },
                  child: new Icon(Icons.camera_alt_sharp),
                  backgroundColor: Color(0xFF172247),
                )),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          );
  }
}

class UploadPictureScreenArguments {
  final String firstName;
  final String bvn;
  final String phno;
  final String email;

  UploadPictureScreenArguments(this.firstName,this.bvn, this.phno, this.email);
}
