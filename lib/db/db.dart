import 'package:path/path.dart';
import 'package:secure_docs/model/doc_model.dart';
import 'package:sqflite/sqflite.dart';

class DocsDatabase {
  static final DocsDatabase instance = DocsDatabase._init();

  static Database? _database;

  DocsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE $tableDocs ( 
  ${DocFields.id} $idType, 
  ${DocFields.title} $textType,
  ${DocFields.filebase64} $textType,
  ${DocFields.time} $textType
  )
''');
  }

  Future<Doc> create(Doc doc) async {
    final db = await instance.database;
    final id = await db.insert(tableDocs, doc.toJson());
    return doc.copy(id: id);
  }

  Future<Doc> readDoc(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableDocs,
      columns: DocFields.values,
      where: '${DocFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Doc.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Doc>> readAllDocs() async {
    final db = await instance.database;

    const orderBy = '${DocFields.time} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableDocs ORDER BY $orderBy');

    final result = await db.query(tableDocs, orderBy: orderBy);

    return result.map((json) => Doc.fromJson(json)).toList();
  }

  Future<int> update(Doc note) async {
    final db = await instance.database;

    return db.update(
      tableDocs,
      note.toJson(),
      where: '${DocFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableDocs,
      where: '${DocFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
