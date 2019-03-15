import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import 'GlobalData.dart';
import 'WebserviceModel.dart';

class WebserviceBack{
  final String _urlRoot = 'http://18.188.38.108/numera/mws/app/';
  final String _service = 'valida.php';
  final String _operationTag = 'operacion';
  final String _operationName = 'correo';

  Future<WebserviceModel> getModel(String correo) async {
    String url = p.join(_urlRoot, _service);
    String jsonString;
    Map<String, dynamic> body = {};
    body[_operationTag] = _operationName;
    body['correo'] = correo;

    final response = await http.post(url, body: body);

    if(response.statusCode == 200){
      jsonString = response.body;
      print(jsonString);
      var jsonDecoded = json.decode(jsonString);

      return WebserviceModel.fromJson(jsonDecoded);
    } else {
      return WebserviceModel();
    }
  }

}