import 'package:flutter/material.dart';
import 'CalendarPainter.dart';
import 'dart:math';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String campo1;
  final FocusNode _campo1Focus = FocusNode();
  final FocusNode _campo2Focus = FocusNode();
  final FocusNode _campo3Focus = FocusNode();
  final _campo1Controller = TextEditingController();
  final _campo2Controller = TextEditingController();
  final _campo3Controller = TextEditingController();

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int month = 2;
    int year = 2019;
    Map<DateTime, Color> highlightedDates = {
      DateTime(2019, 2, 3) : Colors.lime,
      DateTime(2019, 2, 3) : Colors.lime,
      DateTime(2019, 2, 25) : Colors.yellow,
      DateTime(2019, 3, 3) : Colors.lime,
    };

    _campo1Focus.addListener(_validateCampo1Value);

    Offset _tapPosition;

    void _handleTapDown(TapDownDetails details) {
      final RenderBox referenceBox = context.findRenderObject();
      setState(() {
        _tapPosition = referenceBox.globalToLocal(details.globalPosition);
        print('${_tapPosition.dx}, ${_tapPosition.dy}');

      });
    }

    return MaterialApp(
      home: Scaffold(
        //resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text("Calendario")),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                CustomPaint(
                  child: Container(height: 200,),
                  painter: CalendarPainter(
                    month: month,
                    year: year,
                    selectionCallback: selectDate,
                    highlightedDates: highlightedDates,
                    backgroundColor: Colors.purple,
                    daysNameFillColor: Colors.deepPurpleAccent,
                    daysNameTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    daysTextStyle: TextStyle(color: Colors.white),
                  ),
                ),
                Form(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        //autofocus: true,
                        focusNode: _campo1Focus,
                        textInputAction: TextInputAction.next,
                        validator: (String value) => (value == null || value == '') ? "falta campo 1" : null,
                        keyboardType: TextInputType.text,
/*
                      onFieldSubmitted: (term){
                        _onFieldSubmitted(context, _campo1Focus, _campo2Focus, _validateCampo1Value);
                      },
*/
                        controller: _campo1Controller,
                      ),
                      TextFormField(
                        focusNode: _campo2Focus,
                        textInputAction: TextInputAction.next,
                        validator: (String value) => (value == null || value == '') ? "falta campo 2" : null,
                        keyboardType: TextInputType.text,
                        controller: _campo2Controller,
                      ),
                      TextFormField(
                        focusNode: _campo3Focus,
                        textInputAction: TextInputAction.done,
                        validator: (String value) => (value == null || value == '') ? "falta campo 1" : null,
                        keyboardType: TextInputType.text,
                        controller: _campo3Controller,
                      ),
                      RaisedButton(
                        onPressed: _grabarForm,
                        child: Text('Grabar'),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void selectDate(int selectedDay) {
    print('Home: día elegido=$selectedDay');
  }

  void _grabarForm(){
    print('_grabarForm()');
  }

  void _onEditingComplete(){
    print('_onEditingComplete');
  }

  void _onFieldSubmitted(BuildContext context, FocusNode currentFocus,
    FocusNode nextFocus, Function function){

    if(currentFocus != null){
      currentFocus.unfocus();
    }

    if(nextFocus != null){
      FocusScope.of(context).requestFocus(nextFocus);
    }

    if(function != null){
      function();
    }
 }

  @override
  void dispose() {
    _campo1Focus.dispose();
    super.dispose();
  }
  
  void _validateCampo1Value(){
    if(!_campo1Focus.hasFocus){
      print('campo1 pierde el foco');
      if(_campo1Controller.text == null || _campo1Controller.text == ''){
        campo1 = null;
        print('campo1 está vacío, no se valida');
      } else if(campo1 != null &&
          campo1 != '' &&
          campo1 == _campo1Controller.text) {
        print('campo1 ya fue validado');
      } else {
        print('inicia validación de campo1');
        bool validacion = _randomValidation();
        validacion = false;
        if(validacion){
          campo1 = _campo1Controller.text;
          print('campo1 pasó la validación');
        } else {
          _campo2Focus.unfocus();
          FocusScope.of(context).autofocus(_campo1Focus);
          print('campo1 es inválido');
        }
      }
    } else {
      print('campo1 gana el foco');
    }
  }

  bool _randomValidation(){
    var rng = new Random();
    return rng.nextBool();
  }
}