part of 'assunzione_farmaco.dart';

AssunzioneFarmaco _$AssunzioneFarmacoFromMap(Map<String, dynamic> json) => AssunzioneFarmaco(
      id: json['id'] as int?,
      dataAssunzione: DateTime.parse(json['dataAssunzione'] as String),
      completed: (json['completed'] as int) == 0 ? false : true,
      idTerapia: json['idTerapia'] as int,
    );

Map<String, dynamic> _$AssunzioneFarmacoToMap(AssunzioneFarmaco instance) => <String, dynamic>{
      'id': instance.id,
      'dataAssunzione': instance.dataAssunzione.toIso8601String(),
      'completed': instance.completed ? 1 : 0,
      'idTerapia': instance.idTerapia,
    };