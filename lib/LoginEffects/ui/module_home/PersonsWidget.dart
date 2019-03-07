import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:learning_flutter/LoginEffects/backend/exports.dart';
import 'package:learning_flutter/LoginEffects/bloc/module_home/exports.dart';
import 'package:learning_flutter/LoginEffects/model/exports.dart';

class PersonsWidget extends StatefulWidget {
  final HomeWidgetsBloc homeWidgetsBloc;

  PersonsWidget({
    Key key,
    @required this.homeWidgetsBloc,
  }) : super(key: key);

  @override
  _PersonsWidgetState createState() => _PersonsWidgetState();
}

class _PersonsWidgetState extends State<PersonsWidget> {
  HomeWidgetsBloc get homeWidgetsBloc => widget.homeWidgetsBloc;


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeWidgetsEvent, HomeWidgetsState>(
      bloc: homeWidgetsBloc,
      builder: (
          BuildContext context,
          HomeWidgetsState state,
          ) {

        return Container(
          child: Row(
            children: <Widget>[
              _getProfilesRow(),
            ],
          ),
        );
      },
    );
  }

  Row _getProfilesRow(){
    String picture;
    if(appInstance.user.picture != null && appInstance.user.picture != ''){
      picture = 'images/profile/${appInstance.user.picture}';
    } else {
      picture = 'images/user.png';
    }

    String partnerPicture;
    if(appInstance.partner != null &&
        appInstance.partner.picture != null &&
        appInstance.partner.picture != ''){
      partnerPicture = 'images/profile/${appInstance.partner.picture}';
    } else {
      partnerPicture = 'images/addUser.png';
    }

    String partnerName;
    String partnerDateOfBirth;
    Function partnerFunction;
    int userPartnerNumber;

    if(!existRegister(appInstance.partner)){
      partnerName = '';
      partnerDateOfBirth = '';
      partnerFunction = _onAddPartnerButtonPressed;
      userPartnerNumber = appInstance.user.numbers.mainNumber;
    } else {
      partnerName = appInstance.partner.fullName() ?? '';
      partnerDateOfBirth = dateTimeToShortString(appInstance.partner.birthDate);
      partnerFunction = _onRemovePartnerButtonPressed;
      SubjectBase pp = appInstance.partner;
      userPartnerNumber = appInstance.partner.numbers.mainNumber;
    }

    Card userCard = _getCard(picture, appInstance.user.fullName(),
        dateTimeToShortString(appInstance.user.birthDate), null);

    Card partnerCard = _getCard(partnerPicture, partnerName, partnerDateOfBirth, partnerFunction);

    //todo revisar cómo se obtiene el número del año, con cálculo local o webservice
    int dateTimeLapseNumber = KeyNumbers.getElementalNumber(appInstance.dateLapse.day.year);

    Container numbersText = Container(
      margin: EdgeInsets.only(left: 8.0),
      padding: EdgeInsets.all(2.0),
      decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
      child: Text(
        '$userPartnerNumber/$dateTimeLapseNumber',
        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.red),
      ),
    );

    return Row(children: <Widget>[userCard, partnerCard, numbersText]);
  }

  Card _getCard(String picturePath, String name, String dateOfBirth, Function onButtonPressed){
    return Card(
      child: InkWell(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Image.asset(picturePath, width: 60.0),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      child: Text(name),
                    ),
                    Container(
                      child: Text(dateOfBirth),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        onTap: onButtonPressed,
      ),
    );
  }

  _onAddPartnerButtonPressed() {
    homeWidgetsBloc.dispatch(AddPartnerButtonPressed());
  }

  _onRemovePartnerButtonPressed() {
    homeWidgetsBloc.dispatch(RemovePartnerButtonPressed());
  }
}
