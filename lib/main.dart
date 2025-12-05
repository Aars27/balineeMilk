import 'package:balineemilk/Components/Providers/MainProviders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Components/Savetoken/SaveToken.dart';



void main() async {


  final isLoggedIn = await TokenHelper().isLoggedIn();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);


  runApp(

Mainproviders()


  );
}

