GlobalData appInstance = GlobalData._private();

class GlobalData{
  bool flag;
  String _urlRoot;
  String _validationPage;
  String _emailValidationOperation;
  String _phoneValidationOperation;
  String _devicePage;
  String _deviceRegistrationOperation;
  String _deviceExistsOperation;
  String _userInitializationPage;
  String _userRegistrationOperation;
  String _userExistsOperation;
  String _emailConfirmationPage;
  String _phoneConfirmationPage;
  String _sessionValidationPage;
  String _userDataPage;
  String _userNameOperation;
  String _userDOBOperation;
  String _userEmailOperation;
  String _userPhoneOperation;
  String _userPasswordOperation;
  String _userSetPhotoOperation;
  String _userDelPhotoOperation;
  String _contactPage;
  String _contactAddOperation;
  String _contactEditOperation;
  String _contactUpdateOperation;
  String _contactRemoveOperation;
  String _contactSetPhotoOperation;
  String _contactDelPhotoOperation;
  String _groupPage;
  String _groupAddOperation;
  String _groupEditOperation;
  String _groupUpdateOperation;
  String _groupRemoveOperation;
  String _groupSetPhotoOperation;
  String _groupDelPhotoOperation;
  String _groupContactPage;
  String _groupContactAddOperation;
  String _groupContactRemoveOperation;
  String _entityPage;
  String _entityAddOperation;
  String _entityEditOperation;
  String _entityUpdateOperation;
  String _entityRemoveOperation;
  String _entitySetPhotoOperation;
  String _entityDelPhotoOperation;


  GlobalData._private(){
    if(flag == null || !flag){
      _setWebServicesSettings();
    }
  }

  void _setWebServicesSettings(){
    _urlRoot = 'http://18.188.38.108/numera/mws/app/';

    _validationPage = 'valida.php';
    _emailValidationOperation = 'correo';
    _phoneValidationOperation = 'telefono';

    _devicePage = 'device.php';
    _deviceRegistrationOperation = 'registra';
    _deviceExistsOperation = 'existe';

    _userInitializationPage = '';
    _userRegistrationOperation = 'registra';
    _userExistsOperation = 'existe';

    _emailConfirmationPage = 'confirmacorreo.php';
    _phoneConfirmationPage = 'confirmatelefono.php';
    _sessionValidationPage = 'validasesion.php';

    _userDataPage = 'titular.php';
    _userNameOperation = 'nombre';
    _userDOBOperation = 'fechanacimiento';
    _userEmailOperation = 'correo';
    _userPhoneOperation = 'telefono';
    _userPasswordOperation = 'password';
    _userSetPhotoOperation = 'setphoto';
    _userDelPhotoOperation = 'delphoto';

    _contactPage = 'contacto.php';
    _contactAddOperation = 'add';
    _contactEditOperation = 'edit';
    _contactUpdateOperation = 'update';
    _contactRemoveOperation = 'del';
    _contactSetPhotoOperation = 'setphoto';
    _contactDelPhotoOperation = 'delphoto';

    _groupPage = 'grupo.php';
    _groupAddOperation = 'add';
    _groupEditOperation = 'edit';
    _groupUpdateOperation = 'update';
    _groupRemoveOperation = 'del';
    _groupSetPhotoOperation = 'setphoto';
    _groupDelPhotoOperation = 'delphoto';

    _groupContactPage = 'miembro.php';
    _groupContactAddOperation = 'add';
    _groupContactRemoveOperation = 'del';

    _entityPage = 'entidad.php';
    _entityAddOperation = 'add';
    _entityEditOperation = 'edit';
    _entityUpdateOperation = 'update';
    _entityRemoveOperation = 'del';
    _entitySetPhotoOperation = 'setphoto';
    _entityDelPhotoOperation = 'delphoto';
  }

  String get urlRoot => _urlRoot;
  String get validationPage => _validationPage;
  String get emailValidationOperation => _emailValidationOperation;
  String get phoneValidationOperation => _phoneValidationOperation;
  String get devicePage => _devicePage;
  String get deviceRegistrationOperation => _deviceRegistrationOperation;
  String get deviceExistsOperation => _deviceExistsOperation;
  String get userInitializationPage => _userInitializationPage;
  String get userRegistrationOperation => _userRegistrationOperation;
  String get userExistsOperation => _userExistsOperation;
  String get emailConfirmationPage => _emailConfirmationPage;
  String get phoneConfirmationPage => _phoneConfirmationPage;
  String get sessionValidationPage => _sessionValidationPage;
  String get userDataPage => _userDataPage;
  String get userNameOperation => _userNameOperation;
  String get userDOBOperation => _userDOBOperation;
  String get userEmailOperation => _userEmailOperation;
  String get userPhoneOperation => _userPhoneOperation;
  String get userPasswordOperation => _userPasswordOperation;
  String get userSetPhotoOperation => _userSetPhotoOperation;
  String get userDelPhotoOperation => _userDelPhotoOperation;
  String get contactPage => _contactPage;
  String get contactAddOperation => _contactAddOperation;
  String get contactEditOperation => _contactEditOperation;
  String get contactUpdateOperation => _contactUpdateOperation;
  String get contactRemoveOperation => _contactRemoveOperation;
  String get contactSetPhotoOperation => _contactSetPhotoOperation;
  String get contactDelPhotoOperation => _contactDelPhotoOperation;
  String get groupPage => _groupPage;
  String get groupAddOperation => _groupAddOperation;
  String get groupEditOperation => _groupEditOperation;
  String get groupUpdateOperation => _groupUpdateOperation;
  String get groupRemoveOperation => _groupRemoveOperation;
  String get groupSetPhotoOperation => _groupSetPhotoOperation;
  String get groupDelPhotoOperation => _groupDelPhotoOperation;
  String get groupContactPage => _groupContactPage;
  String get groupContactAddOperation => _groupContactAddOperation;
  String get groupContactRemoveOperation => _groupContactRemoveOperation;
  String get entityPage => _entityPage;
  String get entityAddOperation => _entityAddOperation;
  String get entityEditOperation => _entityEditOperation;
  String get entityUpdateOperation => _entityUpdateOperation;
  String get entityRemoveOperation => _entityRemoveOperation;
  String get entitySetPhotoOperation => _entitySetPhotoOperation;
  String get entityDelPhotoOperation => _entityDelPhotoOperation;

}

