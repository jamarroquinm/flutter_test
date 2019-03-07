import 'package:learning_flutter/LoginEffects/model/exports.dart';

import 'package:learning_flutter/LoginEffects/backend/exports.dart';

class KeyNumbersHelper {

  Future<KeyNumbers> getNumbersPerson(Person person) async {
    //todo vía webservice
    return KeyNumbers.getKeyNumbers(person.birthDate);
  }

  Future<KeyNumbers> getNumbersContact(Contact contact) async {
    //todo vía webservice

    DateTime dateOfBirth;
    if(contact == null){
      dateOfBirth = defaultDateTime;
    } else {
      dateOfBirth = contact.birthDate;
    }

    return KeyNumbers.getKeyNumbers(dateOfBirth);
  }

  Future<KeyNumbers> getNumbersGroup(Group group) async {
    //todo vía webservice

    DateTime dateOfBirth;
    if(group == null){
      dateOfBirth = defaultDateTime;
    } else {
      dateOfBirth = group.birthDate;
    }

    return KeyNumbers.getKeyNumbers(dateOfBirth);
  }

  Future<KeyNumbers> getNumbersPersonContact(Person person, SubjectBase partner) async {
    //todo vía webservice

    DateTime dateOfBirth;
    if(partner == null){
      dateOfBirth = defaultDateTime;
    } else {
      dateOfBirth = partner.birthDate;
    }

    return KeyNumbers.getKeyNumbers(dateOfBirth);
  }

  Future<KeyNumbers> getNumbersPersonGroup(Person person, SubjectBase partner) async {
    //todo vía webservice

    DateTime dateOfBirth;
    if(partner == null){
      dateOfBirth = defaultDateTime;
    } else {
      dateOfBirth = partner.birthDate;
    }

    return KeyNumbers.getKeyNumbers(dateOfBirth);
  }
}
