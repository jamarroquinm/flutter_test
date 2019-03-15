import 'package:flutter/material.dart';
import 'dart:async';
import 'WebserviceBack.dart';
import 'WebserviceModel.dart';

class WebserviceUI extends StatefulWidget {
  @override
  _WebserviceUIState createState() => _WebserviceUIState();
}

class _WebserviceUIState extends State<WebserviceUI> {
  WebserviceModel _model;
  final _fieldController = TextEditingController();


  @override
  void initState(){
    _model = WebserviceModel();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('consumiendo servicios')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('Texto estático'),
            TextFormField(
              decoration: InputDecoration(hintText: 'Email address', fillColor: Colors.white, filled: true),
              keyboardType: TextInputType.emailAddress,
              controller: _fieldController,
            ),
            RaisedButton(
              onPressed: getModel,
              child: Text('invoke'),
            ),
            Text(
                _model != null && _model.serviceInvoked
                    ? _model.toString()
                    : ''
            ),
/*
            Positioned(
              top: 80.0,
              child: FutureBuilder(
                  future: getModel(),
                  initialData: "Loading text..",
                  builder: (BuildContext context, AsyncSnapshot result) {
                    bool es = result.data is WebserviceModel;
                    print('resultado: $es');
                    if(result.connectionState == ConnectionState.done){
                      return Text(result.data.toString());
                    } else {
                      return Text('');
                    }
                  }),
            ),
*/
/*
            Container(
              padding: EdgeInsets.only(top: 20.0),
              child: Text('zzzzzzzzzz'),
            ),
*/
          ],
        ),
      ),
    );
  }

  void getModel() {
    String email = _fieldController.text;
    WebserviceBack().getModel(email).then((model){
      setState(() {
        _model = model;
      });
    });
  }
}
