import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kartvizit_okuyucu/screen/kartvizit_detail_screen/kartvizit_detail_screenn.dart';

mixin KartvizitDetailMixin on State<KartvizitDetailScreen> {
  TextEditingController? nameFieldController = TextEditingController();
  TextEditingController? companyNameFieldController = TextEditingController();
  // TextEditingController? telNoFieldController = TextEditingController();
  List<String> telNoFields = [];

  TextEditingController? adresFieldController = TextEditingController();
  TextEditingController? mailFieldController = TextEditingController();
  TextEditingController? webAdressFieldController = TextEditingController();
  late List<TextEditingController> telNoControllers =
      List.generate(telNoFields.length, (index) => TextEditingController(text: telNoFields[index]));

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        nameFieldController!.text = widget.kartvizit.fulName ?? '${widget.kartvizit.name} ${widget.kartvizit.surName}';
        companyNameFieldController!.text = widget.kartvizit.companyName ?? '';

        telNoFields = widget.kartvizit.telNo ?? [];
        adresFieldController!.text = widget.kartvizit.adres ?? '';
        mailFieldController!.text = widget.kartvizit.mail ?? '';
        webAdressFieldController!.text = widget.kartvizit.webAdress ?? '';
      });
    });
  }

  void telNoSil(int index) {
    log(index.toString());
    widget.kartvizit.telNo![index] = '';
    setState(() {});
  }
}
