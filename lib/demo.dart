// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Ad Soyisim, Adres ve Telefon Numarası Ayırma',
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
//   final _textController = TextEditingController();
//   String _isim = '', _soyisim = '', _adres = '', _telefonNumarasi = '';

//   void _ayir() async {
//     // Metni algıla

//     // Adlandırılmış varlıkları tanıma
//     final recognizer = EntityExtractor(language: EntityExtractorLanguage.turkish);

//     final entitiess = recognizer.annotateText('', entityTypesFilter: [EntityType.address]);
//     entitiess.then((value) {
//       for (var e in value) {
//         log(e.entities.toString());
//       }
//     });
//     // // İsim, soyisim, adres ve telefon numarasını ayır
//     // for (final entity in entities) {
//     //   if (entity.type == EntityType.PERSON_NAME) {
//     //     final nameParts = entity.text.split(' ');
//     //     _isim = nameParts[0];
//     //     _soyisim = nameParts[1];
//     //   } else if (entity.type == EntityType.ADDRESS) {
//     //     _adres = entity.text;
//     //   } else if (entity.type == EntityType.phone) {
//     //     _telefonNumarasi = entity.text;
//     //   }
//     // }

//     // Sonuçları güncelle
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Ad Soyisim, Adres ve Telefon Numarası Ayırma'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _textController,
//               decoration: InputDecoration(
//                 hintText: 'Metin girin...',
//               ),
//               maxLines: 5,
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: _ayir,
//               child: Text('Ayır'),
//             ),
//             SizedBox(height: 16.0),
//             Text('İsim: $_isim'),
//             Text('Soyisim: $_soyisim'),
//             Text('Adres: $_adres'),
//             Text('Telefon Numarası: $_telefonNumarasi'),
//           ],
//         ),
//       ),
//     );
//   }
// }
