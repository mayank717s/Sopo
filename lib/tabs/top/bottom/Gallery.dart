import 'dart:async';
import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spac/tabs/top/bottom/History.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  File? _image;
  File? _imageFile;
  File? _selectedFile;
  final picker = ImagePicker();
  String result = "";
  String query = "";

  Future takePhoto() async {
    // ignore: deprecated_member_use
    final PickedFile = await picker.getImage(source: ImageSource.camera);
    _imageFile = PickedFile != null ? File(PickedFile.path) : null;
    final CroppedFile;
    if (_imageFile != null) {
      File? cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile!.path,
        aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
        androidUiSettings: androidUiSettings(),
        iosUiSettings: iosUiSettings(),
      );
      setState(() {
        _image = File(cropped!.path);
        performImageLabeling();
      });
    }
  }

  Future pickfromGallery() async {
    final CroppedFile;
    final PickedFile = await picker.getImage(source: ImageSource.gallery);
    _imageFile = PickedFile != null ? File(PickedFile.path) : null;
    if (_imageFile != null) {
      File? cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile!.path,
        aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
        androidUiSettings: androidUiSettings(),
        iosUiSettings: iosUiSettings(),
      );
      setState(() {
        _image = File(cropped!.path);
        performImageLabeling();
      });
    }
  }

  Future performImageLabeling() async {
    final FirebaseVisionImage firebaseVisionImage =
        FirebaseVisionImage.fromFile(_image);
    final TextRecognizer recognizer = FirebaseVision.instance.textRecognizer();

    VisionText visionText = await recognizer.processImage(firebaseVisionImage);

    result = "";

    setState(() {
      for (TextBlock block in visionText.blocks) {
        final String txt = block.text;

        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            result += element.text + " ";
          }
        }
        result += "\n\n";
      }
      query = "https://www.google.com/search?q=" + result + "k&aqs";
      _sendDatatoSecondScreen(context);
    });
  }

  void _sendDatatoSecondScreen(BuildContext context) {
    String texttosend = result;
    String link = query;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                History(text: texttosend, link: query)));
  }

  static IOSUiSettings iosUiSettings() => IOSUiSettings(
        aspectRatioLockEnabled: false,
      );

  static AndroidUiSettings androidUiSettings() => AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        lockAspectRatio: false,
      );

  @override
  Widget build(BuildContext context) {
    final bgColor = const Color(0xFF151515);
    final barColor = const Color(0xFFE94C21);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: barColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'images/logo.png',
                fit: BoxFit.cover,
                height: 32,
              ),
              Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Text('Sopo',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400)))
            ],
          ),
        ),
        backgroundColor: bgColor,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  child: Container(
                    child: Center(
                      child: Column(
                        children: [
                          SingleChildScrollView(
                            child: Container(
                                child: Text('OPEN CAMERA OR GALLERY',
                                    style: TextStyle(color: Colors.white70))),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            backgroundColor: barColor,
            child: Icon(Icons.camera_alt),
            onPressed: () {
              takePhoto();
            },
            heroTag: null,
          ),
          SizedBox(
            height: 10,
          ),
          Padding(padding: const EdgeInsets.all(8.0)),
          FloatingActionButton(
            backgroundColor: barColor,
            child: Icon(Icons.file_copy),
            onPressed: () {
              pickfromGallery();
            },
            heroTag: null,
          )
        ]));
  }
}
