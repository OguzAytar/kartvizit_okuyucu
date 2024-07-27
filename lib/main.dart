import 'package:flutter/material.dart';
import 'package:kartvizit_okuyucu/screen/kartvizit_detail_screen/kartvizit_detail_viewmodel.dart';
import 'package:kartvizit_okuyucu/screen/main_screen.dart';
import 'package:kartvizit_okuyucu/screen/main_screen_viewmodel.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

//! 1. ADIM
//Galeriden seçilen ya da kameradan Fotoğraf ana ekrana eklensin
//! 2. ADIM
//Seçilen Fotoğrafı işle ve metnini çıkart
//! 3. ADIM
// Çıkartılan Metin içerisinde gerekli alanları regex ile bul
// çıkartılan metnin bloklarını ele al ve istenen verinin olup olmadığını incele

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => MainScreenViewModel()),
      ChangeNotifierProvider(create: (context) => KartvizitDetailViewModel()),
    ], child: const MaterialApp(title: 'Material App', home: MainScreen()));
  }
}
