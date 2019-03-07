import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:learning_flutter/LoginEffects/bloc/exports.dart';
import 'package:learning_flutter/LoginEffects/backend/exports.dart';
import 'package:learning_flutter/LoginEffects/backend/enums/exports.dart';
import 'package:learning_flutter/LoginEffects/model/exports.dart';
import 'package:learning_flutter/LoginEffects/bloc/module_partners/PartnerEvents.dart';
import 'package:learning_flutter/LoginEffects/bloc/module_partners/PartnerStates.dart';
import 'package:learning_flutter/LoginEffects/backend/GlobalData.dart';

class PartnerBloc extends Bloc<PartnerEvent, PartnerState> {
  final MainBloc mainBloc;

  final bool isEdition;
  String _contactId;
  String _groupId;

  PartnerBloc({@required this.mainBloc, @required this.isEdition}) :
    assert(mainBloc != null);

  @override
  PartnerState get initialState => PartnerUninitialized();

  @override
  Stream<PartnerState> mapEventToState(
      PartnerState currentState,
      PartnerEvent event,
      ) async* {

      //enter Partner Module; open ContactPage by default
      if(event is PartnerInitiated){
        yield PartnerLoading();
        yield PartnerListing(type: PartnerType.contact);


      //if edition, open editor page; otherwise, update global partner and exit Module
      } else if(event is PartnerListItemSelected){
        yield PartnerLoading();
        SubjectBase partner = await _getPartner(event.partnerId, event.type);

        if(isEdition){
          yield PartnerEditing(partner: partner, type: event.type);
        } else {
          appInstance.updatePartner(partner);
          mainBloc.dispatch(ActivatingHomeModule());
          yield PartnerExiting();
        }


      //open different partner listing
      } else if(event is ChangePartnerPageButtonPressed){
        yield PartnerLoading();
        if(event.newType == PartnerType.contact) {
          yield PartnerListing(type: PartnerType.group);
        } else if(event.newType == PartnerType.group){
          yield PartnerListing(type: PartnerType.contact);
        }



      } else if(event is ExitPartnersListButtonPressed){
        yield PartnerLoading();
        if(event.currentType == PartnerType.contact) {
          mainBloc.dispatch(ActivatingHomeModule());
          yield PartnerExiting();
        } else if(event.currentType == PartnerType.group){
          yield PartnerListing(type: PartnerType.contact);
        }


      } else if(event is PartnerSaveButtonPressed){
        yield PartnerLoading();
        SubjectBase partner;

        if(event.currentType == PartnerType.contact) {
          if(existRegister(event.partner)){
            partner = await ContactHelper().updateUpload(event.partner);
          } else {
            partner = await ContactHelper().addUpload(event.partner);
          }
        } else if(event.currentType == PartnerType.group){
          if(existRegister(event.partner)){
            partner = await GroupHelper().updateUpload(event.partner);
          } else {
            partner = await GroupHelper().addUpload(event.partner);
          }
        }

        if(existRegister(partner)){
          yield PartnerEditing(partner: partner, type: event.currentType);
        } else {
          yield PartnerEditingFailure(partner: partner, type: event.currentType);
        }


      } else if(event is PartnerDeleteButtonPressed){
        yield PartnerLoading();
        SubjectBase partner;

        if(event.currentType == PartnerType.contact) {
          partner = await ContactHelper().deleteUpload(event.partner);
        } else if(event.currentType == PartnerType.group){
          partner = await GroupHelper().deleteUpload(event.partner);
        }

        if(partner.message == null || partner.message == ''){
          yield PartnerListing(type: event.currentType);
        } else {
          yield PartnerEditingFailure(partner: partner, type: event.currentType);
        }


      } else if(event is OpenMatcherButtonPressed){
        yield PartnerLoading();
        SubjectBase partner = await _getPartner(event.partnerId, event.partnerType);
        yield MatcherEditing(partner: partner, partnerType: event.partnerType, newMatchType: event.newMatchType);


      } else if(event is ExitPartnerEditionButtonPressed){
        yield PartnerLoading();
        yield PartnerListing(type: event.currentType);


      } else if(event is MatchButtonPressed){
        yield PartnerLoading();

        GroupContact groupContact;
        if(existRegister(event.groupContact)){
          groupContact = await GroupContactHelper().updateUpload(event.groupContact);
        } else {
          groupContact = await GroupContactHelper().addUpload(event.groupContact);
        }

        String serverId;
        PartnerType newMatchType;
        if(event.editingType == PartnerType.contact){
          serverId = groupContact.idContact;
          newMatchType = PartnerType.group;
        } else if(event.editingType == PartnerType.group){
          serverId = groupContact.idGroup;
          newMatchType = PartnerType.contact;
        }

        SubjectBase partner = await _getPartner(serverId, event.editingType);

        if(existRegister(groupContact)){
          yield MatcherEditing(partner: partner, partnerType: event.editingType, newMatchType: newMatchType);
        } else {
          yield MatcherEditingFailure(partner: partner, partnerType: event.editingType, newMatchType: newMatchType);
        }


      } else if(event is RemoveMatchButtonPressed){
        yield PartnerLoading();
        GroupContact groupContact = await GroupContactHelper().deleteUpload(event.groupContact);

        String serverId;
        PartnerType newMatchType;
        if(event.editingType == PartnerType.contact){
          serverId = groupContact.idContact;
          newMatchType = PartnerType.group;
        } else if(event.editingType == PartnerType.group){
          serverId = groupContact.idGroup;
          newMatchType = PartnerType.contact;
        }

        SubjectBase partner = await _getPartner(serverId, event.editingType);

        if(existRegister(groupContact)){
          yield PartnerEditing(partner: partner, type: event.editingType);
        } else {
          yield MatcherEditingFailure(partner: partner, partnerType: event.editingType, newMatchType: newMatchType);
        }


      } else if(event is ExitMatcherButtonPressed){
        yield PartnerLoading();
        SubjectBase partner = await _getPartner(event.partnerId, event.type);
        yield PartnerEditing(partner: partner, type: event.type);
      }
  }

  Future<SubjectBase> _getPartner(String serverId, PartnerType type) async {
    SubjectBase partner;
    if(type == PartnerType.contact){
      partner = await ContactHelper().getItem(serverId);
    } else if(type == PartnerType.group){
      partner = await GroupHelper().getItem(serverId);
    }

    return partner;
  }

  String get contactId => _contactId;
  String get groupId => _groupId;
}