import 'package:json_annotation/json_annotation.dart';

class WebserviceModel{
  final bool success;
  final int error;
  final String errorInfo;
  final Data data;
  bool _serviceInvoked;

  WebserviceModel({
    this.success,
    this.error,
    this.errorInfo,
    this.data
  }){ _serviceInvoked = false; }


  factory WebserviceModel.fromJson(Map<String, dynamic> jsonMap){
    Map<String, dynamic> innerJsonMap;
    Data data;
    try{
      innerJsonMap = jsonMap['data'];
      data = Data.fromJson(innerJsonMap);
    } catch(ex){
      data = null;
    }

    WebserviceModel result = WebserviceModel(
      success: jsonMap["success"],
      error: jsonMap["error"],
      errorInfo: jsonMap["errorinfo"],
      data: data,
    );

    result._serviceInvoked = true;

    return result;
  }

  Map<String, dynamic> toMap() => {
    "success": success,
    "error": error,
    "errorinfo": errorInfo,
    "data": data,
  };

  @override
  String toString() => 'Attr: success=${success.toString()}, '
      'error=${error.toString()}, '
      'errorInfo=$errorInfo, '
      'data=${data.toString()}';

  bool get serviceInvoked => _serviceInvoked;
}


class Data{
  final bool valido;

  Data({this.valido});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      valido: json["valido"],
    );

  Map<String, dynamic> toMap() => {
    "valido": valido,
  };
}



/*
  //todo seguir probando la generación de código con build_runner
part 'Webservicemodel.g.dart';

*//*
  - agregar los paquetes:
      json_annotation: ^2.0.0
      json_serializable: ^2.0.3
      build_daemon: ^0.4.2
      build_runner: ^1.2.8
  - crear build.yaml en el mismo directorio que pubspec.yaml
  - incluir en este archivo la directiva
      part '[nombre file].g.dart';
  - anotar la clase con etiquetas @JsonSerializable o @JsonKey, a las que pueden
    agregarse los parámetros que se enlistan en build.yaml
  - usar @JsonKey con el parámetro name cuando el campo se llame diferente en el
    json y esta clase
  - finalmente ejecutar
      flutter packages pub run build_runner build lib
 *//*

@JsonSerializable(nullable: false)
class WebserviceModel{
  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'error')
  final int error;

  @JsonKey(name: 'errorinfo', includeIfNull: false)
  final String errorInfo;

  @JsonKey(name: 'data')
  final Data data;

  WebserviceModel({
    this.success,
    this.error,
    this.errorInfo,
    this.data
  });

  factory WebserviceModel.fromJson(Map<String, dynamic> json) => _$WebserviceModelFromJson(json);
  Map<String, dynamic> toJson() => _$WebserviceModelToJson(this);

}*/
