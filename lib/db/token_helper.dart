import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../models/token.dart';

class TokenHelper {
  static final TokenHelper _instance = new TokenHelper.internal();
  factory TokenHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  TokenHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "plmplus.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Token(id INTEGER PRIMARY KEY, account TEXT, name TEXT,token TEXT,identity Int)");
    print("Created tables");
  }

  Future<int> save(Token token) async {
    var dbClient = await db;
    int res = await dbClient.insert("Token", token.toMap());
    print(res);
    return res;
  }

  Future<Token> get() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(
      'Token',
      columns: ['id', 'account', 'name', 'token', 'identity'],
      orderBy: 'id desc ',
      limit: 1,
    );

    if (maps.length > 0) {
      return new Token.map(maps.first);
    }

    return null;
  }

  Future<int> delete() async {
    var dbClient = await db;
    int res = await dbClient.delete("Token");
    return res;
  }
}
