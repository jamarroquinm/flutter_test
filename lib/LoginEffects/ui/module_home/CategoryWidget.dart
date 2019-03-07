import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:learning_flutter/LoginEffects/backend/enums/exports.dart';
import 'package:learning_flutter/LoginEffects/backend/exports.dart';
import 'package:learning_flutter/LoginEffects/bloc/module_home/exports.dart';

class CategoryWidget extends StatefulWidget {
  final HomeWidgetsBloc homeWidgetsBloc;

  CategoryWidget({
    Key key,
    @required this.homeWidgetsBloc,
  }) : super(key: key);

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
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
              Container(
                child: Center(
                    child: RaisedButton(
                      child: Text('Salud'),
                      onPressed: _enableButton(Category.health) ? (){
                        homeWidgetsBloc.dispatch(ChangeCategoryButtonPressed(category: Category.health));
                      } : null,
                    )
                ),
              ),
              Container(
                child: Center(
                    child: RaisedButton(
                      child: Text('Amor'),
                      onPressed: _enableButton(Category.love) ? (){
                        homeWidgetsBloc.dispatch(ChangeCategoryButtonPressed(category: Category.love));
                      } : null,
                    )
                ),
              ),
              Container(
                child: Center(
                    child: RaisedButton(
                      child: Text('Dinero'),
                      onPressed: _enableButton(Category.money) ? (){
                        homeWidgetsBloc.dispatch(ChangeCategoryButtonPressed(category: Category.money));
                      } : null,
                    )
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _enableButton(Category buttonCategory){
    return !(buttonCategory == appInstance.category);
  }
}
