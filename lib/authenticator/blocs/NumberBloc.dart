import 'dart:async';

import 'package:learning_flutter/authenticator/models/Number.dart';
import 'package:learning_flutter/authenticator/backend/Database.dart';

class NumberBloc {
  final _itemListController = StreamController<List<Number>>.broadcast();
  final _itemController = StreamController<Number>.broadcast();

  Stream get itemList => _itemListController.stream;
  Stream get item => _itemController.stream;

  void getItem(String letter) async {
    String query = 'SELECT * FROM Numbers WHERE letter = "$letter"';

    var resultado = await DBProvider.db.getFirstRow(query);

    Number instance;
    if(resultado != null){
      instance = Number.fromMap(resultado);
    } else {
      instance = Number(id: 0);
    }
    _itemController.sink.add(instance);
  }

  void getItemsList(String letter) async {
    String query = 'SELECT * FROM Numbers ORDER BY letter';

    var resultado = await DBProvider.db.getRows(query);

    List<Number> list;

    if(resultado != null){
      list = resultado.isNotEmpty
          ? resultado.map((c) => Number.fromMap(c)).toList()
          : [];
    } else {
      list = [];
    }

    _itemListController.sink.add(list);
  }

  void dispose() {
    _itemListController.close();
    _itemController.close();
  }
}
