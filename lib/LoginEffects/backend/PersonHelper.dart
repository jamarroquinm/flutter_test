import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:learning_flutter/LoginEffects/backend/exports.dart';
import 'package:learning_flutter/LoginEffects/backend/enums/exports.dart';
import 'package:learning_flutter/LoginEffects/model/exports.dart';

import 'Database.dart';
import 'Utils.dart';

class PersonHelper {

  Future<Person> addUpload(Person item) async {
    //todo subir vía webservice y con el response agregarlo a la db local

    Person returnedItem = item;

    if(!existRegister(returnedItem)){
      return _defaultPerson(returnedItem);
    }

    int affectedRows = await _add(returnedItem);

    return affectedRows > 0 ? returnedItem : _dbErrorPerson();
  }

  Future<Person> updateUpload(Person item) async {
    //todo vía webservice subir la actualización y luego hacerla localmente

    Person returnedItem = item;

    if(!existRegister(returnedItem)){
      return _defaultPerson(returnedItem);
    }

    int affectedRows = await _update(returnedItem);

    return affectedRows > 0 ? returnedItem : _dbErrorPerson();
  }

  Future<int> deleteAll() async {
    String query = 'DELETE FROM Persons';
    int affectedRows = await DBProvider.db.delete(query);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('personId', '');

    return affectedRows;
  }

  Future<int> delete(String serverId) async {
    if(serverId == null || serverId == ''){
      return 0;
    }

    String query = 'DELETE FROM Persons WHERE serverId = "$serverId"';
    int affectedRows = await DBProvider.db.delete(query);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String personId = prefs.get('personId') ?? '';

    if(personId == serverId){
      await prefs.setString('personId', '');
    }

    return affectedRows;
  }

  Future<Person> getItem({@required String userName, @required String password}) async {
    //todo vía webservice verificar credenciales y recuperar usuario
    Person returnedItem = getTestPerson();
    if(!existRegister(returnedItem)){
      return _defaultPerson(returnedItem);
    }

    Person instance = await _getItem(returnedItem.serverId);
    int affectedRows;

    if(!existRegister(instance)){
      affectedRows = await _add(returnedItem);
    } else {
      affectedRows = await _update(returnedItem);
    }

    if(affectedRows == 0){
      _closeAllSessions();

      return _dbErrorPerson();
    } else {
      instance = await _getItem(returnedItem.serverId);
      _updateGlobalInstance(instance);

      return instance;
    }
  }

  Future<Person> getItemFromRepository() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String personId = prefs.getString('personId');

    if(personId == null || personId == ''){
      return Person();
    }

    String query = 'SELECT * FROM Persons WHERE serverId = "$personId"';

    var result = await DBProvider.db.getFirstRow(query);

    Person instance;
    if(result != null){
      instance = Person.fromMap(result);
      _updateGlobalInstance(instance);
    } else {
      instance = Person();
      await _closeAllSessions();
    }

    return instance;
  }

  Future<void> logout() async {
    appInstance.logout();
  }

  Future<void> _updateGlobalInstance(Person instance) async {
    _closeAllSessions(personId: instance.serverId);
    if(existRegister(instance)){
      instance.numbers = await KeyNumbersHelper().getNumbersPerson(instance);
      appInstance.updateUser(instance);
    }
  }

  Future<int> _add(Person item) async {
    String query = 'INSERT INTO Persons VALUES('
        '"${item.serverId}",'
        '${item.idCountry},'
        '${item.idLanguage},'
        '"${item.firstName1}",'
        '${item.firstName2 == null ? null : '\"${item.firstName2}\"'},'
        '"${item.lastName1}",'
        '${item.lastName2 == null ? null : '\"${item.lastName2}\"'},'
        '"${dateTimeToIso8601(item.birthDate)}",'
        '"${item.picture}",'
        '"${planNameFromEnumValue(item.plan)}",'
        '"${item.genre}")'
    ;

    int lastId = await DBProvider.db.add(query);

    return lastId;
  }

  Future<int> _update(Person item) async {
    String query = 'UPDATE Persons SET '
        'idCountry = ${item.idCountry},'
        'idLanguage = ${item.idLanguage},'
        'firstName1 = "${item.firstName1}",'
        'firstName2 = ${item.firstName2 == null ? null : '\"${item.firstName2}\"'},'
        'lastName1 = "${item.lastName1}",'
        'lastName2 = ${item.lastName2 == null ? null : '\"${item.lastName2}\"'},'
        'birthDate = "${dateTimeToIso8601(item.birthDate)}",'
        'picture = "${item.picture}",'
        'plan = "${item.plan}",'
        'genre = "${item.genre}" '
        'WHERE serverId = "${item.serverId}"';

    int affectedRows = await DBProvider.db.update(query);

    return affectedRows;
  }

  Future<Person> _getItem(String id) async {
    String query = 'SELECT * FROM Persons WHERE serverId = "$id"';

    var result = await DBProvider.db.getFirstRow(query);

    Person instance;
    if(result != null){
      instance = Person.fromMap(result);
    } else {
      instance = Person();
    }

    return instance;
  }

  Future<void> _closeAllSessions({String personId = ''}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('personId', personId);
  }

  Person _defaultPerson(Person originalInstance){
    if(originalInstance == null){
      return Person(message: "Undefined error", status: -1);
    }

    String message;
    int status;

    if(originalInstance.message == null || originalInstance.message == ''){
      message = "Person: No error message";
    } else {
      message = originalInstance.message;
    }

    if(originalInstance.status == null){
      status = -1;
    } else {
      status = originalInstance.status;
    }


    return Person(message: message, status: status);
  }

  Person _dbErrorPerson([String errorMessage='']){
    if(errorMessage == null || errorMessage == ''){
      return Person(message: errorMessage, status: -1);
    }

    return Person(message: "Undefined local DB error", status: -1);
  }
}


//todo quitar los siguientes datos de prueba
Person getTestPerson(){
  return Person(
    serverId: '1B',
    idCountry: 1,
    idLanguage: 1,
    firstName1: 'Miguel',
    firstName2: '',
    lastName1: 'Hidalgo',
    lastName2: 'y Costilla',
    birthDate: DateTime(1990, 5, 27),
    picture: '678.png',
    plan: Plan.premium,
    genre: 'M',
    message: '',
    status: 1,
  );
}