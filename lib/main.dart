import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:spac/tabs/top/bottom/Gallery.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Media Post Authenticity Checker',
      initialRoute: 'home',
      home: Gallery(),
      routes: {
        'home': (context) => Gallery(),
      },
    );
  }
}
