import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'CatalogDataTest.dart' as test;

//un singleton para recuperar siempre la misma instancia de la DB
class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _database;
  static final int version = 1;
  static final String dbName = 'Authenticator.db';

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
    - onCreate, onUpgrade o onDowngrade (que son mutuamente exclusivos)
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

  //se invoca cuando se está creando la base de datos para iniciar la ejecución
  //de los queries de creación y llenado de catálogos iniciales
  void _onCreate(Database db, int version) async {
    _executeCreation(db, false);
    String t = "testing stop...";
  }

  //se invoca cuando el número de versión es mayor que el actual para iniciar la
  // ejecución de que actualizan parte o toda la estructura de las tablas y
  // parte o todos los datos de catálogos iniciales; puede implicar hacer drops
  // de las tablas existentes
  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    _executeCreation(db, true);
    String t = "testing stop...";
  }

  //similar a _onUpgrade() pero cuando el número de versión es menor que el actual
  void _onDowngrade(Database db, int oldVersion, int newVersion) {
    _executeCreation(db, true);
    String t = "testing stop...";
  }

  //auxiliar de _onCreate(), _onUpgrade() y _onDowngrade() para hacer el loop de
  //las listas de queries que deben ejecutarse
  void _executeCreation(Database db, bool includeDrops) async {
    if(includeDrops){
      _CreationQueries.getDropQueries().forEach((q) => _executeCreationAux(db, q));
    }
    _CreationQueries.getCreationQueries().forEach((q) => _executeCreationAux(db, q));
    _CreationQueries.getInsertionQueries().forEach((q) => _executeCreationAux(db, q));
  }

  //se ejecuta por cada query de los loops de _executeCreation()
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
  static final String _personsCreationQuery =
      'CREATE TABLE IF NOT EXISTS Persons ('
      'id INTEGER PRIMARY KEY,'
      'userName TEXT not null,'
      'password TEXT not null,'
      'firstName1 TEXT not null,'
      'firstName2 TEXT,'
      'lastName1 TEXT not null,'
      'lastName2 TEXT,'
      'birthDate TEXT not null,'
      'token TEXT,'
      'tokenUpdate TEXT,'
      'contactId INTEGER,'
      'flag INTEGER'
      ')';

  static final String _personsDropQuery = 'DROP TABLE IF EXISTS Persons';


  static final String _numbersCreationQuery = 'CREATE TABLE Numbers ('
      'id INTEGER PRIMARY KEY,'
      'letter TEXT not null,'
      'esName TEXT,'
      'esDescription TEXT,'
      'enName TEXT,'
      'enDescription TEXT'
      ')';

  static final String _numbersDropQuery = 'DROP TABLE IF EXISTS Numbers';


  static final String _personsNumbersCreationQuery = 'CREATE TABLE PersonsNumbers ('
      'personId INTEGER not null,'
      'numberId INTEGER not null,'
      'value INTEGER not null,'
      'FOREIGN KEY(personId) REFERENCES Persons,'
      'FOREIGN KEY(numberId) REFERENCES Numbers,'
      'PRIMARY KEY (personId, numberId)'
      ')';

  static final String _personsNumbersDropQuery = 'DROP TABLE IF EXISTS PersonsNumbers';


  static final List<String> _numbersInsertionQuery =
      ['INSERT INTO Numbers VALUES(1, "A", '
          '"Número del karma", "Día de nacimiento", '
          '"Karma number", "Day of birth")',
      'INSERT INTO Numbers VALUES(2, "B", '
          '"Número personal", "Esencia de la persona", '
          '"Personal number", "Essence of the person")',
      'INSERT INTO Numbers VALUES(3, "C", '
          '"Año de nacimiento", "Número de la vida pasada", '
          '"Year of birth", "Past life number")',
      'INSERT INTO Numbers VALUES(4, "D", '
          '"Número de la personalidad", "La máscara", '
          '"Personality number", "The mask")',
      'INSERT INTO Numbers VALUES(5, "E", '
          '"Número E", "Número E", '
          '"Number E", "Number E")',
      'INSERT INTO Numbers VALUES(6, "F", '
          '"Número F", "Número F", '
          '"Number F", "Number F")',
      'INSERT INTO Numbers VALUES(7, "G", '
          '"Número G", "Número G", '
          '"Number G", "Number G")',
      'INSERT INTO Numbers VALUES(8, "H", '
          '"Número del destino", "Número del propósito y resultado", '
          '"Purpose number", "Purpose and result number")',
      'INSERT INTO Numbers VALUES(9, "I", '
          '"Número del subconsciente", "El sexto sentido", '
          '"Subconscious number", "The sixth sense")',
      'INSERT INTO Numbers VALUES(10, "J", '
          '"Número del inconsciente", "Número de la pareja", '
          '"Unconscious number", "Number of the couple")',
      'INSERT INTO Numbers VALUES(11, "K", '
          '"Número K", "Número K", '
          '"Number K", "Number K")',
      'INSERT INTO Numbers VALUES(12, "L", '
          '"Número L", "Número L", '
          '"Number L", "Number L")',
      'INSERT INTO Numbers VALUES(13, "M", '
          '"Número M", "Número M", '
          '"Number M", "Number M")',
      'INSERT INTO Numbers VALUES(14, "N", '
          '"Número N", "Número N", '
          '"Number N", "Number N")',
      'INSERT INTO Numbers VALUES(15, "O", '
          '"Número O", "Número O", '
          '"Number O", "Number O")',
      'INSERT INTO Numbers VALUES(16, "P", '
          '"Número superoculto", "Número superoculto", '
          '"Super hidden number", "Super hidden number")',
      'INSERT INTO Numbers VALUES(17, "Q", '
          '"Número oculto", "Número oculto Q", '
          '"Hidden number", "Hidden number Q")',
      'INSERT INTO Numbers VALUES(18, "R", '
          '"Número oculto", "Número oculto R", '
          '"Hidden number", "Hidden number R")',
      'INSERT INTO Numbers VALUES(19, "S", '
          '"Número oculto", "Número oculto S", '
          '"Hidden number", "Hidden number S")',
      'INSERT INTO Numbers VALUES(20, "T", '
          '"Número T", "Número T", '
          '"Number T", "Number T")',
      'INSERT INTO Numbers VALUES(21, "U", '
          '"Número U", "Número U", '
          '"Number U", "Number U")',
      'INSERT INTO Numbers VALUES(22, "V", '
          '"Número V", "Número V", '
          '"Number V", "Number V")',
      'INSERT INTO Numbers VALUES(23, "W", '
          '"Número W", "Número W", '
          '"Number W", "Number W")',
      'INSERT INTO Numbers VALUES(24, "X", '
          '"Número X", "Número X", '
          '"Number X", "Number X")',
      'INSERT INTO Numbers VALUES(25, "Y", '
          '"Número Y", "Número Y", '
          '"Number Y", "Number Y")',
      'INSERT INTO Numbers VALUES(26, "Z", '
          '"Número Z", "Número Z", '
          '"Number Z", "Number Z")'
      ];


  static List<String> getCreationQueries(){
    return [
      _personsCreationQuery,
      _numbersCreationQuery,
      _personsNumbersCreationQuery,
    ];
  }

  static List<String> getDropQueries(){
    return [
      _personsNumbersDropQuery,
      _numbersDropQuery,
      _personsDropQuery,
    ];
  }

  static List<String> getInsertionQueries(){
    List<String> queries = [];
    queries.addAll(_numbersInsertionQuery);
    queries.addAll(test.CatalogDataTest.personsInsertionQuery);

    return queries;
  }
}