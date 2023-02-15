import 'package:memo_med/features/appointments/model/appointment.dart';
import 'package:memo_med/features/family/repository/user_repository.dart';
import 'package:sqflite/sqflite.dart';

import 'package:memo_med/db/db.dart';


class AppointmentRepository {
  static const _tableName = 'appointments_table';
  static const _columnId = 'id';
  static const _columnNome = 'nome';
  static const _columnData = 'data';
  static const _columnLuogo = 'luogo';
  static const _columnIndirizzo = 'indirizzo';
  static const _columnIsNotifica = 'isNotifica';
  static const _columnIdNotifica = 'idNotifica';
  static const _columnCompleted = 'completed';
  static const _columnPreavvisoNotifica = 'preavvisoNotifica';
  static const _columnUser = 'idUser';
  static const _columnNote = 'note';

  static final _UsertableName = UserRepository.tableName;

  late final Db _db;

  static final AppointmentRepository _appointmentsRepository = AppointmentRepository._internal();

  factory AppointmentRepository() {
    return _appointmentsRepository;
  }

  AppointmentRepository._internal(){
    _db = Db();
  }

  Future<List<Appointment>> getAll() async {
    Database db = await _db.getDb();
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT t.*,
             u.${UserRepository.columnId}  u_${UserRepository.columnId},
             u.${UserRepository.columnNome}  u_${UserRepository.columnNome},
             u.${UserRepository.columnAvatarImage}  u_${UserRepository.columnAvatarImage}
      FROM $_tableName t LEFT JOIN $_UsertableName u ON t.$_columnUser = u.${UserRepository.columnId};
    ''');
    return List.generate(maps.length, (i) => Appointment.fromFlatMap(maps[i]));
  }


  Future<Appointment> insert(final Appointment terapia) async {
    Database db = await _db.getDb();
    return db.transaction((txn) async {
      final id = await txn.insert(
        _tableName,
        terapia.toFlatMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      final List<Map<String, dynamic>> results = await txn.rawQuery('''
      SELECT t.*, u.${UserRepository.columnId} as u_${UserRepository.columnId},
             u.${UserRepository.columnNome} as u_${UserRepository.columnNome},
             u.${UserRepository.columnAvatarImage} as u_${UserRepository.columnAvatarImage}
      FROM $_tableName t JOIN $_UsertableName u ON t.$_columnUser = u.${UserRepository.columnId}
      WHERE t.$_columnId = $id;
    ''');

      return Appointment.fromFlatMap(results.first);
    });
  }


  Future<void> delete(final int id) async {
    Database db = await _db.getDb();
    db.delete(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [id],
    );
  }


  Future<Appointment> updateOne(Appointment appointment) async {
    Database db = await _db.getDb();
    return db.transaction((txn) async {
      final int id= appointment.id!;
      await txn.update(
        _tableName,
        appointment.toFlatMap(),
        where: '$_columnId = ?', whereArgs: [id],
      );

      final List<Map<String, dynamic>> results = await txn.rawQuery('''
      SELECT t.*, u.${UserRepository.columnId} as u_${UserRepository.columnId},
             u.${UserRepository.columnNome} as u_${UserRepository.columnNome},
             u.${UserRepository.columnAvatarImage} as u_${UserRepository.columnAvatarImage}
      FROM $_tableName t JOIN $_UsertableName u ON t.$_columnUser = u.${UserRepository.columnId}
      WHERE t.$_columnId = $id;
    ''');

      return Appointment.fromFlatMap(results.first);
    });
  }


  static Future<void> createDb(Database db, _) async {
    db.execute('''
          CREATE TABLE $_tableName(
            $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $_columnNome STRING NOT NULL,
            $_columnLuogo STRING NOT NULL,
            $_columnIndirizzo STRING NOT NULL,
            $_columnIsNotifica INTEGER NOT NULL,
            $_columnIdNotifica INTEGER,
            $_columnCompleted INTEGER NOT NULL,
            $_columnPreavvisoNotifica STRING NOT NULL,
            $_columnUser INTEGER NOT NULL,
            $_columnData STRING NOT NULL,
            $_columnNote STRING,
            FOREIGN KEY ($_columnUser) REFERENCES $_UsertableName (id) ON DELETE CASCADE ON UPDATE CASCADE
          )
        ''');
  }

}
