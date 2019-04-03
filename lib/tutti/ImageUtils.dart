import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

//todo ver https://pub.dartlang.org/packages/camera
//todo ver https://pub.dartlang.org/packages/flutter_image_pick_crop
//todo https://pub.dartlang.org/packages/image_cropper

Future<Uint8List> base64ToMemoryImage(String strBase64) async {
  return base64.decode(strBase64);
}

Future<String> imageToString(File image) async{
  Uint8List bytes = image.readAsBytesSync();
  return base64.encode(bytes);
}

Future<String> imageFromPathToString(String path) async{
  return imageToString(File(path));
}

Future<File> pickImage(double maxWidth, double maxHeight, ImageSource source) async {
  if(maxWidth > 0  && maxHeight > 0){
    return await ImagePicker.pickImage(
      source: source,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
  } else if(maxWidth > 0){
    return await ImagePicker.pickImage(
      source: source,
      maxWidth: maxWidth,
    );
  } else if(maxHeight > 0){
    return await ImagePicker.pickImage(
      source: source,
      maxHeight: maxHeight,
    );
  } else {
    return await ImagePicker.pickImage(
      source: source,
    );
  }
}

Future<String> saveBase64AsImage(String strBase64, String fileName) async {
  Uint8List bytes = base64.decode(strBase64);
  String dir = (await getApplicationDocumentsDirectory()).path;
  File file = File('$dir/$fileName');
  await file.writeAsBytes(bytes);
  return file.path;
}

Future<void> deleteFile(String path) async {
  try {
    File(path).delete();
  } catch (e) {
    print("deleteFile: $e");
  }
}