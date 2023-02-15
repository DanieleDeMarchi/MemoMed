import 'package:json_annotation/json_annotation.dart';

enum FrequenzaAssunzione{
  @JsonValue("ONE_HOUR")  ONE_HOUR("Ogni ora", Duration(hours: 1)),
  @JsonValue("TWO_HOURS")  TWO_HOURS("Ogni 2 ore", Duration(hours: 2)),
  @JsonValue("FOUR_HOURS")  FOUR_HOURS("Ogni 4 ore", Duration(hours: 4)),
  @JsonValue("SIX_HOURS")  SIX_HOURS("Ogni 6 ore", Duration(hours: 6)),
  @JsonValue("EIGHT_HOURS")  EIGHT_HOURS("Ogni 8 ore", Duration(hours: 8)),
  @JsonValue("TWELVE_HOURS")  TWELVE_HOURS("Ogni 12 ore", Duration(hours: 12)),
  @JsonValue("EIGHTEEN_HOURS")  EIGHTEEN_HOURS("Ogni 18 ore", Duration(hours: 18)),
  @JsonValue("ONE_DAY")  ONE_DAY("Una volta al giorno", Duration(hours: 24)),
  @JsonValue("HOURS_36")  HOURS_36("Ogni 36 ore", Duration(hours: 36)),
  @JsonValue("TWO_DAYS")  TWO_DAYS("Una volta ogni 2 giorni", Duration(hours: 48)),
  @JsonValue("THREE_DAYS")  THREE_DAYS("Una volta ogni 3 giorni", Duration(hours: 72)),
  @JsonValue("ONE_WEEK")  ONE_WEEK("Una volta a settimana", Duration(days: 7));

  const FrequenzaAssunzione(this.dropdownString, this.frequenza);
  final String dropdownString;
  final Duration frequenza;

  String toDropdownString(){
    return dropdownString;
  }

}