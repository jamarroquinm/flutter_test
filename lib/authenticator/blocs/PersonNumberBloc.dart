import 'dart:async';

import 'package:learning_flutter/authenticator/models/PersonNumber.dart';
import 'package:learning_flutter/authenticator/backend/Database.dart';

class PersonBloc {
  final _itemListController = StreamController<List<PersonNumber>>.broadcast();
  final _itemController = StreamController<PersonNumber>.broadcast();
  final _numValueController = StreamController<int>.broadcast();

  Stream get itemList => _itemListController.stream;
  Stream get item => _itemController.stream;
  Stream get numValueController => _numValueController.stream;

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

  void addBulk(List<PersonNumber> items) async {

    List<PersonNumber> savedItems;
    int affectedRows = 0;

    for(PersonNumber item in items){

    }

    String query = 'INSERT INTO PersonsNumbers VALUES('
        '"${item.personId}",'
        '"${item.numberId}",'
        '${item.value})';

    int lastId = await DBProvider.db.add(query);

    PersonNumber newInstance;
    if(lastId > 0){
      newInstance = item;
    } else {
      newInstance = PersonNumber(personId: 0, numberId: 0);
    }

    _itemController.sink.add(newInstance);
  }

  void update(PersonNumber item) async {
    String query = 'UPDATE PersonsNumbers SET'
        'value = "${item.value}",'
        'WHERE personId = ${item.personId} AND numberId = ${item.numberId})';

    int lastId = await DBProvider.db.update(query);

    _numValueController.sink.add(lastId);
  }

  void deleteAll() async {
    String query = 'DELETE FROM PersonsNumbers';

    int lastId = await DBProvider.db.delete(query);

    _numValueController.sink.add(lastId);
  }

  void deleteAllPerson(int personId) async {
    String query = 'DELETE FROM PersonsNumbers WHERE personId = $personId';

    int lastId = await DBProvider.db.delete(query);

    _numValueController.sink.add(lastId);
  }


  void getItem(String login, String password) async {
    String query = 'SELECT * FROM Persons '
        'WHERE login = "$login" AND password = "$password"';

    var resultado = await DBProvider.db.getFirstRow(query);

    Person instance;
    if(resultado != null){
      instance = Person.fromMap(resultado);
    } else {
      instance = Person(id: 0);
    }
    _itemController.sink.add(instance);
  }

  void dispose() {
    _itemListController.close();
    _itemController.close();
    _numValueController.close();
  }
}
