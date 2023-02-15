// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      id: json['id'] as int,
      repetitions: json['repetitions'] as int,
      initialDate: DateTime.parse(json['initialDate'] as String),
      repeat: json['repeat'] as bool,
      interval: json['interval'] == null
          ? null
          : Duration(microseconds: json['interval'] as int),
      shownNotifications: json['shownNotifications'] as int,
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'repetitions': instance.repetitions,
      'repeat': instance.repeat,
      'initialDate': instance.initialDate.toIso8601String(),
      'interval': instance.interval?.inMicroseconds,
      'shownNotifications': instance.shownNotifications,
    };
