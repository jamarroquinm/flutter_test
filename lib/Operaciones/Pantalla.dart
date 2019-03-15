import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart' as intl_local_date_data;


class Pantalla extends StatefulWidget {
  @override
  _PantallaState createState() => _PantallaState();
}

class _PantallaState extends State<Pantalla> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Operaciones')
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: Text(
            resultadoOperaciones(),
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      ),
    );
  }

  String resultadoOperaciones(){
    return _getDate('10/1/2012');
  }

  String _getDate(String value){
    DateTime _dateOfBirth;
    String code = 'en';

    List<String> partes = value.split('/');
    String resultado = '';
    for(String parte in partes){
      resultado += '$parte, ';
    }

    if(partes.length == 3){
      try {
        int day = code == 'en' ? int.parse(partes[1]) : int.parse(partes[0]);
        int month = code == 'en' ? int.parse(partes[0]) : int.parse(partes[1]);
        int year = int.parse(partes[2]);
        _dateOfBirth = DateTime(year, month, day);
        print(partes);
        print('$day - $month - $year');
        print('${_dateOfBirth.toString()}');
        return '${_dateOfBirth.month}';
      } catch (e) {
        _dateOfBirth = null;
        return 'La fecha no tiene el formato correcto';
      }
    } else {
      return 'La fecha no tiene el formato correcto';
    }

    return resultado;
/*
    try {
      _dateOfBirth = DateTime.parse(value);
      return '${_dateOfBirth.month}';
    } catch (e) {
      _dateOfBirth = null;
      return 'La fecha no tiene el formato correcto';
    }
*/

  }
}
