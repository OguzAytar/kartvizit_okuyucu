// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Özel Kırpma Aracı',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   File? _croppedImage;
//   Offset? _startPosition;
//   Offset? _endPosition;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Özel Kırpma Aracı'),
//       ),
//       body: Center(
//         child: GestureDetector(
//           onPanStart: (details) {
//             setState(() {
//               _startPosition = details.localPosition;
//               _endPosition = _startPosition;
//             });
//           },
//           onPanUpdate: (details) {
//             setState(() {
//               _endPosition = details.localPosition;
//             });
//           },
//           onPanEnd: (details) {
//             setState(() {
//               _startPosition = null;
//               _endPosition = null;
//             });
//           },
//           child: Stack(
//             children: [
//               _croppedImage != null ? Image.file(_croppedImage!) : SizedBox(),
//               CustomPaint(
//                 painter: SelectionPainter(startPosition: _startPosition, endPosition: _endPosition),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _pickImage,
//         tooltip: 'Fotoğraf Seç',
//         child: Icon(Icons.photo_library),
//       ),
//     );
//   }

//   Future<void> _pickImage() async {
//     final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

//     if (pickedImage != null) {
//       final croppedImage = await ImageCropper().cropImage(sourcePath: pickedImage.path, aspectRatioPresets: [
//         CropAspectRatioPreset.square,
//         CropAspectRatioPreset.ratio3x2,
//         CropAspectRatioPreset.original,
//         CropAspectRatioPreset.ratio4x3,
//         CropAspectRatioPreset.ratio16x9
//       ], uiSettings: [
//         AndroidUiSettings(
//           toolbarTitle: 'Taranacak Alanı Seçiniz',
//           toolbarColor: Colors.deepOrange,
//           toolbarWidgetColor: Colors.white,
//           initAspectRatio: CropAspectRatioPreset.original,
//           lockAspectRatio: false,
//         ),
//         IOSUiSettings(title: 'Taranacak Alanı Seçiniz'),
//       ]);

//       if (croppedImage != null) {
//         setState(() {
//           _croppedImage = File(croppedImage.path);
//         });
//       }
//     }
//   }
// }

// class SelectionPainter extends CustomPainter {
//   final Offset? startPosition;
//   final Offset? endPosition;

//   SelectionPainter({this.startPosition, this.endPosition});

//   @override
//   void paint(Canvas canvas, Size size) {
//     if (startPosition != null && endPosition != null) {
//       final paint = Paint()
//         ..color = Colors.blue.withOpacity(0.3)
//         ..style = PaintingStyle.fill;

//       final rect = Rect.fromPoints(startPosition!, endPosition!);
//       canvas.drawRect(rect, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
