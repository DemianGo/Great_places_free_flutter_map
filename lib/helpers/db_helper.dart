import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;


class DBHelper {

  // acesso ao db
  static Future<sql.Database> database() async {
    // pega o local do db
    final dbPath = await sql.getDatabasesPath();
    // abre o db ou cria um qnd não encontra o .db, ai vai no onCreate, pode usar um arquivo p iniciar o db
    // pode escolher a versão do db, dentro da anonimous function temos acesso ao db
    return sql.openDatabase(path.join(dbPath, 'places.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)');
    }, version: 1);
  }

  // insere no db
  static Future<void> insert(String table, Map<String, Object> data) async {
    // chama a db em cima
    final db = await DBHelper.database();

    //ConflitAlgorithm ... diz que se inserir o mesmo id repetido, vai sobreescrever o antigo
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async{
    // acesso ao db
    final db = await DBHelper.database();
    // busca no db
    return db.query(table);
  }
}
