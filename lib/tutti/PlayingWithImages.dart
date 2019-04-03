import 'package:flutter/material.dart';
import 'ImageUtils.dart';

class PlayingWithImages extends StatefulWidget {
  @override
  _PlayingWithImagesState createState() => _PlayingWithImagesState();
}

class _PlayingWithImagesState extends State<PlayingWithImages> {
  var _image;

  @override
  void initState(){
    super.initState();

    _image = base64ToMemoryImage(base64Test).then((v) {
      setState(() {
        _image = v;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Imagen <-> base64'),
        ),
        body: Container(
          child: getImage(),
        ),
      ),
    );
  }

  Widget getImage(){
    if(_image == null){
      return Text('');
    } else {
      return Image.memory(_image);
    }
  }
}

final String base64Test = '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';

