import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:learning_flutter/DBBasics/models/ClientModel.dart';

//un singleton para recuperar siempre la misma instancia de la DB
class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }


  //aquí se crea la DB TestDB.db con una tabla (Client) en la carpeta de
  // documentos de la aplicación
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");

    return await openDatabase(
        path,
        version: 1,
        onOpen: (db) { },
        onCreate: (Database db, int version) async {
          await db.execute(
            "CREATE TABLE Client ("
            "id INTEGER PRIMARY KEY,"
            "first_name TEXT,"
            "last_name TEXT,"
            "blocked INTEGER"
            ")"
          );
        }
    );
  }

  //realiza una inserción inyectando un query con rawInsert
  newClient(Client newClient) async {
    final db = await database;

    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id) + 1 as id FROM Client");
    int id = table.first["id"];

    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Client (id, first_name, last_name, blocked)"
            " VALUES (?,?,?,?)",
        [id, newClient.firstName, newClient.lastName, newClient.blocked]);

    //return raw;
  }

  //busca un cliente en particular en la tabla Client pasando el id con whereArgs
  //se devuelve el primer registro de la lista o null si ésta está vacía
  getClient(int id) async {
    final db = await database;
    var res = await db.query("Client", where: "id = ?", whereArgs: [id]);

    return res.isNotEmpty ? Client.fromMap(res.first) : null;
  }

  //recupera todos los registros de Client y los mapea a una List
  Future<List<Client>> getAllClients() async {
    final db = await database;
    var res = await db.query("Client");
    List<Client> list = res.isNotEmpty
                        ? res.map((c) => Client.fromMap(c)).toList()
                        : [];

    return list;
  }

  //recupera una List de la tabla Client en los que blocked = 1; alternativamente
  //puede usarse un query explícito así:
  //  var res = await db.rawQuery("SELECT * FROM Client WHERE blocked=1");
  Future<List<Client>> getBlockedClients() async {
    final db = await database;
    var res = await db.query("Client", where: "blocked = ? ", whereArgs: [1]);
    res = await db.rawQuery("SELECT * FROM Client WHERE blocked=1");
    List<Client> list = res.isNotEmpty
                        ? res.map((c) => Client.fromMap(c)).toList()
                        : [];

    return list;
  }

  //actualización de un registro en Client con cierto id
  updateClient(Client newClient) async {
    final db = await database;
    var res = await db.update("Client", newClient.toMap(),
        where: "id = ?", whereArgs: [newClient.id]);
    return res;
  }

  //otra actualización, en la que se deja a este método modificar los atributos
  //de la instancia Client antes de pasarla al método update de la db
  blockOrUnblock(Client client) async {
    final db = await database;
    Client blocked = Client(
        id: client.id,
        firstName: client.firstName,
        lastName: client.lastName,
        blocked: !client.blocked);
    var res = await db.update("Client", blocked.toMap(),
        where: "id = ?", whereArgs: [client.id]);
    return res;
  }

  //borra un registro en Client con cierto valor en el campo id
  deleteClient(int id) async {
    final db = await database;
    return db.delete("Client", where: "id = ?", whereArgs: [id]);
  }

  //borra todos los registros de la tabla Client
  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete FROM Client");
  }

  //borra el último registro en Client, que es aquel con el id mayor
  deleteLast() async {
    final db = await database;
    return db.rawDelete("DELETE FROM Client WHERE id = (SELECT MAX(id) FROM Client)");
  }

  //borra el primer registro en Client, que es aquel con el id menor
  deleteFirst() async {
    final db = await database;
    return db.rawDelete("DELETE FROM Client WHERE id = (SELECT MIN(id) FROM Client)");
  }
}