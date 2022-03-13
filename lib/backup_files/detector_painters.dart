// import 'dart:ui';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'dart:convert';


// class FaceDetectorPainter extends CustomPainter {
//   FaceDetectorPainter(this.imageSize, this.results, this.greenBoundingBox);
//   final Size imageSize;
//   double scaleX, scaleY;
//   dynamic results;
//   bool greenBoundingBox;
//   Face face;
  
//   @override
//   void paint(Canvas canvas, Size size) {
//     Color clr = greenBoundingBox == true ? Colors.greenAccent : Colors.blueAccent;
//     final Paint paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 3.0
//       ..color = clr;
//     for (String label in results.keys) {
//       for (Face face in results[label]) {
//         // face = results[label];
//         scaleX = size.width / imageSize.width;
//         scaleY = size.height / imageSize.height;
//         canvas.drawRRect(
//             _scaleRect(
//                 rect: face.boundingBox,
//                 imageSize: imageSize,
//                 widgetSize: size,
//                 scaleX: scaleX,
//                 scaleY: scaleY),
//             paint);

//         // var circlePaint = Paint()
//         // ..style=PaintingStyle.stroke
//         // ..strokeWidth=5.0
//         // ..color=Colors.black;
        
//         print(size);
//         // canvas.drawOval(const Rect.fromLTRB(300, 200, 411, 866), circlePaint);


//         var tmp = label.split("|-|");
//         print(tmp);
//         String waitTime = tmp[1];

//         tmp[0] = tmp[0].replaceAll("[", "");
//         tmp[0] = tmp[0].replaceAll("]", "");
//         tmp[0] = tmp[0].replaceAll("\"", "");

//         var tmp2 = tmp[0];
//         List<String> actionsToPerform = tmp2.split(",");
//         actionsToPerform = [];
//         print(actionsToPerform);
//         if(actionsToPerform.toString() == "[]"){
//           actionsToPerform = [];
//         }

//         String res = "Tasks to Perform:";
//         List<TextSpan> lts  = [];
//         lts.add(new TextSpan(style: new TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),text:"Tasks to Perform:"));

//         if(actionsToPerform.length==0){
//           res = "\nBlink your eyes to take a picture";
//           lts.add(new TextSpan(style: new TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),text:res));


//         }else{
          
//           for(int ii =0;ii<actionsToPerform.length;ii++){
//             String prefix =  " for " + waitTime + " seconds";
//             if (actionsToPerform[ii] == "blink"){
//               print("jkjhkjhkhk"+waitTime);
//               if (int.parse(waitTime) == 1){
//                 prefix = " "+waitTime + " time";
//               }else{
//                 prefix = " "+waitTime + " times";
//               }
//             }
//             String stmt;
//             if(ii==0){
//               stmt =  '\n'+ (ii+1).toString() + ". "  + actionsToPerform[ii] + prefix;
//               lts.add( new TextSpan(text: stmt, style: new TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold, 
//             shadows:<Shadow>[
//                   Shadow(
//                     offset: Offset(2.0, 2.0),
//                     blurRadius: 7.0,
//                     color: Color.fromARGB(255, 0, 0, 0),
//                   ),

//                 ],),),);
//             }else{
//               stmt =  '\n'+ (ii+1).toString() + ". "  + actionsToPerform[ii];
//               lts.add(new TextSpan(style: new TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),text:stmt));
//             }
//             res = res + stmt ;
//           }
//         }


//         // TextSpan span = new TextSpan(
//         //     style: new TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold, 
//         //     shadows:<Shadow>[
//         //           Shadow(
//         //             offset: Offset(2.0, 2.0),
//         //             blurRadius: 7.0,
//         //             color: Color.fromARGB(255, 0, 0, 0),
//         //           ),

//         //         ],),
//         //     text: "");


//         TextSpan span = new TextSpan(
//           children: lts);

//         TextPainter textPainter = new TextPainter(
//             text: span,
//             textAlign: TextAlign.left,
//             textDirection: TextDirection.ltr);
//         textPainter.layout();
//         textPainter.paint(
//             canvas,
//             // new Offset(
//             //     size.width - (60 + face.boundingBox.left.toDouble()) * scaleX,
//             //     (face.boundingBox.top.toDouble() - 10) * scaleY));
//              new Offset(5.0, 30.0));
          
 
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(FaceDetectorPainter oldDelegate) {
//     return oldDelegate.imageSize != imageSize || oldDelegate.results != results;
//   }
// }

// RRect _scaleRect(
//     {@required Rect rect,
//     @required Size imageSize,
//     @required Size widgetSize,
//     double scaleX,
//     double scaleY}) {
//   return RRect.fromLTRBR(
//       (widgetSize.width - rect.left.toDouble() * scaleX),
//       rect.top.toDouble() * scaleY,
//       widgetSize.width - rect.right.toDouble() * scaleX,
//       rect.bottom.toDouble() * scaleY,
//       Radius.circular(10));
// }

// Rect _scaleRect2(
//     {@required Rect rect,
//     @required Size imageSize,
//     @required Size widgetSize,
//     double scaleX,
//     double scaleY}) {
//   return Rect.fromLTRB(
//       (widgetSize.width - rect.left.toDouble() * scaleX),
//       rect.top.toDouble() * scaleY,
//       widgetSize.width - rect.right.toDouble() * scaleX,
//       rect.bottom.toDouble() * scaleY);
// }