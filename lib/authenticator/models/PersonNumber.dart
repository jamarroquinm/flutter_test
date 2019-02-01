import 'dart:convert';

PersonNumber fromJson(String jsonString) {
  final jsonData = json.decode(jsonString);
  return PersonNumber.fromMap(jsonData);
}

String toJson(PersonNumber data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class PersonNumber {
  int personId;
  int numberId;
  int value;

  PersonNumber({
    this.personId,
    this.numberId,
    this.value,
  });

  factory PersonNumber.fromMap(Map<String, dynamic> json) => PersonNumber(
    personId: json["personId"],
    numberId: json["numberId"],
    value: json["value"],
  );

  Map<String, dynamic> toMap() => {
    "personId": personId,
    "numberId": numberId,
    "value": value,
  };
}