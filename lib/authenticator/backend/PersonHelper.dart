import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uuid/uuid.dart';
import 'package:learning_flutter/authenticator/backend/Database.dart';
import 'package:learning_flutter/authenticator/backend/Utils.dart';
import 'package:learning_flutter/authenticator/models/Person.dart';

class PersonHelper {

  //con login se agrega un usuario; sin ese dato se trata solo de un contacto
  //del usuario logueado
  Future<Person> add(Person item) async {
    String query = 'INSERT INTO Persons VALUES('
        '${item.id},'
        '"${item.login}",'
        '"${item.password}",'
        '"${item.names}",'
        '"${item.lastName1}",'
        '"${item.lastName2}",'
        '"${dateTimeToIso8601(item.birthDate)}",'
        '"${item.token}",'
        '"${dateTimeToIso8601(item.tokenUpdate)}",'
        '${item.contactId},'
        '${item.flag})';

    int lastId = await DBProvider.db.add(query);

    Person newInstance;
    if(lastId > 0){
      if(item.login != null && item.login != ''){
        item.token = Uuid().v1();
        item.tokenUpdate = DateTime.now();

        await update(item);
      }

      newInstance = item;
    } else {
      newInstance = Person(id: 0);
    }

    return newInstance;
  }

  Future<int> update(Person item) async {
    String query = 'UPDATE Persons SET '
        'password = "${item.password}",'
        'names = "${item.names}",'
        'lastName1 = "${item.lastName1}",'
        'lastName2 = "${item.lastName2}",'
        'birthDate = "${dateTimeToIso8601(item.birthDate)}",'
        'token = ${item.token},'
        'tokenUpdate = "${dateTimeToIso8601(item.tokenUpdate)}",'
        'flag = ${item.flag}'
        'WHERE id = ${item.id})';

    int affectedRows = await DBProvider.db.update(query);

    return affectedRows;
  }

  Future<int> deleteAll() async {
    String query = 'DELETE FROM Persons';
    int affectedRows = await DBProvider.db.delete(query);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('personId', 0);

    return affectedRows;
  }

  Future<int> delete(int id) async {
    if(id <= 0){
      return 0;
    }

    String query = 'DELETE FROM Persons WHERE id = $id';
    int affectedRows = await DBProvider.db.delete(query);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int personId = prefs.getInt('personId') ?? 0;

    if(personId == id){
      await prefs.setInt('personId', 0);
    }

    return affectedRows;
  }

  //para autenticarse con usuario y contraseña; en caso de éxito se actualiza
  //el token y su fecha (para resetear su vigencia)
  Future<Person> getItem({@required String login, @required String password}) async {
    String query = 'SELECT * FROM Persons '
        'WHERE login = "$login" AND password = "$password"';

    var resultado = await DBProvider.db.getFirstRow(query);

    Person instance;
    if(resultado != null){
      instance = await _updateToken(Person.fromMap(resultado));
    } else {
      instance = Person(id: 0);
    }

    return instance;
  }

  //para recuperar el último usuario logueado vía NSUserDefaults/SharedPreferences
  Future<Person> getItemFromRepository() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int personId = prefs.getInt('personId') ?? 0;

    if(personId <= 0){
      return Person(id: 0);
    }

    String query = 'SELECT * FROM Persons WHERE id = $personId';

    var resultado = await DBProvider.db.getFirstRow(query);

    Person instance;
    if(resultado != null){
      instance = await _updateToken(Person.fromMap(resultado));

    } else {
      instance = Person(id: 0);
      await _closeAllSessions();
    }

    return instance;
  }

  //recupera las personas registradas como contacto del usuario logueado
  Future<List<Person>> getContacts(int id) async {
    String query = 'SELECT * FROM Persons WHERE contactID = "$id" ORDER BY names';

    var resultado = await DBProvider.db.getRows(query);

    List<Person> list;

    if(resultado != null){
      list = resultado.isNotEmpty
          ? resultado.map((c) => Person.fromMap(c)).toList()
          : [];
    } else {
      list = [];
    }

    return list;
  }

  Future<void> logout(Person item) async {
    await _closeAllSessions();
  }

  Future<void> _closeAllSessions({int personId = 0}) async {
    String query = 'UPDATE Persons SET token = "", tokenUpdate = "$defaultStrDateTime,"';
    int affectedRows = await DBProvider.db.update(query);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('personId', personId);

    return affectedRows;
  }

  Future<Person> _updateToken(Person item) async {
    await _closeAllSessions(personId: item.id);

    item.token = Uuid().v1();
    item.tokenUpdate = DateTime.now();

    await update(item);

    return item;
  }
}
