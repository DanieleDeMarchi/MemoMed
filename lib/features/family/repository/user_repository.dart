import 'package:sqflite/sqflite.dart';

import 'package:memo_med/db/db.dart';
import '../model/user.dart';


class UserRepository {
  static const _tableName = 'user_table';
  static get tableName => _tableName;
  static const _columnId = 'id';
  static get columnId => _columnId;
  static const _columnNome = 'nome';
  static get columnNome => _columnNome;
  static const _columnAvatarImage = 'avatarImage';
  static get columnAvatarImage => _columnAvatarImage;

  late final Db _db;

  static final UserRepository _userRepository = UserRepository._internal();

  factory UserRepository() {
    return _userRepository;
  }

  UserRepository._internal(){
    _db = Db();
  }

  static Future<void> createDb(Database db, _) async {
    await db.execute('''
          CREATE TABLE $_tableName(
            $_columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            $_columnNome STRING NOT NULL,
            $_columnAvatarImage STRING NOT NULL
          )
        ''');
  }

  Future<List<User>> fetchAll() async {
    Database db = await _db.getDb();
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) => User.fromJson(maps[i]));
  }

  Future<User> insertOne(User user) async {
    Database db = await _db.getDb();
    return db.transaction((txn) async {
      final id = await txn.insert(
        tableName,
        user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      final List<Map<String, dynamic>> results= await txn.query(tableName, where: '$columnId = ?', whereArgs: [id]);
      return User.fromJson(results.first);
    });
  }

  Future<void> deleteOne(User user) async  {
    Database db = await _db.getDb();
    await db.delete(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [user.id],
    );
  }

  Future<User> updateOne(User user) async {
    Database db = await _db.getDb();
    return db.transaction((txn) async {
      await txn.update(
        tableName,
        user.toJson(),
        where: '$columnId = ?', whereArgs: [user.id],
      );

      final List<Map<String, dynamic>> results= await txn.query(tableName, where: '$columnId = ?', whereArgs: [user.id]);
      return User.fromJson(results.first);
    });
  }
}
