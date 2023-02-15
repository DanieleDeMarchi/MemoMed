// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

Appointment _$AppointmentFromFlatMap(Map<String, dynamic> json) => Appointment(
      id: json['id'] as int,
      nome: json['nome'] as String,
      idNotifica: json['idNotifica'] as int?,
      user: User(
          id: json['u_id'] as int,
          nome: json['u_nome'] as String,
          avatarImage: json['u_avatarImage'] as String),
      data: DateTime.parse(json['data'] as String),
      luogo: json['luogo'] as String,
      indirizzo: json['indirizzo'] as String,
      isNotifica: (json['isNotifica'] as int) == 0 ? false : true,
      completed: (json['completed'] as int) == 0 ? false : true,
      preavvisoNotifica: $enumDecode(_$PreavvisoNotificaEnumMap, json['preavvisoNotifica']),
      note: json['note'] as String?,
);

Map<String, dynamic> _$AppointmentToFlatMap(Appointment instance) => <String, dynamic>{
      'nome': instance.nome,
      'id': instance.id,
      'idNotifica': instance.idNotifica,
      'idUser': instance.user.id,
      'data': instance.data.toIso8601String(),
      'luogo': instance.luogo,
      'indirizzo': instance.indirizzo,
      'isNotifica': instance.isNotifica ? 1 : 0,
      'completed': instance.completed ? 1 : 0,
      'preavvisoNotifica': _$PreavvisoNotificaEnumMap[instance.preavvisoNotifica]!,
      'note': instance.note,
};

