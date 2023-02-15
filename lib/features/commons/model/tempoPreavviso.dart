import 'package:json_annotation/json_annotation.dart';

enum PreavvisoNotifica{
  @JsonValue("ON_TIME") ON_TIME("All'ora esatta", Duration(minutes: 0)),
  @JsonValue("FIVE_MINUTES") FIVE_MINUTES("5 minuti prima", Duration(minutes: 5)),
  @JsonValue("FIFTEEN_MINUTES") FIFTEEN_MINUTES("15 minuti prima", Duration(minutes: 15)),
  @JsonValue("THIRTY_MINUTES") THIRTY_MINUTES("30 minuti prima", Duration(minutes: 30)),
  @JsonValue("ONE_HOUR") ONE_HOUR("1 ora prima", Duration(hours: 1)),
  @JsonValue("THREE_HOURS") THREE_HOURS("3 ore prima", Duration(hours: 3));

  const PreavvisoNotifica(this.dropdownString, this.tempoPreavviso);
  final String dropdownString;
  final Duration tempoPreavviso;

  String toDropdownString(){
    return dropdownString;
  }

}