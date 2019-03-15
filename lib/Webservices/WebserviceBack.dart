import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import 'GlobalData.dart';
import 'ResponseBase.dart';
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

//------------------------------------------------------------
  Future<ValidatorBoolResponse> validateEmail(String email) async {
    String url = p.join(appInstance.urlRoot, appInstance.validationPage);
    Map<String, dynamic> requestBody = {
      appInstance.operationTag: appInstance.emailValidationOperation,
      'correo' : email,
    };

    final response = await http.post(url, body: requestBody);

    if(response.statusCode == 200){
      print(response.body);

      return ValidatorBoolResponse.fromJson(json.decode(response.body), 'valido');
    } else {
      return ValidatorBoolResponse(data: DataBoolResponse(attribute: false));
    }
  }

  Future<ValidatorBoolResponse> validatePhoneNumber(String phoneNumber) async {
    String url = p.join(appInstance.urlRoot, appInstance.validationPage);
    Map<String, dynamic> requestBody = {
      appInstance.operationTag: appInstance.emailValidationOperation,
      'telefono' : phoneNumber,
    };

    final response = await http.post(url, body: requestBody);

    if(response.statusCode == 200){
      print(response.body);

      return ValidatorBoolResponse.fromJson(json.decode(response.body), 'valido');
    } else {
      return ValidatorBoolResponse(data: DataBoolResponse(attribute: false));
    }
  }

  Future<ValidatorStringResponse> deviceRegistration(Device device) async {
    String url = p.join(appInstance.urlRoot, appInstance.devicePage);
    Map<String, dynamic> initialMap = {appInstance.operationTag: appInstance.deviceRegistrationOperation};
    Map<String, dynamic> requestBody = device.toMap(initialMap);

    final response = await http.post(url, body: requestBody);

    if(response.statusCode == 200){
      print(response.body);

      return ValidatorStringResponse.fromJson(json.decode(response.body), 'id');
    } else {
      return ValidatorStringResponse(data: DataStringResponse());
    }
  }

  Future<ValidatorBoolResponse> existDevice(String id) async {
    String url = p.join(appInstance.urlRoot, appInstance.devicePage);
    Map<String, dynamic> requestBody = {
      appInstance.operationTag: appInstance.deviceExistsOperation,
      'id' : id,
    };

    final response = await http.post(url, body: requestBody);

    if(response.statusCode == 200){
      print(response.body);

      return ValidatorBoolResponse.fromJson(json.decode(response.body), 'existe');
    } else {
      return ValidatorBoolResponse(data: DataBoolResponse());
    }
  }

  Future<ValidatorStringResponse> userRegistration(Person person) async {
    String url = p.join(appInstance.urlRoot, appInstance.userInitializationPage);
    Map<String, dynamic> initialMap = {appInstance.operationTag: appInstance.userRegistrationOperation};
    Map<String, dynamic> requestBody = person.toMap(initialMap);

    final response = await http.post(url, body: requestBody);

    if(response.statusCode == 200){
      print(response.body);

      return ValidatorStringResponse.fromJson(json.decode(response.body), 'id');
    } else {
      return ValidatorStringResponse(data: DataStringResponse());
    }
  }
//------------------------------------------------------------


}