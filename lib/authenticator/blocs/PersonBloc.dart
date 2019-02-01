import 'dart:async';

import 'package:learning_flutter/authenticator/models/Person.dart';
import 'package:learning_flutter/authenticator/backend/Database.dart';

class PersonBloc {
  final _itemListController = StreamController<List<Person>>.broadcast();
  final _itemController = StreamController<Person>.broadcast();
  final _numValueController = StreamController<int>.broadcast();

  Stream get itemList => _itemListController.stream;
  Stream get item => _itemController.stream;
  Stream get numValueController => _numValueController.stream;

  void add(Person item) async {
    String query = 'INSERT INTO Persons VALUES('
        '"${item.id}",'
        '"${item.login}",'
        '"${item.password}",'
        '"${item.names}",'
        '"${item.lastName1}",'
        '"${item.lastName2}",'
        '${item.birthDate},'
        '${item.flag})';

    int lastId = await DBProvider.db.add(query);

    Person newInstance;
    if(lastId > 0){
      newInstance = item;
    } else {
      newInstance = Person(id: 0);
    }

    _itemController.sink.add(newInstance);
  }

  void update(Person item) async {
    String query = 'UPDATE Persons SET'
        'login = "${item.login}",'
        'password = "${item.password}",'
        'names = "${item.names}",'
        'lastName1 = "${item.lastName1}",'
        'lastName2 = "${item.lastName2}",'
        'birthDate = ${item.birthDate},'
        'flag = ${item.flag}'
        'WHERE id = ${item.id})';

    int lastId = await DBProvider.db.update(query);

    _numValueController.sink.add(lastId);
  }

  void deleteAll() async {
    String query = 'DELETE FROM Persons';

    int lastId = await DBProvider.db.delete(query);

    _numValueController.sink.add(lastId);
  }

  void delete(int id) async {
    String query = 'DELETE FROM Persons WHERE id = $id';

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
