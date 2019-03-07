import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:learning_flutter/LoginEffects/backend/enums/exports.dart';
import 'package:learning_flutter/LoginEffects/bloc/exports.dart';
import 'package:learning_flutter/LoginEffects/bloc/module_partners/exports.dart';
import 'package:learning_flutter/LoginEffects/ui/module_partners/exports.dart';
import 'package:learning_flutter/LoginEffects/ui/ProgressDisplay.dart';

class PartnersController extends StatefulWidget {
  final MainBloc mainBloc;
  final bool isEdition;

  PartnersController({@required this.mainBloc,
    this.isEdition = true}) :assert(mainBloc != null);

  @override
  State<PartnersController> createState() => _PartnersControllerState();
}

class _PartnersControllerState extends State<PartnersController> {
  MainBloc _mainBloc;
  PartnerBloc _partnerBloc;
  bool _isEdition;

  @override
  void initState() {
    _mainBloc = widget.mainBloc;
    _isEdition = widget.isEdition;
    _partnerBloc = PartnerBloc(mainBloc: _mainBloc, isEdition: _isEdition);
    _partnerBloc.dispatch(PartnerInitiated());
    super.initState();
  }

  @override
  void dispose() {
    _partnerBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartnerEvent, PartnerState>(
      bloc: _partnerBloc,
      builder: (BuildContext context, PartnerState state) {
        print('PartnerController: ${state.toString()}');

        if (state is PartnerLoading) {
          return ProgressDisplay();

        } else if (state is PartnerListing) {
          if(state.type == PartnerType.contact){
            return ContactsPage(partnerBloc: _partnerBloc);
          } else if(state.type == PartnerType.group){
            return GroupsPage(partnerBloc: _partnerBloc);
          }

        } else if (state is PartnerEditing) {
          if(state.type == PartnerType.contact){
            return ContactPage(partnerBloc: _partnerBloc, partner: state.partner);
          } else if(state.type == PartnerType.group){
            return GroupPage(partnerBloc: _partnerBloc, partner: state.partner);
          }

        } else if (state is MatcherEditing) {
          if(state.partnerType == PartnerType.contact){
            return ContactGroupsPage(partnerBloc: _partnerBloc, partner: state.partner, newMatchType: state.newMatchType,);
          } else if(state.partnerType == PartnerType.group){
            return GroupContactsPage(partnerBloc: _partnerBloc, partner: state.partner, newMatchType: state.newMatchType,);
          }

        } else {
          return ProgressDisplay();
        }
      },
    );
  }

  bool get isEdition => _isEdition;
}