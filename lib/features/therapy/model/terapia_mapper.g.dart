// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terapia.dart';

Terapia _$TerapiaFromFlatMap(Map<String, dynamic> json) => Terapia(
      farmaco: json['farmaco'] as String,
      nomeTerapia: json['nomeTerapia'] as String?,
      note: json['note'] as String?,
      dataInizio: DateTime.parse(json['dataInizio'] as String),
      id: json['id'] as int?,
      assunzioni: json['assunzioni'] as int,
      frequenzaAssunzione:
          $enumDecodeNullable(_$FrequenzaAssunzioneEnumMap, json['frequenzaAssunzione']),
      isNotifica: (json['isNotifica'] as int) == 0 ? false : true,
      preavvisoNotifica: $enumDecode(_$PreavvisoNotificaEnumMap, json['preavvisoNotifica']),
      dataFine: DateTime.parse(json['dataFine'] as String),
      user: User(
          id: json['u_id'] as int,
          nome: json['u_nome'] as String,
          avatarImage: json['u_avatarImage'] as String),
      idNotifiche: () {
            final string= json['idNotifiche'] as String?;
            if(string != null){
                  return string.split(',').map(int.parse).toList();
            }
            return null;
      }(),
    );

Map<String, dynamic> _$TerapiaToFlatMap(Terapia instance) => <String, dynamic>{
      'id': instance.id,
      'farmaco': instance.farmaco,
      'note': instance.note,
      'nomeTerapia': instance.nomeTerapia,
      'userId': instance.user.id,
      'assunzioni': instance.assunzioni,
      'dataInizio': instance.dataInizio.toIso8601String(),
      'dataFine': instance.dataFine.toIso8601String(),
      'isNotifica': instance.isNotifica ? 1 : 0,
      'idNotifiche': instance.idNotifiche?.join(","),
      'frequenzaAssunzione': _$FrequenzaAssunzioneEnumMap[instance.frequenzaAssunzione],
      'preavvisoNotifica': _$PreavvisoNotificaEnumMap[instance.preavvisoNotifica]!,
    };

/*
List<int> numbers = [1, 2, 3, 4, 5];
String commaSeparated = numbers.join(',');
print(commaSeparated); // "1,2,3,4,5"

String commaSeparatedNumbers = "1,2,3,4,5";
List<int> parsedNumbers = commaSeparatedNumbers.split(',').map(int.parse).toList();
print(parsedNumbers); // [1, 2, 3, 4, 5]

 */
