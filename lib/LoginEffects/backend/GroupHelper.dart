import 'package:learning_flutter/LoginEffects/model/exports.dart';

import 'package:learning_flutter/LoginEffects/backend/exports.dart';

class GroupHelper {

  Future<Group> addUpload(Group item) async {
    //todo vía webservice

    Group returnedItem = item;

    if(!existRegister(returnedItem)){
      return _defaultGroup(returnedItem);
    }

    int affectedRows = await _add(returnedItem);

    return affectedRows > 0 ? returnedItem : _dbErrorGroup();
  }

  Future<Group> updateUpload(Group item) async {
    //todo vía webservice

    Group returnedItem = item;

    if(!existRegister(returnedItem)){
      return _defaultGroup(returnedItem);
    }

    int affectedRows = await _update(returnedItem);

    return affectedRows > 0 ? returnedItem : _dbErrorGroup();
  }

  Future<Group> deleteUpload(Group item) async {
    //todo vía webservice

    Group returnedItem = Group();
    if(!existRegister(returnedItem)){
      return _defaultGroup(returnedItem);
    }


    int affectedRows = await _delete(returnedItem.serverId);

    return affectedRows > 0 ? returnedItem : _dbErrorGroup();
  }

  Future<int> deleteAll() async {
    String query = 'DELETE FROM Groups';
    int affectedRows = await DBProvider.db.delete(query);

    return affectedRows;
  }

  Future<int> deleteFromPerson(int idPerson) async {
    if(idPerson == null || idPerson == 0){
      return 0;
    }

    String query = 'DELETE FROM Groups WHERE idPerson = "$idPerson"';
    int affectedRows = await DBProvider.db.delete(query);

    return affectedRows;
  }

  Future<Group> getItem(String id) async {
    String query = 'SELECT * FROM Groups WHERE serverId = "$id"';

    var result = await DBProvider.db.getFirstRow(query);

    Group instance;
    if(result != null){
      instance = Group.fromMap(result);
      if(existRegister(instance)){
        instance.numbers = await KeyNumbersHelper().getNumbersPersonGroup(appInstance.user, instance);
      }
    } else {
      instance = Group();
    }

    return instance;
  }

  Future<List<Group>> getItemsList(String idPerson) async {
    if(idPerson == null || idPerson == ''){
      return [];
    }

    String query = 'SELECT * FROM Groups WHERE idPerson = "$idPerson" ORDER BY name';

    var result = await DBProvider.db.getRows(query);

    List<Group> list;

    if(result != null){
      list = result.isNotEmpty
          ? result.map((c) => Group.fromMap(c)).toList()
          : [];
    } else {
      list = [];
    }

    return list;
  }

  Future<int> _add(Group item) async {
    String query = 'INSERT INTO Contacts VALUES('
        '${item.serverId == null ? null : '\"${item.serverId}\"'},'
        '"${item.idPersona}",'
        '"${item.name}",'
        '"${dateTimeToIso8601(item.birthDate)}",'
        '"${item.picture}")';

    int lastId = await DBProvider.db.add(query);

    return lastId;
  }

  Future<int> _update(Group item) async {
    String query = 'UPDATE Contacts SET '
        'name = "${item.name}",'
        'birthDate = "${dateTimeToIso8601(item.birthDate)}",'
        'picture = "${item.picture}" '
        'WHERE serverId = "${item.serverId}"';

    int affectedRows = await DBProvider.db.update(query);

    return affectedRows;
  }

  Future<int> _delete(String id) async {
    if(id == null || id == ''){
      return 0;
    }

    String query = 'DELETE FROM Groups WHERE serverId = "$id"';
    int affectedRows = await DBProvider.db.delete(query);

    return affectedRows;
  }

  Group _defaultGroup(Group originalInstance){
    if(originalInstance == null){
      return Group(message: "Undefined error", status: -1);
    }

    String message;
    int status;

    if(originalInstance.message == null || originalInstance.message == ''){
      message = "Group: No error message";
    } else {
      message = originalInstance.message;
    }

    if(originalInstance.status == null){
      status = -1;
    } else {
      status = originalInstance.status;
    }


    return Group(message: message, status: status);
  }

  Group _dbErrorGroup([String errorMessage='']){
    if(errorMessage == null || errorMessage == ''){
      return Group(message: errorMessage, status: -1);
    }

    return Group(message: "Undefined local DB error", status: -1);
  }
}
