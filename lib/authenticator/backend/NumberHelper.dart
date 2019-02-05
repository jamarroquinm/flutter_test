import 'dart:async';

import 'package:learning_flutter/authenticator/backend/Database.dart';
import 'package:learning_flutter/authenticator/models/Number.dart';

class NumberBloc {
  Future<Number> getItem(String letter) async {
    String query = 'SELECT * FROM Numbers WHERE letter = "$letter"';

    var resultado = await DBProvider.db.getFirstRow(query);

    Number instance;
    if(resultado != null){
      instance = Number.fromMap(resultado);
    } else {
      instance = Number(id: 0);
    }

    return instance;
  }

  Future<List<Number>> getItemsList() async {
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

    return list;
  }
}
