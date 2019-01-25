import 'Repository.dart';

class User{
  int _id;
  String _login;
  String _password;
  String _name;

  static User createUser(int id, String login, String password, String name){
    User myUser = User();
    myUser._id = id;
    myUser._login = login;
    myUser._password = password;
    myUser._name = name;

    return myUser;
  }

  static User validateUser(String login, String password){
    Map<String, dynamic> myUserData = Repository.getUser(login);
    if(myUserData != null && myUserData['password'] == password){
      User myUser = User();
      myUser._id = myUserData['id'];
      myUser._login = myUserData['login'];
      myUser._password = myUserData['password'];
      myUser._name = myUserData['name'];

      return myUser;
    }

    return null;
  }

  int get id => _id;
  String get login => _login;
  String get password => _password;
  String get name => _name;
}