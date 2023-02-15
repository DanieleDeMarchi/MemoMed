import 'package:memo_med/features/therapy/model/assunzione_farmaco.dart';
import 'package:memo_med/features/therapy/repository/therapy_repository.dart';
import 'package:sqflite/sqflite.dart';

import 'package:memo_med/db/db.dart';

class AssunzioneMedicinaliRepository {
  static const _tableName = 'assunzioni_table';
  static const _columnId = 'id';
  static const _columnCompletata = 'completed';
  static const _columnDataAssunzione = 'dataAssunzione';
  static const _columnIdTerapia = 'idTerapia';

  static final _therayTableName = TherapyRepository.tableName;

  late final Db db;
  AssunzioneMedicinaliRepository() {
    db = Db();
  }

  Future<List<AssunzioneFarmaco>> getAll() async {
    Database db = await this.db.getDb();

    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) => AssunzioneFarmaco.fromJson(maps[i]));
  }

  Future<AssunzioneFarmaco> insert(final AssunzioneFarmaco assunzioneFarmaco) async {
    Database db = await this.db.getDb();
    late final AssunzioneFarmaco toReturn;
    await db.transaction((txn) async {
      final id = await txn.insert(
        _tableName,
        assunzioneFarmaco.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      final results = await db.query(
        _tableName,
        where: '$_columnId = ?',
        whereArgs: [id],
      );

      toReturn = AssunzioneFarmaco.fromJson(results.first);
    });
    return toReturn;
  }

  Future<List<AssunzioneFarmaco>> insertMany(
      List<AssunzioneFarmaco> assunzioni, int idTerapia) async {
    Database db = await this.db.getDb();
    return db.transaction((txn) async {
      Batch batch = txn.batch();

      assunzioni.forEach((element) => batch.insert(
            _tableName,
            element.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          ));

      await batch.commit(noResult: true);

      final results = await txn.query(
        _tableName,
        where: '$_columnIdTerapia = ?',
        whereArgs: [idTerapia],
      );

      return results.map((e) => AssunzioneFarmaco.fromJson(e)).toList();
    });
  }

  Future<void> delete(final int id) async {
    Database db = await this.db.getDb();
    await db.delete(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [id],
    );
  }

  Future<AssunzioneFarmaco> update(AssunzioneFarmaco assunzioneFarmaco) async {
    Database db = await this.db.getDb();
    return db.transaction((txn) async {
      final int id = assunzioneFarmaco.id!;
      await txn.update(
        _tableName,
        assunzioneFarmaco.toJson(),
        where: '$_columnId = ?',
        whereArgs: [id],
      );

      final results = await txn.query(
        _tableName,
        where: '$_columnId = ?',
        whereArgs: [id],
      );

      return AssunzioneFarmaco.fromJson(results.first);
    });
  }

  static Future<void> createDb(Database db, _) async {
    await db.execute('''
          CREATE TABLE $_tableName(
            $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $_columnCompletata INTEGER NOT NULL,
            $_columnDataAssunzione STRING NOT NULL,
            $_columnIdTerapia INTEGER NOT NULL,
            FOREIGN KEY ($_columnIdTerapia) REFERENCES $_therayTableName (id) ON DELETE CASCADE ON UPDATE CASCADE
          )
        ''');
  }

}
