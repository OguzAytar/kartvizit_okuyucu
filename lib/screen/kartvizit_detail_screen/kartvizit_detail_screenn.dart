// ignore_for_file: unused_import

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kartvizit_okuyucu/screen/kartvizit_detail_screen/kartvizit_detail_mixin.dart';
import 'package:provider/provider.dart';

import 'package:kartvizit_okuyucu/model/kartvizit_moder.dart';
import 'package:kartvizit_okuyucu/screen/main_screen_viewmodel.dart';

class KartvizitDetailScreen extends StatefulWidget {
  const KartvizitDetailScreen({super.key, required this.kartvizit});
  final Kartvizit kartvizit;
  @override
  State<KartvizitDetailScreen> createState() => _KartvizitDetailScreenState();
}

class _KartvizitDetailScreenState extends State<KartvizitDetailScreen> with KartvizitDetailMixin {
  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainScreenViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Kartvizit Detay'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  if (mainProvider.frontFace != null)
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(border: Border.all()),
                        child: Image.file(
                          mainProvider.frontFace!,
                          scale: 1,
                        ),
                      ),
                    )
                  else
                    const SizedBox(),
                  const SizedBox(width: 10),
                  if (mainProvider.backFace != null)
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(border: Border.all()),
                        child: Image.file(
                          mainProvider.backFace!,
                          scale: 1,
                        ),
                      ),
                    )
                  else
                    const SizedBox(),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameFieldController,
                decoration: const InputDecoration(
                    labelText: 'İsim Soyisim', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: companyNameFieldController,
                decoration: const InputDecoration(
                    labelText: 'Firma', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
              ),
              const SizedBox(height: 10),
              telNoFields.isNotEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: List.generate(telNoFields.length, (index) {
                            return TextFormField(
                              controller: telNoControllers[index],
                              decoration: InputDecoration(
                                  suffix: IconButton(
                                      onPressed: () {
                                        telNoControllers[index].clear();
                                      },
                                      icon: const Icon(Icons.cancel_outlined)),
                                  border: InputBorder.none,
                                  labelText: 'Telefon Numara ${index + 1}'),
                            );
                          }),
                        ),
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 10),
              TextFormField(
                controller: adresFieldController,
                minLines: 1,
                maxLines: 10,
                decoration: const InputDecoration(
                  labelText: 'Adres',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: mailFieldController,
                decoration: const InputDecoration(
                    labelText: 'E-Posta', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: webAdressFieldController,
                decoration: const InputDecoration(
                    labelText: 'WEB Sitesi', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
              ),
              const SizedBox(height: 100),
              telNoFields.isEmpty
                  ? const Center(
                      child: Text('Telefon Bilgisi Bulunamadı'),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
