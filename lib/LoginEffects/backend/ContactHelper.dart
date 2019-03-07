import 'package:learning_flutter/LoginEffects/model/exports.dart';

import 'package:learning_flutter/LoginEffects/backend/exports.dart';

class ContactHelper {

  Future<Contact> addUpload(Contact item) async {
    //todo vía webservice hacer el alta y el response grabarlo localmente
    Contact returnedItem = item;

    if(!existRegister(returnedItem)){
      return _defaultContact(returnedItem);
    }

    int affectedRows = await _add(returnedItem);

    return affectedRows > 0 ? returnedItem : _dbErrorContact();
  }

  Future<Contact> updateUpload(Contact item) async {
    //todo vía webservice

    Contact returnedItem = item;
    if(!existRegister(returnedItem)){
      return _defaultContact(returnedItem);
    }


    int affectedRows = await _update(returnedItem);

    return affectedRows > 0 ? returnedItem : _dbErrorContact();
  }

  Future<Contact> deleteUpload(Contact item) async {
    //todo vía webservice

    Contact returnedItem = Contact();
    if(!existRegister(returnedItem)){
      return _defaultContact(returnedItem);
    }


    int affectedRows = await _delete(returnedItem.serverId);

    return affectedRows > 0 ? returnedItem : _dbErrorContact();
  }

  Future<int> deleteAll() async {
    String query = 'DELETE FROM Contacts';
    int affectedRows = await DBProvider.db.delete(query);

    return affectedRows;
  }

  Future<int> deleteOfPerson(String idPerson) async {
    if(idPerson == null || idPerson == ''){
      return 0;
    }

    String query = 'DELETE FROM Contacts WHERE idPerson = "$idPerson"';
    int affectedRows = await DBProvider.db.delete(query);

    return affectedRows;
  }

  Future<Contact> getItem(String id) async {
    String query = 'SELECT * FROM Contacts WHERE serverId = "$id"';

    var result = await DBProvider.db.getFirstRow(query);

    Contact instance;
    if(result != null){
      instance = Contact.fromMap(result);
      if(existRegister(instance)){
        instance.numbers = await KeyNumbersHelper().getNumbersPersonContact(appInstance.user, instance);
      }
    } else {
      instance = Contact();
    }

    return instance;
  }

  Future<int> _add(Contact item) async {
    String query = 'INSERT INTO Contacts VALUES('
        '"${item.serverId}",'
        '"${item.idPerson}",'
        '"${item.firstName1}",'
        '${item.firstName2 == null ? null : '\"${item.firstName2}\"'},'
        '"${item.lastName1}",'
        '${item.lastName2 == null ? null : '\"${item.lastName2}\"'},'
        '"${dateTimeToIso8601(item.birthDate)}",'
        '"${item.picture}")';

    int lastId = await DBProvider.db.add(query);

    return lastId;
  }

  Future<int> _update(Contact item) async {
    String query = 'UPDATE Contacts SET '
        'firstName1 = "${item.firstName1}",'
        'firstName2 = ${item.firstName2 == null ? null : '\"${item.firstName2}\"'},'
        'lastName1 = "${item.lastName1}",'
        'lastName2 = ${item.lastName2 == null ? null : '\"${item.lastName2}\"'},'
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

    String query = 'DELETE FROM Contacts WHERE id = "$id"';
    int affectedRows = await DBProvider.db.delete(query);

    return affectedRows;
  }

  Future<List<Contact>> getItemsList(String idPerson) async {
    if(idPerson == null || idPerson == ''){
      return [];
    }

    String query = 'SELECT * FROM Contacts WHERE idPerson = "$idPerson" ORDER BY lastName1, firstName1';

    var result = await DBProvider.db.getRows(query);

    List<Contact> list;

    if(result != null){
      list = result.isNotEmpty
          ? result.map((c) => Contact.fromMap(c)).toList()
          : [];
    } else {
      list = [];
    }

    return list;
  }

  Contact _defaultContact(Contact originalInstance){
    if(originalInstance == null){
      return Contact(message: "Undefined error", status: -1);
    }

    String message;
    int status;

    if(originalInstance.message == null || originalInstance.message == ''){
      message = "Contact: No error message";
    } else {
      message = originalInstance.message;
    }

    if(originalInstance.status == null){
      status = -1;
    } else {
      status = originalInstance.status;
    }


    return Contact(message: message, status: status);
  }

  Contact _dbErrorContact([String errorMessage='']){
    if(errorMessage == null || errorMessage == ''){
      return Contact(message: errorMessage, status: -1);
    }

    return Contact(message: "Undefined local DB error", status: -1);
  }
}
