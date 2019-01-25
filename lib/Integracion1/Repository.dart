import 'User.dart';

Map<String, User> _registeredUsers = {
  'alberto': User.createUser(1, 'alberto', '1234', 'Alberto Moncada'),
  'alejandro': User.createUser(2, 'alejandro', '1234', 'Alejandro Marroquín'),
  'alfredo': User.createUser(3, 'alfredo', '1234', 'Alfredp N'),
};

class Repository{

  static Map<String, dynamic> getUser(String login){
    User myUser = _registeredUsers[login];
    if(myUser != null){
      return {
        'id': myUser.id,
        'login': myUser.login,
        'password': myUser.password,
        'name': myUser.name,
      };
    }

    return null;
  }
}