import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class Notification extends Equatable {
  const Notification({
    required this.id,
    required this.repetitions,
    required this.initialDate,
    required this.repeat,
    required this.interval,
    required this.shownNotifications,
  });

  factory Notification.fromJson(Map<String, dynamic> data) => _$NotificationFromJson(data);

  final int id;
  final int repetitions;
  final bool repeat;
  final DateTime initialDate;
  final Duration? interval;
  final int shownNotifications;

  Notification copyWith(
      {int? id,
      int? repetitions,
      bool? repeat,
      Duration? interval,
      int? shownNotifications,
      DateTime? initialDate}) {
    return Notification(
      id: id ?? this.id,
      initialDate: initialDate ?? this.initialDate,
      repetitions: repetitions ?? this.repetitions,
      repeat: repeat ?? this.repeat,
      interval: interval ?? this.interval,
      shownNotifications: shownNotifications ?? this.shownNotifications,
    );
  }

  @override
  List<Object?> get props => [
        id,
        repetitions,
        initialDate,
        repeat,
        interval,
        shownNotifications,
      ];

  DateTime? getNextNotificationTime(){
    if(repeat && shownNotifications < repetitions && interval != null){
      return initialDate.add(interval! * (shownNotifications + 1));
    }
    return null;
  }

  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
