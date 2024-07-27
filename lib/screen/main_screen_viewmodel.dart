// ignore_for_file: avoid_print, unused_import

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kartvizit_okuyucu/model/kartvizit_moder.dart';

class MainScreenViewModel extends ChangeNotifier {
  Kartvizit kartvizit = Kartvizit();
  File? frontFace;
  File? backFace;
  bool photoSelected = false;
  bool twoSurface = false;
  String frontExtractedText = '';
  String backExtractedText = '';

  //
  bool isimFound = false;
  bool adresFound = false;
  bool firmaFound = false;
  //

  String? name;
  String? surName;
  String? fulName;
  String? companyName;
  List<String> telNo = [];
  String? adres;
  String? mail;
  String? webAdress;
  final List<String> firmaBelirtec = ['TİC', 'ANONİM', 'A.Ş.', 'LTD', 'ŞTİ', 'ŞİRKETİ', 'ÜNİVERSİTESİ', 'UNİVERSİTY'];
  RegExp firmaWebSiteRegex = RegExp(r'www\.(.*?)\.com');

  /// Galeriden Fotoğraf Çekmek için
  Future pickImageGallery() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      // Crop the picked image

      File? croppedImage = await _cropImage(File(pickedImage.path));
      if (croppedImage != null && frontFace == null) {
        frontFace = croppedImage;

        photoSelected = true;
      } else if (photoSelected && frontFace != null) {
        backFace = croppedImage;
        photoSelected = true;
        twoSurface = true;
      }
    }

    notifyListeners();
  }

  /// Camera ile fotoğraf çekmek için
  Future pickImageCamera() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage == null) return;

    // Crop the picked image
    File? croppedImage = await _cropImage(File(pickedImage.path));
    if (croppedImage != null && frontFace == null) {
      frontFace = croppedImage;

      photoSelected = true;
    } else if (photoSelected && frontFace != null) {
      backFace = croppedImage;
      photoSelected = true;
      twoSurface = true;
    }

    notifyListeners();
  }

  /// Resim Kırmak İçin
  Future<File?> _cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Taranacak Alanı Seçiniz',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Taranacak Alanı Seçiniz'),
      ],
    );

    if (croppedFile != null) {
      return File(croppedFile.path);
    } else {
      return null;
    }
  }

  Future<void> processCard() async {
    name = null;
    surName = null;
    fulName = null;
    companyName = null;
    adres = null;
    webAdress = null;
    mail = null;
    isimFound = false;
    firmaFound = false;
    adresFound = false;
    telNo = [];
    telNo.clear();
    if (twoSurface) {
      /// front ise 1 rear ise 2 gönder
      await recorganizeText(frontFace!.path, 1);
      await recorganizeText(backFace!.path, 2);
    } else {
      await recorganizeText(frontFace!.path, 1);
    }
    kartvizit = Kartvizit(
      name: name,
      surName: surName,
      fulName: fulName,
      companyName: companyName,
      telNo: telNo,
      adres: adres,
      mail: mail,
      webAdress: webAdress,
    );
  }

  /// text Extract
  Future<void> recorganizeText(String path, int index) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText = await textRecognizer.processImage(InputImage.fromFilePath(path));
    if (index == 1) {
      frontExtractedText = recognizedText.text;
      await findContactInfo(frontExtractedText);
    } else if (index == 2) {
      backExtractedText = recognizedText.text;
      await findContactInfo(backExtractedText);
    }
    var isimler = await jsonDataCheck('assets/json/isimler.json');
    var iller = await jsonDataCheck('assets/json/iller.json');

    for (var blockIndex = 0; blockIndex < recognizedText.blocks.length; blockIndex++) {
      var block = recognizedText.blocks[blockIndex];
      for (var lineIndex = 0; lineIndex < block.lines.length; lineIndex++) {
        var line = block.lines[lineIndex];
        var kelimeler = line.text.split(RegExp(r'[ .]+'));

        if (kelimeler.length <= 15) {
          for (var kelime in kelimeler) {
            if (!isimFound) {
              for (var element in isimler) {
                if (element['name'].toString().toLowerCase() == kelime.toLowerCase()) {
                  fulName = line.text;

                  isimFound = true;

                  break;
                }
              }
            }
          }
        }

        /// en basit şekilde firma ismi ayırt etmek için kullanılan fonksiyon
        ///
        /// Mail adresi ile karşılaştırılacak ve mail adresinde @ den sonraki kısım içeriyorsa alacak
        ///
        /// web sitesi ile karşılaştırılacak ve www. dan sonra .com dan öncesini alacak.

        if (!firmaFound) {
          if (webAdress != null) {
            log('web adres: ${webAdress.toString()}');
            String firmaAD = webAdress!.replaceAll(RegExp(r'(www\.|\.com\.tr)'), '');
            firmaAD = firmaAD.replaceAll('.com', ''); // ".com" kısmını kaldır
            firmaAD = firmaAD.replaceAll('.edu', '');
            firmaAD = firmaAD.replaceAll('.tr', '');
            companyName = firmaAD.trim();
            log(companyName!.toUpperCase().toString());
            firmaFound = true;
          }

          for (var kelime in kelimeler) {
            if (firmaBelirtec.contains(kelime.toUpperCase())) {
              companyName = block.text;
              firmaFound = true;
              break;
            }
          }
        }
      }

      if (adres == null) {
        for (var il in iller) {
          if (block.text.toLowerCase().contains(il['il_adi'].toString().toLowerCase())) {
            adres = block.text;
            adresFound = true;
          }
        }
        if (adresFound) {
          break;
        }
      }
    }
    notifyListeners();
  }

  List<String> getKelimeler(RecognizedText recognizedText) {
    List<String> kelimeler = [];
    for (var blockIndex = 0; blockIndex < recognizedText.blocks.length; blockIndex++) {
      var block = recognizedText.blocks[blockIndex];

      for (var lineIndex = 0; lineIndex < block.lines.length; lineIndex++) {
        var line = block.lines[lineIndex];
        kelimeler.addAll(line.text.split(RegExp(r'[ .]+')));
      }
    }
    return kelimeler;
  }

  Future<void> findContactInfo(String text) async {
    RegExp urlRegex = RegExp(r'\b((?:https?|ftp):\/\/)?(?:www\.)?[\w/\-?=%.]+\.[\w/\-?=%.]+', caseSensitive: false);
    // RegExp nameSurnameRegex = RegExp(r'\b(?<!\w[.])([A-ZÇĞİÖŞÜ][a-zçğıöşü]{1,})\s([A-ZÇĞİÖŞÜ]{2,})\b');
    // RegExp nameREGEX = RegExp(r'\b(?<!\w[.])([a-zçğıöşü]{3,})\s+([A-ZÇĞİÖŞÜ]{2,})\b');

    // Iterable<Match> matches = nameSurnameRegex.allMatches(text);

    // if (matches.isEmpty) {
    //   Iterable<Match> matchesLowerCase = nameREGEX.allMatches(text);

    //   if (matchesLowerCase.isNotEmpty) {
    //     for (Match match in matchesLowerCase) {
    //       String fullName = match.group(0)!;
    //       String firstName = match.group(1)!;
    //       String lastName = match.group(2)!;
    //       name ??= firstName;
    //       surName ??= lastName;

    //       print("Full Name: $fullName");
    //       print("First Name: $firstName");
    //       print("Last Name: $lastName");
    //       print("--------------");
    //     }
    //   }
    // } else {
    //   for (Match match in matches) {
    //     String fullName = match.group(0)!;
    //     String firstName = match.group(1)!;
    //     String lastName = match.group(2)!;

    //     name ??= firstName;
    //     surName ??= lastName;

    //     print("Full Name: $fullName");
    //     print("First Name: $firstName");
    //     print("Last Name: $lastName");
    //     print("--------------");
    //   }
    // }

    final nlp = EntityExtractor(language: EntityExtractorLanguage.turkish);
    final entitiess = await nlp.annotateText(text);

    for (var annotatedText in entitiess) {
      EntityType typee;
      for (var e in annotatedText.entities) {
        typee = e.type;

        switch (typee) {
          case EntityType.address:
            adres ??= annotatedText.text;
            break;
          case EntityType.email:
            mail ??= annotatedText.text;
            break;
          case EntityType.phone:
            if (annotatedText.text.length > 5) {
              telNo.add(annotatedText.text);
            }

            break;
          case EntityType.url:
            webAdress ??= annotatedText.text;
            break;
          default:
        }
      }
    }
    if (webAdress != null) {
      if (urlRegex.hasMatch(webAdress!)) {
        Iterable<Match> urlMatch = urlRegex.allMatches(text);
        if (urlMatch.isNotEmpty) {
          for (var element in urlMatch) {
            webAdress = element[0];
          }
        }
      }
    }
  }

  Future<List<dynamic>> jsonDataCheck(String filePath) async {
    String jsonString = await rootBundle.loadString(filePath);
    List<dynamic> jsonDataList = jsonDecode(jsonString);
    return jsonDataList;
  }

  void clearPhotos() {
    frontFace = null;
    backFace = null;
    photoSelected = false;
    twoSurface = false;
    frontExtractedText = '';
    backExtractedText = '';
    name = null;
    surName = null;
    companyName = null;
    adres = null;
    webAdress = null;
    mail = null;
    telNo = [];
    kartvizit = Kartvizit();
    notifyListeners();
  }
}
