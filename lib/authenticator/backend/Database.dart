import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

//un singleton para recuperar siempre la misma instancia de la DB
class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _database;
  static final int version = 1;
  static final String dbName = 'Autheticator.db';

  //si no existe la DB, se invoca el proceso de creación
  Future<Database> get database async {
    if (_database != null)
      return _database;

    _database = await initDB();
    return _database;
  }


  /*
  aquí se crea la DB; en iOS: 'NSDocumentsDirectory' API; en Android, folder
  AppData.
  openDatabase abre en este orden los callbacks opcionales:
    - onConfigure
    - onCreate, onUpgrade o onDowngrade
    - onOpen
  Otros dos parámetros opcionales son readOnly (default false) y singleInstance
  (default true)
  */
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);

    return await openDatabase(
        path,
        version: version,
        onConfigure: _onConfigure,  //opcional
        onCreate: _onCreate,        //opcional
        onUpgrade: _onUpgrade,      //opcional
        onDowngrade: _onDowngrade,  //opcional
        onOpen: (db) { },           //opcional
    );
  }

  void _onConfigure(Database db) {
    //permite agregar configuraciones, por ejemplo habilitar FK
  }

  void _onCreate(Database db, int version) async {
    _CreationQueries.getCreationQueries().forEach((q) => _executeQuery(db, q));
    _CreationQueries.getInsertionQueries().forEach((q) => _executeQuery(db, q));
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    //code para cuando se modifique la db y haya que subir de versión
  }

  void _onDowngrade(Database db, int oldVersion, int newVersion) {
    //code para cuando se modifique la db y haya que volver a versión anterior
  }

  void _executeQuery(Database db, String statement) async {
    await db.execute(statement);
  }


  //devuelve el último id insertado
  Future<int> add(String query, [List<dynamic> arguments]) async {
    final db = await database;
    var result = await db.rawInsert(query, arguments);

    return result;
  }

  //devuelve el número de registros afectados
  Future<int> update(String query, [List<dynamic> arguments]) async {
    final db = await database;
    var result = await db.rawUpdate(query, arguments);
    return result;
  }

  //devuelve el número de registros afectados
  Future<int> delete(String query, [List<dynamic> arguments]) async {
    final db = await database;
    var result = await db.rawDelete(query, arguments);

    return result;
  }

  //devuelve el primer registro de la lista que satisface el query
  Future<Map<String, dynamic>> getFirstRow(String query, [List<dynamic> arguments]) async {
    final db = await database;
    var resultado = await db.rawQuery(query, arguments);

    return resultado.isNotEmpty ? resultado.first : null;
  }

  //devuelve la lista de registros que satisfacen el query
  Future<List<Map>> getRows(String query, [List<dynamic> arguments]) async {
    final db = await database;
    var resultado = await db.rawQuery(query, arguments);

    return resultado;
  }
}

class _CreationQueries{
  static final String _personsCreationQuery = 'CREATE TABLE Persons ('
      'id INTEGER PRIMARY KEY,'
      'login TEXT,'
      'password,'
      'names TEXT,'
      'lastName1 TEXT,'
      'lastName2 TEXT,'
      'birthDate INTEGER,'
      'flag INTEGER'
      ')';

  static final String _numbersCreationQuery = 'CREATE TABLE Numbers ('
      'id INTEGER PRIMARY KEY,'
      'letter TEXT,'
      'esLabel TEXT,'
      'enLabel TEXT'
      ')';

  static final String _personsNumbersCreationQuery = 'CREATE TABLE PersonsNumbers ('
      'personId INTEGER,'
      'numberId INTEGER,'
      'value INTEGER,'
      'PRIMARY KEY(personId, numberId)'
      ')';

  static final List<String> _numbersInsertionQuery =
      ['INSERT INTO Numbers VALUES(1, "A", "Número A", "Number A")',
      'INSERT INTO Numbers VALUES(2, "B", "Número B", "Number B")',
      'INSERT INTO Numbers VALUES(3, "C", "Número C", "Number C")',
      'INSERT INTO Numbers VALUES(4, "D", "úmero D", "Number D")',
      'INSERT INTO Numbers VALUES(5, "E", "Número E", "Number E")',
      'INSERT INTO Numbers VALUES(6, "F", "Número F", "Number F")',
      'INSERT INTO Numbers VALUES(7, "G", "Número G", "Number G")',
      'INSERT INTO Numbers VALUES(8, "H", "Número H", "Number H")',
      'INSERT INTO Numbers VALUES(9, "I", "Número I", "Number I")',
      'INSERT INTO Numbers VALUES(10, "J", "Número J", "Number J")',
      'INSERT INTO Numbers VALUES(11, "K", "Número K", "Number K")',
      'INSERT INTO Numbers VALUES(12, "L", "Número L", "Number L")',
      'INSERT INTO Numbers VALUES(13, "M", "Número M", "Number M")',
      'INSERT INTO Numbers VALUES(14, "N", "Número N", "Number N")',
      'INSERT INTO Numbers VALUES(15, "O", "Número O", "Number O")',
      'INSERT INTO Numbers VALUES(16, "P", "Número P", "Number P")',
      'INSERT INTO Numbers VALUES(17, "Q", "Número Q", "Number Q")',
      'INSERT INTO Numbers VALUES(18, "R", "Número R", "Number R")',
      'INSERT INTO Numbers VALUES(19, "S", "Número S", "Number S")',
      'INSERT INTO Numbers VALUES(20, "T", "Número T", "Number T")',
      'INSERT INTO Numbers VALUES(21, "U", "Número U", "Number U")',
      'INSERT INTO Numbers VALUES(22, "V", "Número V", "Number V")',
      'INSERT INTO Numbers VALUES(23, "W", "Número W", "Number W")',
      'INSERT INTO Numbers VALUES(24, "X", "Número X", "Number X")',
      'INSERT INTO Numbers VALUES(25, "Y", "Número Y", "Number Y")',
      'INSERT INTO Numbers VALUES(26, "Z", "Número Z", "Number Z")'];


  static List<String> getCreationQueries(){
    return [_personsCreationQuery,
            _numbersCreationQuery,
            _personsNumbersCreationQuery,
           ];
  }

  static List<String> getInsertionQueries(){
    List<String> queries = [];
    queries.addAll(_numbersInsertionQuery);

    return queries;
  }
}