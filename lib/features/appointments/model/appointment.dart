import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:memo_med/features/family/model/user.dart';
import 'package:memo_med/features/commons/activity.dart';

import 'package:memo_med/features/commons/model/tempoPreavviso.dart';

part 'appointment.g.dart';
part 'appointment_mapper.g.dart';

@JsonSerializable()
class Appointment extends Equatable implements Activity {
  const Appointment(
      {this.id,
      required this.nome,
      required this.user,
      required this.data,
      required this.luogo,
      required this.indirizzo,
      required this.isNotifica,
      required this.preavvisoNotifica,
      this.idNotifica,
      this.note,
      this.completed = false});

  factory Appointment.fromJson(Map<String, dynamic> data) => _$AppointmentFromJson(data);

  factory Appointment.fromFlatMap(Map<String, dynamic> data) => _$AppointmentFromFlatMap(data);

  final String nome;
  final int? id;
  final User user;
  final DateTime data;
  final String? luogo;
  final String? indirizzo;
  final bool isNotifica;
  final bool completed;
  final int? idNotifica;
  final String? note;

  @JsonEnum()
  final PreavvisoNotifica preavvisoNotifica;

  Appointment copyWith({
    String? nome,
    int? id,
    User? user,
    DateTime? data,
    String? luogo,
    String? indirizzo,
    bool? isNotifica,
    int? idNotifica,
    PreavvisoNotifica? preavvisoNotifica,
    bool? completed,
    String? note,
  }) {
    return Appointment(
      nome: nome ?? this.nome,
      id: id ?? this.id,
      user: user ?? this.user,
      data: data ?? this.data,
      indirizzo: indirizzo ?? this.indirizzo,
      luogo: luogo ?? this.luogo,
      isNotifica: isNotifica ?? this.isNotifica,
      preavvisoNotifica: preavvisoNotifica ?? this.preavvisoNotifica,
      completed: completed ?? this.completed,
      idNotifica: idNotifica ?? this.idNotifica,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [
        nome,
        id,
        user,
        data,
        luogo,
        indirizzo,
        isNotifica,
        idNotifica,
        preavvisoNotifica,
        completed,
        note
      ];

  Map<String, dynamic> toJson() => _$AppointmentToJson(this);

  Map<String, dynamic> toFlatMap() => _$AppointmentToFlatMap(this);

  @override
  bool isCompleted() {
    return completed;
  }

  @override
  DateTime getDate() {
    return data;
  }
}
