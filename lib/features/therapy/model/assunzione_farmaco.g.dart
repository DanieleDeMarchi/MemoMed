// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assunzione_farmaco.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssunzioneFarmaco _$AssunzioneFarmacoFromJson(Map<String, dynamic> json) =>
    AssunzioneFarmaco(
      id: json['id'] as int?,
      dataAssunzione: DateTime.parse(json['dataAssunzione'] as String),
      completed: json['completed'] as bool,
      idTerapia: json['idTerapia'] as int,
    );

Map<String, dynamic> _$AssunzioneFarmacoToJson(AssunzioneFarmaco instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dataAssunzione': instance.dataAssunzione.toIso8601String(),
      'completed': instance.completed,
      'idTerapia': instance.idTerapia,
    };
