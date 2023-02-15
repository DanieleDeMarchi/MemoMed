// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terapia.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Terapia _$TerapiaFromJson(Map<String, dynamic> json) => Terapia(
      id: json['id'] as int?,
      nomeTerapia: json['nomeTerapia'] as String?,
      farmaco: json['farmaco'] as String,
      dataInizio: DateTime.parse(json['dataInizio'] as String),
      assunzioni: json['assunzioni'] as int,
      isNotifica: json['isNotifica'] as bool,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      preavvisoNotifica: $enumDecodeNullable(
          _$PreavvisoNotificaEnumMap, json['preavvisoNotifica']),
      dataFine: json['dataFine'] == null
          ? null
          : DateTime.parse(json['dataFine'] as String),
      frequenzaAssunzione: $enumDecodeNullable(
          _$FrequenzaAssunzioneEnumMap, json['frequenzaAssunzione']),
      idNotifiche: (json['idNotifiche'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$TerapiaToJson(Terapia instance) => <String, dynamic>{
      'id': instance.id,
      'idNotifiche': instance.idNotifiche,
      'farmaco': instance.farmaco,
      'nomeTerapia': instance.nomeTerapia,
      'user': instance.user,
      'assunzioni': instance.assunzioni,
      'dataInizio': instance.dataInizio.toIso8601String(),
      'dataFine': instance.dataFine.toIso8601String(),
      'isNotifica': instance.isNotifica,
      'note': instance.note,
      'frequenzaAssunzione':
          _$FrequenzaAssunzioneEnumMap[instance.frequenzaAssunzione],
      'preavvisoNotifica':
          _$PreavvisoNotificaEnumMap[instance.preavvisoNotifica],
    };

const _$PreavvisoNotificaEnumMap = {
  PreavvisoNotifica.ON_TIME: 'ON_TIME',
  PreavvisoNotifica.FIVE_MINUTES: 'FIVE_MINUTES',
  PreavvisoNotifica.FIFTEEN_MINUTES: 'FIFTEEN_MINUTES',
  PreavvisoNotifica.THIRTY_MINUTES: 'THIRTY_MINUTES',
  PreavvisoNotifica.ONE_HOUR: 'ONE_HOUR',
  PreavvisoNotifica.THREE_HOURS: 'THREE_HOURS',
};

const _$FrequenzaAssunzioneEnumMap = {
  FrequenzaAssunzione.ONE_HOUR: 'ONE_HOUR',
  FrequenzaAssunzione.TWO_HOURS: 'TWO_HOURS',
  FrequenzaAssunzione.FOUR_HOURS: 'FOUR_HOURS',
  FrequenzaAssunzione.SIX_HOURS: 'SIX_HOURS',
  FrequenzaAssunzione.EIGHT_HOURS: 'EIGHT_HOURS',
  FrequenzaAssunzione.TWELVE_HOURS: 'TWELVE_HOURS',
  FrequenzaAssunzione.EIGHTEEN_HOURS: 'EIGHTEEN_HOURS',
  FrequenzaAssunzione.ONE_DAY: 'ONE_DAY',
  FrequenzaAssunzione.HOURS_36: 'HOURS_36',
  FrequenzaAssunzione.TWO_DAYS: 'TWO_DAYS',
  FrequenzaAssunzione.THREE_DAYS: 'THREE_DAYS',
  FrequenzaAssunzione.ONE_WEEK: 'ONE_WEEK',
};
