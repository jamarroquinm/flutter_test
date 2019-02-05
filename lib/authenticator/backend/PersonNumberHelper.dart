import 'dart:async';

import 'package:learning_flutter/authenticator/backend/Database.dart';
import 'package:learning_flutter/authenticator/models/PersonNumber.dart';

class PersonNumberBloc {
  Future<PersonNumber> _add(PersonNumber item) async {
    String query = 'INSERT INTO PersonsNumbers VALUES('
        '"${item.personId}",'
        '"${item.numberId}",'
        '${item.value})';

    int lastId = await DBProvider.db.add(query);

    PersonNumber newInstance;
    if(lastId > 0){
      newInstance = item;
    } else {
      newInstance = PersonNumber(personId: 0, numberId: 0, value: -1);
    }

    return newInstance;
  }

  Future<List<PersonNumber>> addBulk(List<PersonNumber> items) async {

    List<PersonNumber> savedItems;

    for(PersonNumber item in items){
      PersonNumber savedItem = await _add(item);
      savedItems.add(savedItem);
    }

    return savedItems;
  }

  Future<int> update(PersonNumber item) async {
    String query = 'UPDATE PersonsNumbers SET'
        'value = "${item.value}",'
        'WHERE personId = ${item.personId} AND numberId = ${item.numberId})';

    int affectedRows = await DBProvider.db.update(query);

    return affectedRows;
  }

  Future<int> deleteAll() async {
    String query = 'DELETE FROM PersonsNumbers';

    int affectedRows = await DBProvider.db.delete(query);

    return affectedRows;
  }

  Future<int> deleteAllPerson(int personId) async {
    String query = 'DELETE FROM PersonsNumbers WHERE personId = $personId';

    int affectedRows = await DBProvider.db.delete(query);

    return affectedRows;
  }

  Future<PersonNumber> getItem(int personId, int numberId) async {
    String query = 'SELECT * FROM PersonsNumbers '
        'WHERE personId = $personId AND numberId = $numberId';

    var resultado = await DBProvider.db.getFirstRow(query);

    PersonNumber instance;
    if(resultado != null){
      instance = PersonNumber.fromMap(resultado);
    } else {
      instance = PersonNumber(personId: 0, numberId: 0, value: 0);
    }

    return instance;
  }

  Future<List<PersonNumber>> getItemsList(int personId) async {
    String query = 'SELECT * FROM PersonsNumbers WHERE personId = $personId'
        ' ORDER BY numberId';

    var resultado = await DBProvider.db.getRows(query);

    List<PersonNumber> list;

    if(resultado != null){
      list = resultado.isNotEmpty
          ? resultado.map((c) => PersonNumber.fromMap(c)).toList()
          : [];
    } else {
      list = [];
    }

    return list;
  }
}
