import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../model/form.dart';

class DBHelper {
  static Database? _db;
  static const String ID = 'id';
  static const String SCHEMAID = 'schemaId';
  static const String SYNCED = 'synced';
  static const String DATA = 'data';
  static const String SCHEMA = 'schema';
  static const String FORMNAME = 'formName';
  static const String DATE = 'date';
  static const String TABLE = 'form_data';
  static const String DB_NAME = 'data_from.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $SCHEMAID TEXT, $SYNCED INTEGER, $DATA TEXT, $SCHEMA TEXT, $FORMNAME TEXT, $DATE TEXT)");
  }

  Future<OfflineFormData> save(OfflineFormData offlineFormData) async {
    var dbClient = await db;
    offlineFormData.id = await dbClient.insert(TABLE, offlineFormData.toMap());
    return offlineFormData;
  }

  Future<List<OfflineFormData>> getOfflineFormData() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE,
        columns: [ID, SCHEMAID, SYNCED, DATA, SCHEMA, FORMNAME, DATE],
        orderBy: "$ID DESC");
    List<OfflineFormData> offlineFormDataList = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        offlineFormDataList.add(OfflineFormData.fromMap(maps[i]));
      }
    }
    return offlineFormDataList;
  }

  Future<List<OfflineFormData>> getOfflineOfflineFormData(
      String schemaId) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        'SELECT * FROM $TABLE WHERE SYNCED=0 AND $SCHEMAID = ?', [schemaId]);
    List<OfflineFormData> offlineFormDataList = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        offlineFormDataList.add(OfflineFormData.fromMap(maps[i]));
      }
    }
    return offlineFormDataList;
  }

  Future<List<OfflineFormData>> getOfflineOfflineFormDataAll() async {
    var dbClient = await db;
    List<Map> maps =
        await dbClient.rawQuery('SELECT * FROM $TABLE WHERE SYNCED=0');
//    List<Map> maps = await dbClient.rawQuery('SELECT * FROM ${TABLE}');
    List<OfflineFormData> offlineFormDataList = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        offlineFormDataList.add(OfflineFormData.fromMap(maps[i]));
      }
    }
    return offlineFormDataList;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(OfflineFormData offlineFormData) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, offlineFormData.toMap(),
        where: '$ID = ?', whereArgs: [offlineFormData.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
