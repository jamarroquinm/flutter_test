import 'package:shared_preferences/shared_preferences.dart';
import 'package:learning_flutter/LoginEffects/model/exports.dart';
import 'package:learning_flutter/LoginEffects/backend/enums/exports.dart';
import 'package:learning_flutter/LoginEffects/backend/exports.dart';

GlobalData appInstance = GlobalData._private();

class GlobalData {
  Person _user;
  SubjectBase _partner;
  DateLapse _dateLapse;
  bool _isEnergy;
  Category _category;
  String _message;
  bool _appStarted;
  bool _dataInitialized;

  GlobalData._private(){
    if(_user == null){
      _user = Person();
    }
    if(_appStarted == null){
      _appStarted = false;
    }
    if(_dataInitialized == null){
      _dataInitialized = false;
    }
  }

  void updateUser(Person user, [bool isLogout = false]) {
    _GlobalDataHelper()._updateUser(user, isLogout);
    _user = user;
  }

  void updatePartner(SubjectBase partner) {
    _GlobalDataHelper()._updatePartner(partner);
    _partner = partner;
  }

  void updateDataLapse(DateLapse dateLapse) {
    _GlobalDataHelper()._updateDataLapse(dateLapse);
    _dateLapse = dateLapse;
  }

  void updateIsEnergy(bool isEnergy) {
    _GlobalDataHelper()._updateIsEnergy(isEnergy);
    _isEnergy = isEnergy;
  }

  void updateCategory(Category category) {
    _GlobalDataHelper()._updateCategory(category);
    _category = category;
  }

  void updateMessage(String message) {
    _GlobalDataHelper()._updateMessage(message);
    _message = message;
  }

  void startApp() {
    _appStarted = true;
  }

  Future<bool> initializeData() async {
    bool result = await _GlobalDataHelper()._initializeGlobalDataValues();
    _dataInitialized = result;
    return result;
  }

  void logout() {
    updateUser(Person(), true);
    updatePartner(Contact());
    updateDataLapse(null);
    updateIsEnergy(null);
    updateCategory(null);
    updateMessage(null);
    _dataInitialized = false;
  }

  Person get user => _user;
  SubjectBase get partner => _partner;
  DateLapse get dateLapse => _dateLapse;
  bool get isEnergy => _isEnergy;
  Category get category => _category;
  String get message => _message;
  bool get appStarted => _appStarted;
  bool get dataInitialized => _dataInitialized;
}

class _GlobalDataHelper{
  /*
    El usuario se inicializa en StartBloc cuando su evento es AppStarted
    o se actualiza en AuthenticationBloc al autenticarse o registrarse
    y en StartBloc al hacer logout
    Todos los demás valores se regeneran a partir de shared preferences
   */
  Future<bool> _initializeGlobalDataValues() async {
    bool result = await _recoverPartner();

    if(result){
      result = await _recoverDataLapse();
    }

    if(result){
      result = await _recoverIsEnergy();
    }

    if(result){
      result = await _recoverCategory();
    }

    if(result){
      result = await _recoverMessage();
    }

    return result;
  }

  Future<void> _updateUser(Person user, [bool isLogout = false]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(isLogout || !existRegister(user)){
      await prefs.setString('personId', '');
    } else {
      await prefs.setString('personId', user.serverId);
    }
  }

  Future<void> _updatePartner(SubjectBase partner) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(!existRegister(partner)){
      await prefs.setString('partnerId', '');
      await prefs.setString('partnerType', '');
    } else {
      await prefs.setString('personId', partner.serverId);
      await prefs.setString('partnerType', partner.type.toString());
    }
  }

  Future<void> _updateDataLapse(DateLapse dateLapse) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(dateLapse != null && dateLapse.day != null && dateLapse.lapse != null){
      await prefs.setString('date', '${dateTimeToIso8601(dateLapse.day)}');
      await prefs.setString('lapse', '${dateLapse.lapse.toString()}');
      if(dateLapse.canChangeYear != null){
        await prefs.setInt('changeYear', dateLapse.canChangeYear ? 1 : 0);
      } else {
        await prefs.setInt('changeYear', 0);
      }

    } else {
      await prefs.setString('date', '');
      await prefs.setString('lapse', '${Lapse.day.toString()}');
      await prefs.setInt('changeYear', 0);
    }
  }

  Future<void> _updateIsEnergy(bool isEnergy) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(isEnergy == null){
      await prefs.setInt('isEnergy', 1);
    } else {
      await prefs.setInt('isEnergy', isEnergy ? 1 : 0);
    }
  }

  Future<void> _updateCategory(Category category) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(category == null){
      await prefs.setString('category', '');
    } else {
      await prefs.setString('category', '${category.toString()}');
    }
  }

  Future<void> _updateMessage(String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(message == null){
      await prefs.setString('message', '');
    } else {
      await prefs.setString('message', message);
    }
  }


  Future<bool> _recoverPartner() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String partnerId = prefs.getString('partnerId');
    String partnerType = prefs.getString('partnerType');

    if(partnerId != null && partnerId != null){
      PartnerType type = partnerTypeEnumValueFromName(partnerType);
      if(type == PartnerType.contact){
        appInstance._partner = await ContactHelper().getItem(partnerId);
      } else if(type == PartnerType.group){
        appInstance._partner = await GroupHelper().getItem(partnerId);
      }
    }

    return true;
  }

  Future<bool> _recoverDataLapse() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();


    DateTime date = iso8601ToDateTime(prefs.getString('date'));
    Lapse lapse = lapseEnumValueFromName(prefs.getString('lapse'));
    int changeYear = prefs.getInt('changeYear') ?? 0;

    if(date.year == defaultDateTime.year){
      date = DateTime.now();
    }

    appInstance._dateLapse = DateLapse.fromDate(date, lapse, changeYear == 0 ? false : true);

    return true;
  }

  Future<bool> _recoverIsEnergy() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    appInstance._isEnergy = (prefs.getInt('isEnergy') ?? 0) == 0 ? false : true;

    return true;
  }

  Future<bool> _recoverCategory() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    appInstance._category = categoryEnumValueFromName(prefs.getString('category'));

    return true;
  }

  Future<bool> _recoverMessage() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    appInstance._message = prefs.getString('message');

    return true;
  }
}
