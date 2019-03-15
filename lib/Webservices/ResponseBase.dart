abstract class ResponseBase{
  final bool success;
  final int error;
  final String errorInfo;

  ResponseBase({this.success, this.error, this.errorInfo});
}

/*
  Descarga de catálogos, cambio de password, eliminación de foto, contacto,
  grupo o entidad
 */
class GeneralResult extends ResponseBase{
  GeneralResult({
    success,
    error,
    errorInfo,
  }) : super(success: success, error: error, errorInfo: errorInfo);

  factory GeneralResult.fromJson(Map<String, dynamic> jsonMap) => GeneralResult(
    success: jsonMap["success"],
    error: jsonMap["error"],
    errorInfo: jsonMap["errorInfo"],
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "error": error,
    "errorInfo": errorInfo,
  };
}

/*
  T=bool
    valida correo
    valida teléfono
    existe device
  T=string
    registra device
 */
//
class Validator<T> extends ResponseBase{
  final DataResponse<T> data;

  Validator({
    success,
    error,
    errorInfo,
    this.data
  }) : super(success: success, error: error, errorInfo: errorInfo);


  factory Validator.fromJson(Map<String, dynamic> jsonMap, String attributeName) {
    Map<String, dynamic> innerJsonMap;
    DataResponse<T> data;
    try{
      innerJsonMap = jsonMap['data'];
      data = DataResponse.fromJson(innerJsonMap, attributeName);
    } catch(ex){
      data = null;
    }

    return Validator<T>(
      success: jsonMap["success"],
      error: jsonMap["error"],
      errorInfo: jsonMap["errorInfo"],
    );
  }

  Map<String, dynamic> toMap() => {
    "success": success,
    "error": error,
    "errorInfo": errorInfo,
    "data": data,
  };
}

class UserRegister extends ResponseBase{
  final DataResponse<UserResponse> data;

  UserRegister({
    success,
    error,
    errorInfo,
    this.data
  }) : super(success: success, error: error, errorInfo: errorInfo);
}

class CatalogsCounter extends ResponseBase{
  final DataResponse<CatalogsQuantityResponse> data;

  CatalogsCounter({
    success,
    error,
    errorInfo,
    this.data
  }) : super(success: success, error: error, errorInfo: errorInfo);
}

class CatalogsDownloader extends ResponseBase{
  final List<DefinitionResponse> definitions;
  final List<InterpretationResponse> interpretations;
  final List<ActivityResponse> activities;
  final List<SemanticsResponse> semantics;

  CatalogsDownloader({
    success,
    error,
    errorInfo,
    this.definitions,
    this.interpretations,
    this.activities,
    this.semantics,
  }) : super(success: success, error: error, errorInfo: errorInfo);
}

//para confirmar correo y teléfono
class ConfirmationSender extends ResponseBase{
  final bool confirmation;

  ConfirmationSender({
    success,
    error,
    errorInfo,
    this.confirmation
  }) : super(success: success, error: error, errorInfo: errorInfo);
}

class SessionValidator extends ResponseBase{
  final bool syncPersonal;
  final bool syncContacts;
  final bool syncGroups;
  final bool syncEntities;
  final bool syncDefinitions;
  final bool syncInterpretations;
  final bool syncActivities;
  final bool syncSemantics;

  SessionValidator({
    success,
    error,
    errorInfo,
    this.syncPersonal,
    this.syncContacts,
    this.syncGroups,
    this.syncEntities,
    this.syncDefinitions,
    this.syncInterpretations,
    this.syncActivities,
    this.syncSemantics,
  }) : super(success: success, error: error, errorInfo: errorInfo);
}

/*
  Cambiar datos de usuario (nombre: T=PowerOfName, DoB: T=Pinnacle, correo,
    teléfono y foto: T=String), fotos de contactos y grupos (T=String)
 */
class DataChanger<T> extends ResponseBase{
  final T data;

  DataChanger({
    success,
    error,
    errorInfo,
    this.data
  }) : super(success: success, error: error, errorInfo: errorInfo);
}

//agregar contacto, grupo o entidad
class PartnerAdder extends ResponseBase{
  final int id;
  final Pinnacle pinnacle;
  final PowerOfName powerOfName;

  PartnerAdder({
    success,
    error,
    errorInfo,
    this.id,
    this.pinnacle,
    this.powerOfName,
  }) : super(success: success, error: error, errorInfo: errorInfo);
}

//agregar o actualizar contacto, grupo o entidad
class PartnerUpdater extends ResponseBase{
  final Pinnacle pinnacle;
  final PowerOfName powerOfName;

  PartnerUpdater({
    success,
    error,
    errorInfo,
    this.pinnacle,
    this.powerOfName,
  }) : super(success: success, error: error, errorInfo: errorInfo);
}

class GroupMemberAdder extends ResponseBase{
  final int id;
  final Pinnacle pinnacle;

  GroupMemberAdder({
    success,
    error,
    errorInfo,
    this.id,
    this.pinnacle,
  }) : super(success: success, error: error, errorInfo: errorInfo);
}

