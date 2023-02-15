import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:memo_med/features/family/model/user.dart';
import 'enums/frequenzaAssunzione.dart';
import 'package:memo_med/features/commons/model/tempoPreavviso.dart';

part 'terapia.g.dart';
part 'terapia_mapper.g.dart';

@JsonSerializable()
class Terapia extends Equatable {
  Terapia(
      {this.id,
      this.nomeTerapia,
      required this.farmaco,
      required this.dataInizio,
      required this.assunzioni,
      required this.isNotifica,
      required this.user,
      this.preavvisoNotifica,
      DateTime? dataFine,
      this.frequenzaAssunzione,
      this.idNotifiche,
      this.note}) {
    this.dataFine = dataFine ??
        (assunzioni > 1 ? dataInizio.add(frequenzaAssunzione!.frequenza * assunzioni) : dataInizio);
  }

  factory Terapia.fromJson(Map<String, dynamic> data) => _$TerapiaFromJson(data);

  factory Terapia.fromFlatMap(Map<String, dynamic> data) => _$TerapiaFromFlatMap(data);

  final int? id;
  final List<int>? idNotifiche;
  final String farmaco;
  final String? nomeTerapia;
  final User user;
  final int assunzioni;
  final DateTime dataInizio;
  late final DateTime dataFine;
  final bool isNotifica;
  final String? note;

  @JsonEnum()
  final FrequenzaAssunzione? frequenzaAssunzione;
  @JsonEnum()
  final PreavvisoNotifica? preavvisoNotifica;

  Terapia copyWith(
      {int? id,
      String? farmaco,
      String? nomeTerapia,
      int? assunzioni,
      FrequenzaAssunzione? frequenzaAssunzione,
      bool? isNotifica,
        List<int>? idNotifiche,
      PreavvisoNotifica? preavvisoNotifica,
      User? user,
      String? note,
      DateTime? dataInizio}) {
    return Terapia(
      nomeTerapia: nomeTerapia ?? this.nomeTerapia,
      id: id ?? this.id,
      farmaco: farmaco ?? this.farmaco,
      assunzioni: assunzioni ?? this.assunzioni,
      frequenzaAssunzione: frequenzaAssunzione ?? this.frequenzaAssunzione,
      isNotifica: isNotifica ?? this.isNotifica,
      idNotifiche: idNotifiche ?? this.idNotifiche,
      preavvisoNotifica: preavvisoNotifica ?? this.preavvisoNotifica,
      user: user ?? this.user,
      dataInizio: dataInizio ?? this.dataInizio,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [
        id,
        farmaco,
        assunzioni,
        frequenzaAssunzione,
        isNotifica,
        preavvisoNotifica,
        idNotifiche,
        user,
        dataInizio,
        dataFine,
        nomeTerapia,
        note
      ];

  Map<String, dynamic> toJson() => _$TerapiaToJson(this);
  Map<String, dynamic> toFlatMap() => _$TerapiaToFlatMap(this);
}
