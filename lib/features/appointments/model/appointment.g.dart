// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Appointment _$AppointmentFromJson(Map<String, dynamic> json) => Appointment(
      id: json['id'] as int?,
      nome: json['nome'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      data: DateTime.parse(json['data'] as String),
      luogo: json['luogo'] as String?,
      indirizzo: json['indirizzo'] as String?,
      isNotifica: json['isNotifica'] as bool,
      preavvisoNotifica:
          $enumDecode(_$PreavvisoNotificaEnumMap, json['preavvisoNotifica']),
      idNotifica: json['idNotifica'] as int?,
      note: json['note'] as String?,
      completed: json['completed'] as bool? ?? false,
    );

Map<String, dynamic> _$AppointmentToJson(Appointment instance) =>
    <String, dynamic>{
      'nome': instance.nome,
      'id': instance.id,
      'user': instance.user,
      'data': instance.data.toIso8601String(),
      'luogo': instance.luogo,
      'indirizzo': instance.indirizzo,
      'isNotifica': instance.isNotifica,
      'completed': instance.completed,
      'idNotifica': instance.idNotifica,
      'note': instance.note,
      'preavvisoNotifica':
          _$PreavvisoNotificaEnumMap[instance.preavvisoNotifica]!,
    };

const _$PreavvisoNotificaEnumMap = {
  PreavvisoNotifica.ON_TIME: 'ON_TIME',
  PreavvisoNotifica.FIVE_MINUTES: 'FIVE_MINUTES',
  PreavvisoNotifica.FIFTEEN_MINUTES: 'FIFTEEN_MINUTES',
  PreavvisoNotifica.THIRTY_MINUTES: 'THIRTY_MINUTES',
  PreavvisoNotifica.ONE_HOUR: 'ONE_HOUR',
  PreavvisoNotifica.THREE_HOURS: 'THREE_HOURS',
};
