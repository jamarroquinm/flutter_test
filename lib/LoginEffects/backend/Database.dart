import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider with _CreationQueries{
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _database;
  static final int version = 1;
  static final String dbName = 'numera_data.db';

  Future<Database> get database async {
    if (_database != null)
      return _database;

    _database = await initDB();
    return _database;
  }


  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);

    return await openDatabase(
        path,
        version: version,
        onConfigure: _onConfigure,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onDowngrade: _onDowngrade,
        onOpen: (db) { },
    );
  }

  void _onConfigure(Database db) {
    //permite agregar configuraciones, por ejemplo habilitar FK
  }

  void _onCreate(Database db, int version) async {
    _executeCreation(db, false);
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    _executeCreation(db, true);
  }

  void _onDowngrade(Database db, int oldVersion, int newVersion) {
    _executeCreation(db, true);
  }

  void _executeCreation(Database db, bool includeDrops) async {
    if(includeDrops){
      getDropQueries().forEach((q) => _executeCreationAux(db, q));
    }
    getCreationQueries().forEach((q) => _executeCreationAux(db, q));
    getInsertionQueries().forEach((q) => _executeCreationAux(db, q));
  }

  void _executeCreationAux(Database db, String statement) async {
    await db.execute(statement);
  }


  //Agrega un registro y devuelve el último id insertado
  Future<int> add(String query, [List<dynamic> arguments]) async {
    final db = await database;
    var result = await db.rawInsert(query, arguments);

    return result;
  }

  //Actualiza uno o más registros y devuelve el número de renglones afectados
  Future<int> update(String query, [List<dynamic> arguments]) async {
    final db = await database;
    var result = await db.rawUpdate(query, arguments);
    return result;
  }

  //Borra uno o más registros y devuelve el número de renglones afectados
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
  final String _countriesCreationQuery =
      'CREATE TABLE IF NOT EXISTS Countries ('
      'id INTEGER PRIMARY KEY,'
      'defaultName TEXT not null,'
      'nativeName TEXT,'
      'code TEXT not null,'
      'updated TEXT'
      ')';

  final String _countriesDropQuery = 'DROP TABLE IF EXISTS Countries';


  final String _languagesCreationQuery =
      'CREATE TABLE IF NOT EXISTS Languages ('
      'id INTEGER PRIMARY KEY,'
      'defaultName TEXT not null,'
      'nativeName TEXT,'
      'code TEXT not null,'
      'updated TEXT'
      ')';

  final String _languagesDropQuery = 'DROP TABLE IF EXISTS Languages';

  final String _personsCreationQuery =
      'CREATE TABLE IF NOT EXISTS Persons ('
      'serverId TEXT PRIMARY KEY,'
      'idCountry INTEGER not null,'
      'idLanguage INTEGER not null,'
      'firstName1 TEXT not null,'
      'firstName2 TEXT,'
      'lastName1 TEXT not null,'
      'lastName2 TEXT,'
      'birthDate TEXT not null,'
      'picture TEXT,'
      'plan TEXT,'
      'genre TEXT'
      ')';

  final String _personsDropQuery = 'DROP TABLE IF EXISTS Persons';


  final String _contactsCreationQuery =
      'CREATE TABLE IF NOT EXISTS Contacts ('
      'serverId TEXT,'
      'idPerson TEXT not null,'
      'firstName1 TEXT not null,'
      'firstName2 TEXT,'
      'lastName1 TEXT not null,'
      'lastName2 TEXT,'
      'birthDate TEXT not null,'
      'picture TEXT,'
      'type TEXT'
      ')';

  final String _contactsDropQuery = 'DROP TABLE IF EXISTS Contacts';


  final String _groupsCreationQuery =
      'CREATE TABLE IF NOT EXISTS Groups ('
      'serverId TEXT,'
      'idPerson TEXT,'
      'name TEXT not null,'
      'birthDate TEXT not null,'
      'picture TEXT'
      ')';

  final String _groupsDropQuery = 'DROP TABLE IF EXISTS Groups';


  final String _groupsContactsCreationQuery =
      'CREATE TABLE IF NOT EXISTS GroupsContacts ('
      'serverId TEXT PRIMARY KEY,'
      'idGroup TEXT,'
      'idContact TEXT,'
      'orden INTEGER'
      ')';

  final String _groupsContactsDropQuery = 'DROP TABLE IF EXISTS GroupsContacts';


  List<String> getCreationQueries(){
    return [
      _countriesCreationQuery,
      _languagesCreationQuery,
      _personsCreationQuery,
      _contactsCreationQuery,
      _groupsCreationQuery,
      _groupsContactsCreationQuery,
    ];
  }

  List<String> getDropQueries(){
    return [
      _groupsContactsDropQuery,
      _groupsDropQuery,
      _contactsDropQuery,
      _personsDropQuery,
      _languagesDropQuery,
      _countriesDropQuery,
    ];
  }

  List<String> getInsertionQueries(){
    List<String> queries = [
      'INSERT INTO Countries VALUES(1, "México", "México", "mx", "20190219T120000")',
      'INSERT INTO Countries VALUES(2, "Estados Unidos", "United States", "us", "20190219T120000")',
      'INSERT INTO Languages VALUES(1, "Español", "Español", "es", "20190219T120000")',
      'INSERT INTO Languages VALUES(2, "Inglés", "English", "en", "20190219T120000")',
    ];

    return queries;
  }
}