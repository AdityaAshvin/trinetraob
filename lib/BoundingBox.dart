import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_tts/flutter_tts.dart';

List<String> myobjects = List<String>();
int temp = 0;
int repeat = 0;
FlutterTts flutterTts = FlutterTts();

speak(result) {
  flutterTts.speak(result);
  flutterTts.setLanguage("en-US");
  flutterTts.setPitch(1);
  flutterTts.setVoice({"name": "Karen", "locale": "en-AU"});

}

objectlist (objectslist) {
  myobjects.add(objectslist);
  print(myobjects);
  if(myobjects.length>= 20) {
    myobjects = [];
    temp = 0;
  }
  for(int i = temp; i < myobjects.length; i++){
    for (int j = 0; j < myobjects.length; j++)
    {
      if (myobjects[i] == myobjects[j]){
        print("${myobjects[i]} and ${myobjects[j]}");
        if (myobjects.length > 1 && i != j){
          repeat = 1;
          break;
        }
        else {
          repeat = 0;
          break;
        }
      }
      }
    if (repeat == 0) {
      Future.delayed(Duration(milliseconds: 600), () {
        speak("${myobjects[i]} detected");
      });
    }
    temp = temp + 1;
  }
}

class BoundingBox extends StatelessWidget {
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
  final String model;






  Future myFuture() async {

    await new Future.delayed(new Duration(seconds: 3));

  }



  BoundingBox(this.results, this.previewH, this.previewW, this.screenH,
      this.screenW, this.model);

  @override
  Widget build(BuildContext context) {
    List<Widget> _renderBoxes() {
      return results.map((re) {
        var _x = re["rect"]["x"];
        var _w = re["rect"]["w"];
        var _y = re["rect"]["y"];
        var _h = re["rect"]["h"];
        var scaleW, scaleH, x, y, w, h;
        String objectdetected = "${re["detectedClass"]}";
        objectlist(objectdetected);

        if (screenH / screenW > previewH / previewW) {
          scaleW = screenH / previewH * previewW;
          scaleH = screenH;
          var difW = (scaleW - screenW) / scaleW;
          x = (_x - difW / 2) * scaleW;
          w = _w * scaleW;
          if (_x < difW / 2) w -= (difW / 2 - _x) * scaleW;
          y = _y * scaleH;
          h = _h * scaleH;
        } else {
          scaleH = screenW / previewW * previewH;
          scaleW = screenW;
          var difH = (scaleH - screenH) / scaleH;
          x = _x * scaleW;
          w = _w * scaleW;
          y = (_y - difH / 2) * scaleH;
          h = _h * scaleH;
          if (_y < difH / 2) h -= (difH / 2 - _y) * scaleH;
        }

        return Positioned(
          left: math.max(0, x),
          top: math.max(0, y),
          width: w,
          height: h,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 40.0, right: 20.0),
                height: h * 0.9,
                width: w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromRGBO(37, 213, 253, 1.0),
                    width: 3.0,
                  ),
                ),
                child: Text(
                  "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
                  style: TextStyle(
                    color: Color.fromRGBO(37, 213, 253, 1.0),
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
              ),
            ],
          ),
        );



      }).toList();
    }
    return Stack(
      children: _renderBoxes(),
    );
  }

}



