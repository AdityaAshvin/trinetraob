import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:trinetraob/BoundingBox.dart';
import 'package:trinetraob/Camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;
import 'package:flutter_tts/flutter_tts.dart';




const String ssd = "SSD MobileNet";

class HomeScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  HomeScreen(this.cameras);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  int _temp = 0;
  String _model = "";
  FlutterTts flutterTts = FlutterTts();


  speak() {
    if(_temp == 0){
      flutterTts.speak("Trinetra at your service");
      _temp = 1;
    }
    flutterTts.setLanguage("en-US");
    flutterTts.setPitch(1);
    flutterTts.setVoice({"name": "Karen", "locale": "en-AU"});
  }

  loadModel() async {
    String result;

    switch (_model) {
      case ssd:
        result = await Tflite.loadModel(
            labels: "assets/ssd_mobilenet.txt",
            model: "assets/ssd_mobilenet.tflite");
    }
    print(result);
  }

  onSelectModel(model) {
    setState(() {
      _model = model;
    });

    loadModel();
    speak();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }




  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    onSelectModel(ssd);
    return Scaffold(
      body: _model == ""
          ? Container()
          : Stack(
        children: [
          Camera(widget.cameras, _model, setRecognitions),
          BoundingBox(
              _recognitions == null ? [] : _recognitions,
              math.max(_imageHeight, _imageWidth),
              math.min(_imageHeight, _imageWidth),
              screen.width, screen.height, _model
    )
        ],
      ),
    );
  }
}
