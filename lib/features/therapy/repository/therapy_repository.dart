import 'package:memo_med/features/therapy/model/terapia.dart';
import 'package:memo_med/features/family/repository/user_repository.dart';
import 'package:sqflite/sqflite.dart';

import 'package:memo_med/db/db.dart';

class TherapyRepository {
  static const _tableName = 'therapy_table';
  static get tableName => _tableName;
  static const _columnId = 'id';
  static const _columnFarmaco = 'farmaco';
  static const _columnNomeTerapia = 'nomeTerapia';
  static const _columnAssunzioni = 'assunzioni';
  static const _columnFrequenza = 'frequenzaAssunzione';
  static const _columnIsNotifica = 'isNotifica';
  static const _columnIdNotifiche = 'idNotifiche';
  static const _columnPreavvisoNotifica = 'preavvisoNotifica';
  static const _columnUserId = 'userId';
  static const _columnDataInizio = 'dataInizio';
  static const _columnDataFine = 'dataFine';
  static const _columnNote = 'note';

  static final _UsertableName = UserRepository.tableName;

  late final Db db;
  TherapyRepository() {
    db = Db();
  }

  Future<List<Terapia>> getAll() async {
    Database db = await this.db.getDb();

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT t.*,
             u.${UserRepository.columnId}  u_${UserRepository.columnId},
             u.${UserRepository.columnNome}  u_${UserRepository.columnNome},
             u.${UserRepository.columnAvatarImage}  u_${UserRepository.columnAvatarImage}
      FROM $_tableName t LEFT JOIN $_UsertableName u ON t.$_columnUserId = u.${UserRepository.columnId};
    ''');

    return List.generate(maps.length, (i) => Terapia.fromFlatMap(maps[i]));
  }

  Future<Terapia> insert(final Terapia terapia) async {
    Database db = await this.db.getDb();
    return db.transaction((txn) async {
      final id = await txn.insert(
        _tableName,
        terapia.toFlatMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      final results = await txn.rawQuery('''
      SELECT t.*,
             u.${UserRepository.columnId}  u_${UserRepository.columnId},
             u.${UserRepository.columnNome}  u_${UserRepository.columnNome},
             u.${UserRepository.columnAvatarImage}  u_${UserRepository.columnAvatarImage}
      FROM $_tableName t LEFT JOIN $_UsertableName u ON t.$_columnUserId = u.${UserRepository.columnId}
      WHERE t.$_columnId = $id;
    ''');

      return Terapia.fromFlatMap(results.first);
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

  Future<Terapia> updateOne(Terapia t) async {
    Database db = await this.db.getDb();
    return db.transaction((txn) async {
      final int id = t.id!;
      await txn.update(
        _tableName,
        t.toFlatMap(),
        where: '$_columnId = ?',
        whereArgs: [id],
      );

      final List<Map<String, dynamic>> results = await txn.rawQuery('''
      SELECT t.*, 
             u.${UserRepository.columnId} as u_${UserRepository.columnId},
             u.${UserRepository.columnNome} as u_${UserRepository.columnNome},
             u.${UserRepository.columnAvatarImage} as u_${UserRepository.columnAvatarImage}
      FROM $_tableName t LEFT JOIN $_UsertableName u ON t.$_columnUserId = u.${UserRepository.columnId}
      WHERE t.$_columnId = $id;
    ''');

      return Terapia.fromFlatMap(results.first);
    });
  }

  static Future<void> createDb(Database db, _) async {
    await db.execute('''
          CREATE TABLE $_tableName(
            $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $_columnFarmaco STRING NOT NULL,
            $_columnNomeTerapia STRING,
            $_columnAssunzioni INTEGER NOT NULL,
            $_columnFrequenza STRING NOT NULL,
            $_columnIsNotifica INTEGER NOT NULL,
            $_columnIdNotifiche STRING,
            $_columnPreavvisoNotifica STRING NOT NULL,
            $_columnUserId INTEGER NOT NULL,
            $_columnDataFine STRING NOT NULL,
            $_columnDataInizio STRING NOT NULL,
            $_columnNote STRING,
            FOREIGN KEY ($_columnUserId) REFERENCES $_UsertableName (id) ON DELETE CASCADE ON UPDATE CASCADE
          )
        ''');
  }
}
