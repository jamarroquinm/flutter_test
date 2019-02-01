import 'dart:convert';

Number fromJson(String jsonString) {
  final jsonData = json.decode(jsonString);
  return Number.fromMap(jsonData);
}

String toJson(Number data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Number {
  int id;
  String letter;
  String esLabel;
  String enLabel;

  Number({
    this.id,
    this.letter = '',
    this.esLabel = '',
    this.enLabel = '',
  });

  factory Number.fromMap(Map<String, dynamic> json) => Number(
    id: json["id"],
    letter: json["letter"],
    esLabel: json["esLabel"],
    enLabel: json["enLabel"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "letter": letter,
    "esLabel": esLabel,
    "enLabel": enLabel,
  };
}