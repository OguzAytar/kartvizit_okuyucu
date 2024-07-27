// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:kartvizit_okuyucu/screen/main_screen_viewmodel.dart';
import 'package:provider/provider.dart';

import 'kartvizit_detail_screen/kartvizit_detail_screenn.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueGrey[800],
        title: const Text(
          'Kartvizit Okuyucu',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Provider.of<MainScreenViewModel>(context).photoSelected
              ? IconButton(
                  onPressed: () async {
                    Provider.of<MainScreenViewModel>(context, listen: false).clearPhotos();
                    selector(context: context);
                  },
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.deepOrangeAccent,
                  ),
                )
              : const SizedBox()
        ],
      ),
      body: Consumer<MainScreenViewModel>(
        builder: (context, value, child) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: value.frontFace == null
                        ? Center(
                            child: TextButton(
                              onPressed: () => selector(context: context),
                              child: const Text('Fotoğraf Seç'),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(border: Border.all(width: 5, color: Colors.amber)),
                            child: Image.file(value.frontFace!)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: value.backFace == null
                        ? const SizedBox()
                        : Container(
                            decoration: BoxDecoration(border: Border.all(width: 5, color: Colors.amber)),
                            child: Image.file(value.backFace!)),
                  ),
                ),
                value.frontFace != null && value.backFace == null
                    ? TextButton(onPressed: () => selector(context: context), child: const Text('2. Yüz Ekleyin'))
                    : const SizedBox(),
                value.photoSelected
                    ? TextButton(
                        style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blueGrey)),
                        onPressed: () async {
                          await value.processCard();
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => KartvizitDetailScreen(
                              kartvizit: value.kartvizit,
                            ),
                          ));
                        },
                        child: const Text(
                          'Kartviziti İşle',
                          style: TextStyle(color: Colors.white),
                        ))
                    : const SizedBox(),
                const SizedBox(height: 100)
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> selector({required BuildContext context}) {
    final provider = Provider.of<MainScreenViewModel>(context, listen: false);
    return showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (context) {
        return SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            children: [
              TextButton(
                  onPressed: () => provider.pickImageGallery().then((value) => Navigator.of(context).pop()),
                  child: const Text('Galeriden Seç')),
              TextButton(
                  onPressed: () => provider.pickImageCamera().then((value) => Navigator.of(context).pop()),
                  child: const Text('Fotoğraf Çek'))
            ],
          ),
        );
      },
    );
  }
}
