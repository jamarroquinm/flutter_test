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
  String esName;
  String esDescription;
  String enName;
  String enDescription;

  Number({
    this.id,
    this.letter = '',
    this.esName = '',
    this.esDescription = '',
    this.enName = '',
    this.enDescription = '',
  });

  factory Number.fromMap(Map<String, dynamic> json) => Number(
    id: json["id"],
    letter: json["letter"],
    esName: json["esName"],
    esDescription: json["esDescription"],
    enName: json["enName"],
    enDescription: json["enDescription"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "letter": letter,
    "esName": esName,
    "esDescription": esDescription,
    "enName": enName,
    "enDescription": enDescription,
  };
}