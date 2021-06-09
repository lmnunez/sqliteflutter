import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqliteflutter/PersonaModel.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE Persona ("
              "id INTEGER PRIMARY KEY,"
              "nombre TEXT,"
              "correo TEXT,"
              "telefono TEXT"
              ")");
        });
  }

  newPersona(Persona newPersona) async {
    final db = await database;


    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Persona");
    int id = table.first["id"];
    var raw = await db.rawInsert(
        "INSERT Into Persona (id,nombre,correo,telefono)"
            " VALUES (?,?,?,?)",
        [id, newPersona.nombre, newPersona.correo, newPersona.telefono]);
    return raw;
  }



  updatePersona(Persona newPersona) async {
    final db = await database;
    var res = await db.update("Persona", newPersona.toMap(),
        where: "id = ?", whereArgs: [newPersona.id]);
    return res;
  }
  Future<bool> existsPersona(Persona newPersona) async {
    final db = await database;
    var res = await db.query("Persona", where: "correo = ?", whereArgs: [newPersona.correo]);
    return res.isNotEmpty ? true : false;
  }
  getPersona(int id) async {
    final db = await database;
    var res = await db.query("Persona", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Persona.fromMap(res.first) : null;
  }



  Future<List<Persona>> getAllPersonas() async {
    final db = await database;
    var res = await db.query("Persona");
    List<Persona> list =
    res.isNotEmpty ? res.map((c) => Persona.fromMap(c)).toList() : [];
    return list;
  }

  deletePersona(int id) async {
    final db = await database;
    return db.delete("Persona", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Persona");
  }
}