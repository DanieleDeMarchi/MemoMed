import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:memo_med/features/therapy/repository/therapy_repository.dart';
import 'package:memo_med/features/family/repository/user_repository.dart';
import 'package:memo_med/features/appointments/repository/appointment_repository.dart';
import 'package:memo_med/features/therapy/repository/assunzione_medicinali_reposirity.dart';

class Db {
  Database? _database;

  static final Db _db = Db._internal();

  factory Db() {
    return _db;
  }

  Db._internal();

  Future<void> initDb() async {
    _database = await openDatabase(version: 1, join(await getDatabasesPath(), 'memo_med.db'),
        onConfigure: (db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    }, onCreate: (db, version) async {
      // Run the CREATE TABLE statement on the database.
      await UserRepository.createDb(db, version);
      await TherapyRepository.createDb(db, version);
      await AppointmentRepository.createDb(db, version);
      await AssunzioneMedicinaliRepository.createDb(db, version);
    });
  }

  Future<Database> getDb() async {
    if (_database == null) {
      await initDb();
    }
    return _database!;
  }
}
