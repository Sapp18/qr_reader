import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_reader/models/models.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    //Path de donde almacenaremos la base de datos
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //La extension es importante ya que es la estension de SQLite
    final path = join(documentsDirectory.path, 'ScansDB.db');
    print(path);
    //Crear DB
    //Cuando se haga un cambio en la DB, se necesita incrementar el version
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      //las comillas triples es un string multilínea
      await db.execute('''
        CREATE TABLE Scans(
          id INTEGER PRIMARY KEY,
          tipo TEXT,
          valor TEXT
        );
      ''');
    });
  }

  Future<int> nuevoScanRaw(ScanModel nuevoScan) async {
    final id = nuevoScan.id;
    final tipo = nuevoScan.tipo;
    final valor = nuevoScan.valor;
    //Verificar la DB
    final db = await database;
    //Haciendo la consulta para insertar
    final res = await db.rawInsert('''
      INSERT INTO Scans (id, tipo, valor)
      VALUES($id, $tipo, $valor);
    ''');
    return res;
  }

  Future<int> nuevoScan(ScanModel nuevoScan) async {
    //Verificar la DB
    final db = await database;
    //Haciendo la consulta para insertar
    final res = await db.insert(
      'Scans',
      nuevoScan.toJson(),
    );
    print("Id del ultimo registro: $res");
    return res;
  }

  Future<ScanModel?> getScanById(int id) async {
    //Verificar la DB
    final db = await database;
    //Haciendo la consulta para buscar un registro por id
    final res = await db.query(
      'Scans',
      where: 'id = ?',
      whereArgs: [id],
    );
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>?> getTodosLosScans() async {
    //Verificar la DB
    final db = await database;
    //Haciendo la consulta para obtener todos los registros
    final res = await db.query('Scans');
    return res.isNotEmpty ? res.map((s) => ScanModel.fromJson(s)).toList() : [];
  }

  Future<List<ScanModel>?> getScansPorTipo(String tipo) async {
    //Verificar la DB
    final db = await database;
    //Haciendo la consulta para obtener los registros por tipo
    final res = await db.rawQuery('''
      SELECT * FROM Scans WHERE tipo = '$tipo';
    ''');
    return res.isNotEmpty ? res.map((s) => ScanModel.fromJson(s)).toList() : [];
  }

  Future<int> updateScan(ScanModel nuevoScan) async {
    //Verificar la DB
    final db = await database;
    //Haciendo la consulta para actualizar un scan
    final res = await db.update(
      'Scans',
      nuevoScan.toJson(),
      where: 'id = ?',
      whereArgs: [nuevoScan.id],
    );
    return res;
  }

  Future<int> deleteScan(int id) async {
    //Verificar la DB
    final db = await database;
    //Haciendo la consulta para borrar un scan por id
    final res = await db.delete(
      'Scans',
      where: 'id = ?',
      whereArgs: [id],
    );
    return res;
  }

  Future<int> deleteTodosScan() async {
    //Verificar la DB
    final db = await database;
    //Haciendo la consulta para borrar todos los scans
    final res = await db.delete('Scans');
    return res;
  }
}
