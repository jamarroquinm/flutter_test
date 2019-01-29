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
    Map<String, dynamic> myUserData = _Repository.getUser(login);
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

Map<String, User> _registeredUsers = {
  'alberto': User.createUser(1, 'alberto', '1234', 'Alberto Moncada'),
  'alejandro': User.createUser(2, 'alejandro', '1234', 'Alejandro Marroquín'),
  'alfredo': User.createUser(3, 'alfredo', '1234', 'Alfredp N'),
};

class _Repository{

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