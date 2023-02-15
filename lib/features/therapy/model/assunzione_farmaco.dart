import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'assunzione_farmaco.g.dart';
part 'assunzione_farmaco_mapper.g.dart';

@JsonSerializable()
class AssunzioneFarmaco extends Equatable {
  const AssunzioneFarmaco({
    this.id,
    required this.dataAssunzione,
    required this.completed,
    required this.idTerapia,
  });

  factory AssunzioneFarmaco.fromJson(Map<String, dynamic> data) => _$AssunzioneFarmacoFromMap(data);

  final int? id;
  final DateTime dataAssunzione;
  final bool completed;
  final int idTerapia;

  AssunzioneFarmaco copyWith({
    int? id,
    DateTime? dataAssunzione,
    bool? completed,
    int? idTerapia,
    int? notificationId,
  }) {
    return AssunzioneFarmaco(
      id: id ?? this.id,
      dataAssunzione: dataAssunzione ?? this.dataAssunzione,
      completed: completed ?? this.completed,
      idTerapia: idTerapia ?? this.idTerapia,
    );
  }
  
  @override
  List<Object?> get props => [
        id,
        dataAssunzione,
        completed,
        idTerapia,
      ];

  Map<String, dynamic> toJson() => _$AssunzioneFarmacoToMap(this);
}
