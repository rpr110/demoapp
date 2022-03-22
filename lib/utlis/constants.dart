import 'package:flutter/material.dart';
import 'size_config.dart';

// import 'package:device_info/device_info.dart';
import 'dart:io';

const kPrimaryColor = Color(0xFF172247);
const kPrimaryLightColor = Color(0xFF27f2de);

const kSecondaryColor = Color(0xFF27f2de);
const kTextColor = Color(0xFF757575);
bool ok = false;

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9-]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kUUIDNullError = "Please Enter your UUID";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kInvalidUUIDError = "Please Enter Valid UUID";
const String kPassNullError = "Please Enter your password";
const String kPhoneNullError = "Please Enter your Phone Number";
const String kShortPassError = "Password is too short";
const String kShortPhoneError = "Phone Number must be 10 Digits";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

//const String endpoint_base_url = "https://196.6.103.71";
// const String endpoint_base_url = "https://n-face.nibss-plc.com.ng";

//const String endpoint_base_url = "https://facenigeria.peklasolutions.com";
//const String endpoint_base_url = "peklanigeria.southafricanorth.cloudapp.azure.com";
// const String endpoint_base_url ="http://ec2-13-245-35-53.af-south-1.compute.amazonaws.com";
    
//const String endpoint_base_url = "http://ec2-13-245-35-53.af-south-1.compute.amazonaws.com";
//const String endpoint_base_url = "http://pekla-alb-nigeria-1073326178.af-south-1.elb.amazonaws.com";
// const String endpoint_base_url = "http://ec2-13-244-90-123.af-south-1.compute.amazonaws.com";
// const String endpoint_base_url = "https://196.6.103.138";
const String endpoint_base_url ="https://n-face.nibss-plc.com.ng";

const String register_endpoint = "/pekla/api/registerUser";
// const String send_otp_endpoint = "/pekla/api/sendOtp";
// const String verify_otp_endpoint = "/pekla/api/verifyOtp";


// const String get_jwt_endpoint = "/pekla/api/getJwtToken";
const String get_jwt_endpoint = "/pekla/api/nibbs/JwtToken";

const String send_otp_endpoint = "/pekla/api/sendEmailOtp";
const String verify_otp_endpoint = "/pekla/api/emailOtpVerify";
// const String verify_face_endpoint = "/pekla/api/faceRekognition";
const String verify_face_endpoint = "/pekla/api/nibbs/faceRekognition";

const String log_active_liveness_url = "/pekla/api/logActiveLivenessFailure";

// const String  get_jwt_endpoint_password = "P7=_Q48qEZq4mdC4d@V|d+C1YEVq|0eFuCWM|^9-R4I-D920&-T780Zz^RTB-k5zJDd2&q?JW#&-30EDQ1DgvjuDJdxDzSaIDgrW7vzgMvVySK*U#+O%x+zE6A8X+G*s!C%VRXTN%inoYAry5g1w0b8ok_DVv0YWKSDVIrQ8&ozCqGYc1LUNDy^-Q|W5oW1Ag7h@X6wLedwBA|KW&%2c@R67!ngjJQ7|L3Gzi-|vZD+TDibE!B^RSJghk+)d3Ei0";
const String get_jwt_endpoint_password = "P7=_Q48qEZq4mdC4d@V|d+C1YEVq|0eFuCWM|^9-R4I-D920&-T780Zz^RTB-k5zJDd2&q?JW#&-30EDQ1DgvjuDJdxDzSaIDgrW7vzgMvVySK*U#+O%x+zE6A8X+G*s!C%VRXTN%inoYAry5g1w0b8ok_DVv0YWKSDVIrQ8&ozCqGYc1LUNDy^-Q|W5oW1Ag7h@X6wLedwBA|KW&%2c@R67!ngjJQ7|L3Gzi-|vZD+TDibE!B^RSJghk+)d3Ei0";

const String general_api_password = "E,,<9,'&)9&@R[uk9agDNQ`hQ+Gt6U2+";

const String licenseKey = "cc278cf163bf11ec93660e5b35aa16f2";

const double appVer = 3.0;

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}

// Map<String, dynamic> readAndroidBuildData(AndroidDeviceInfo build) {
//   return <String, dynamic>{
//     'version.securityPatch': build.version.securityPatch,
//     'version.sdkInt': build.version.sdkInt,
//     'version.release': build.version.release,
//     'version.previewSdkInt': build.version.previewSdkInt,
//     'version.incremental': build.version.incremental,
//     'version.codename': build.version.codename,
//     'version.baseOS': build.version.baseOS,
//     'board': build.board,
//     'bootloader': build.bootloader,
//     'brand': build.brand,
//     'device': build.device,
//     'display': build.display,
//     'fingerprint': build.fingerprint,
//     'hardware': build.hardware,
//     'host': build.host,
//     'id': build.id,
//     'manufacturer': build.manufacturer,
//     'model': build.model,
//     'product': build.product,
//     'supported32BitAbis': build.supported32BitAbis,
//     'supported64BitAbis': build.supported64BitAbis,
//     'supportedAbis': build.supportedAbis,
//     'tags': build.tags,
//     'type': build.type,
//     'isPhysicalDevice': build.isPhysicalDevice,
//     'androidId': build.androidId,
//     'systemFeatures': build.systemFeatures,
//     'applicationVersion': appVer,
//   };
// }

// Map<String, dynamic> readIosDeviceInfo(IosDeviceInfo data) {
//   return <String, dynamic>{
//     'name': data.name,
//     'systemName': data.systemName,
//     'systemVersion': data.systemVersion,
//     'model': data.model,
//     'localizedModel': data.localizedModel,
//     'identifierForVendor': data.identifierForVendor,
//     'isPhysicalDevice': data.isPhysicalDevice,
//     'utsname.sysname:': data.utsname.sysname,
//     'utsname.nodename:': data.utsname.nodename,
//     'utsname.release:': data.utsname.release,
//     'utsname.version:': data.utsname.version,
//     'utsname.machine:': data.utsname.machine,
//     'applicationVersion': appVer,
//   };
// }

Future<String> getDeviceData() async {
  // Map<String, dynamic> deviceData = <String, dynamic>{};

  // final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  // if (Platform.isAndroid) {
  //   deviceData = readAndroidBuildData(await deviceInfoPlugin.androidInfo);
  // } else if (Platform.isIOS) {
  //   deviceData = readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
  // }
  var deviceData = {"deviceData":"testing"};
  return deviceData.toString();
}

String getDeviceOs(){
  if(Platform.isAndroid){
    return "ANDROID";
  }else if(Platform.isIOS){
    return "IOS";
  }
  return "";
}

void showToast(BuildContext context, message) {
    Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
}

// String peklaEncode( String b64String){
//   List<String> unsafeStrings = ['!', '"', '#', '\$', '%', '&', "'", '(', ')', '*', '+', ',', '-', '.', '/', ':', ';', '<', '=', '>', '?', '@', '[', '\\', ']', '^', '_', '`', '{', '|', '}', '~', 'm0XBCCf'];
//   var encodedString = b64String;
  
//     unsafeStrings.asMap().forEach((index, value) =>                           
//       encodedString = encodedString.replaceAll(value,"pe$index"+"ge")
//     );
    
//   return encodedString;
  
// }