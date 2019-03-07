import 'package:learning_flutter/LoginEffects/model/exports.dart';

import 'Database.dart';
import 'Utils.dart';

class GroupContactHelper {

  Future<GroupContact> addUpload(GroupContact item) async {
    //todo vía webservice hacer el alta y el response grabarlo localmente
    GroupContact returnedItem = item;

    if(!existRegister(returnedItem)){
      return _defaultGroupContact(returnedItem);
    }

    int affectedRows = await _add(returnedItem);

    return affectedRows > 0 ? returnedItem : _dbErrorGroupContact();
  }

  Future<GroupContact> updateUpload(GroupContact item) async {
    //todo vía webservice

    GroupContact returnedItem = item;

    if(!existRegister(returnedItem)){
      return _defaultGroupContact(returnedItem);
    }

    int affectedRows = await _update(returnedItem);

    return affectedRows > 0 ? returnedItem : _dbErrorGroupContact();
  }

  Future<GroupContact> deleteUpload(GroupContact item) async {
    //todo vía webservice

    GroupContact returnedItem = item;

    if(!existRegister(returnedItem)){
      return _defaultGroupContact(returnedItem);
    }

    int affectedRows = await _delete(returnedItem.idGroup, returnedItem.idContact);

    return affectedRows > 0 ? returnedItem : _dbErrorGroupContact();
  }

  Future<int> deleteAll() async {
    String query = 'DELETE FROM GroupsContacts';
    int affectedRows = await DBProvider.db.delete(query);

    return affectedRows;
  }

  Future<int> deleteGroup(String idGroup) async {
    if(idGroup == null || idGroup == ''){
      return 0;
    }

    String query = 'DELETE FROM GroupsContacts WHERE idGroup = "$idGroup"';
    int affectedRows = await DBProvider.db.delete(query);

    return affectedRows;
  }

  Future<int> deleteContact(String idContact) async {
    if(idContact == null || idContact == ''){
      return 0;
    }

    String query = 'DELETE FROM GroupsContacts WHERE idContact = "$idContact"';
    int affectedRows = await DBProvider.db.delete(query);

    return affectedRows;
  }

  Future<List<Contact>> getContactsList(String idGroup) async {
    if(idGroup == null || idGroup == ''){
      return [];
    }

    String query = 'SELECT * FROM Contacts '
        'WHERE serverId IN (SELECT idContact FROM GroupsContacts '
          'WHERE idGroup = "$idGroup") '
        'ORDER BY lastName1, firstName1';

    var resultado = await DBProvider.db.getRows(query);

    List<Contact> list;

    if(resultado != null){
      list = resultado.isNotEmpty
          ? resultado.map((c) => Contact.fromMap(c)).toList()
          : [];
    } else {
      list = [];
    }

    return list;
  }

  Future<List<Group>> getGroupsList(String idContact) async {
    if(idContact == null || idContact == ''){
      return [];
    }

    String query = 'SELECT * FROM Groups '
        'WHERE serverId IN (SELECT idGroup FROM GroupsContacts '
        'WHERE idContact = "$idContact") '
        'ORDER BY name';

    var resultado = await DBProvider.db.getRows(query);

    List<Group> list;

    if(resultado != null){
      list = resultado.isNotEmpty
          ? resultado.map((c) => Group.fromMap(c)).toList()
          : [];
    } else {
      list = [];
    }

    return list;
  }

  Future<int> _add(GroupContact item) async {
    String query = 'INSERT INTO GroupsContacts VALUES('
        '"${item.serverId}",'
        '"${item.idGroup}",'
        '"${item.idContact}",'
        '${item.order})';

    int lastId = await DBProvider.db.add(query);

    return lastId;
  }

  Future<int> _update(GroupContact item) async {
    String query = 'UPDATE GroupsContacts SET '
        'order = "${item.order}" '
        'WHERE serverId = "${item.serverId}"';

    int affectedRows = await DBProvider.db.update(query);

    return affectedRows;
  }

  Future<int> _delete(String idGroup, String idContact) async {
    if(idGroup == null || idGroup == ''){
      return 0;
    }

    String query = 'DELETE FROM GroupsContacts WHERE idGroup = "$idGroup" '
        'AND idContact = "$idContact"';
    int affectedRows = await DBProvider.db.delete(query);

    return affectedRows;
  }

  GroupContact _defaultGroupContact(GroupContact originalInstance){
    if(originalInstance == null){
      return GroupContact(message: "Undefined error", status: -1);
    }

    String message;
    int status;

    if(originalInstance.message == null || originalInstance.message == ''){
      message = "GroupContact: No error message";
    } else {
      message = originalInstance.message;
    }

    if(originalInstance.status == null){
      status = -1;
    } else {
      status = originalInstance.status;
    }


    return GroupContact(message: message, status: status);
  }

  GroupContact _dbErrorGroupContact([String errorMessage='']){
    if(errorMessage == null || errorMessage == ''){
      return GroupContact(message: errorMessage, status: -1);
    }

    return GroupContact(message: "Undefined local DB error", status: -1);
  }
}
