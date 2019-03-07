import 'package:learning_flutter/LoginEffects/backend/exports.dart';
import 'package:learning_flutter/LoginEffects/backend/enums/exports.dart';
import 'package:learning_flutter/LoginEffects/model/exports.dart';

class HomeData{
  final Person user;
  final SubjectBase partner;
  final DateLapse dateLapse;
  final bool isEnergy;
  final Category category;
  String _message;
  final bool initialized;

  HomeData({
    this.user,
    this.partner,
    this.dateLapse,
    this.isEnergy,
    this.category,
    this.initialized = true,
  }){
    //todo update message with parameters
    _message = 'Loren ipsum...';
  }

  String get message => _message;
}