class GroupMemberRemover extends ResponseBase{
  final Pinnacle pinnacle;

  GroupMemberRemover({
    success,
    error,
    errorInfo,
    this.pinnacle,
  }) : super(success: success, error: error, errorInfo: errorInfo);
}


//todo poner los nombres de campos en el json como está en el api
class DataResponse<T>{
  final T attribute;

  DataResponse({this.attribute});

  factory DataResponse.fromJson(Map<String, dynamic> jsonMap,
      String attributeName) => DataResponse(
    attribute: jsonMap[attributeName],
  );

  Map<String, dynamic> toMap(String attributeName) => {
    attributeName: attribute,
  };
}

class UserResponse{
  final String id;
  final int a;
  final int b;
  final int c;
  final int d;
  final int e;
  final int f;
  final int g;
  final int h;
  final int i;
  final int j;
  final int k;
  final int l;
  final int m;
  final int n;
  final int o;
  final int p;
  final int q;
  final int r;
  final int s;
  final int t;
  final int w1;
  final int w2;
  final int w3;
  final int x;
  final int y;
  final int z;
  final int pi1;
  final int pi2;
  final int pi3;
  final int pi4;
  final int poder;
  final int numero;
  final int expression;
  final String sid;

  UserResponse({
    this.id,
    this.a,
    this.b,
    this.c,
    this.d,
    this.e,
    this.f,
    this.g,
    this.h,
    this.i,
    this.j,
    this.k,
    this.l,
    this.m,
    this.n,
    this.o,
    this.p,
    this.q,
    this.r,
    this.s,
    this.t,
    this.w1,
    this.w2,
    this.w3,
    this.x,
    this.y,
    this.z,
    this.pi1,
    this.pi2,
    this.pi3,
    this.pi4,
    this.poder,
    this.numero,
    this.expression,
    this.sid,
  });

  factory UserResponse.fromJson(Map<String, dynamic> jsonMap) => UserResponse(
    id: jsonMap['id'],
    a: jsonMap['a'],
    b: jsonMap['b'],
    c: jsonMap['c'],
    d: jsonMap['d'],
    e: jsonMap['e'],
    f: jsonMap['f'],
    g: jsonMap['g'],
    h: jsonMap['h'],
    i: jsonMap['i'],
    j: jsonMap['j'],
    k: jsonMap['k'],
    l: jsonMap['l'],
    m: jsonMap['m'],
    n: jsonMap['n'],
    o: jsonMap['o'],
    p: jsonMap['p'],
    q: jsonMap['q'],
    r: jsonMap['r'],
    s: jsonMap['s'],
    t: jsonMap['t'],
    w1: jsonMap['w1'],
    w2: jsonMap['w2'],
    w3: jsonMap['w3'],
    x: jsonMap['x'],
    y: jsonMap['y'],
    z: jsonMap['z'],
    pi1: jsonMap['pi1'],
    pi2: jsonMap['pi2'],
    pi3: jsonMap['pi3'],
    pi4: jsonMap['pi4'],
    poder: jsonMap['poder'],
    numero: jsonMap['numero'],
    expression: jsonMap['expression'],
    sid: jsonMap['sid'],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "a": a,
    "b": b,
    "c": c,
    "d": d,
    "e": e,
    "f": f,
    "g": g,
    "h": h,
    "i": i,
    "j": j,
    "k": k,
    "l": l,
    "m": m,
    "n": n,
    "o": o,
    "p": p,
    "q": q,
    "r": r,
    "s": s,
    "t": t,
    "w1": w1,
    "w2": w2,
    "w3": w3,
    "x": x,
    "y": y,
    "z": z,
    "pi1": pi1,
    "pi2": pi2,
    "pi3": pi3,
    "pi4": pi4,
    "poder": poder,
    "numero": numero,
    "expression": expression,
    "sid": sid,
  };
}

class CatalogsQuantityResponse{
  final int definitions;
  final int interpretations;
  final int activities;
  final int semantics;

  CatalogsQuantityResponse({
    this.definitions,
    this.interpretations,
    this.activities,
    this.semantics,
  });


  factory CatalogsQuantityResponse.fromJson(Map<String, dynamic> jsonMap) => CatalogsQuantityResponse(
    definitions: jsonMap["definitions"],
    interpretations: jsonMap["interpretations"],
    activities: jsonMap["activities"],
    semantics: jsonMap["semantics"],
  );

  Map<String, dynamic> toMap() => {
    "definitions": definitions,
    "interpretations": interpretations,
    "activities": activities,
    "semantics": semantics,
  };
}

class DefinitionResponse{
  DefinitionResponse();
}

class InterpretationResponse{
  InterpretationResponse();
}

class ActivityResponse{
  ActivityResponse();
}

class SemanticsResponse{
  SemanticsResponse();
}

class PowerOfName{
  PowerOfName();
}

class Pinnacle{
  Pinnacle();
}