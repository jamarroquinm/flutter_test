import 'package:flutter/material.dart';
import 'package:learning_flutter/DBBasics/blocs/DatabaseBloc.dart';
import 'package:learning_flutter/DBBasics/models/ClientModel.dart';

import 'dart:math' as math;


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // data for testing
  List<Client> testClients = [
    Client(firstName: "Raouf", lastName: "Rahiche", blocked: false),
    Client(firstName: "Zaki", lastName: "Oun", blocked: true),
    Client(firstName: "Oussama", lastName: "Ali", blocked: false),
    Client(firstName: "Cranam", lastName: "Zoule", blocked: false),
  ];

  ClientsBloc bloc;

  @override
  void initState() {
    bloc = ClientsBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter SQLite")),
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _getButtonsRow(),
          Flexible(
            fit: FlexFit.loose,
            child: _getStreamBuilder(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          bloc.getClients();
        },
      ),
    );
  }

  StreamBuilder _getStreamBuilder(){
    return StreamBuilder<List<Client>>(
      stream: bloc.clients,
      builder: (BuildContext context, AsyncSnapshot<List<Client>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              Client item = snapshot.data[index];
              return Dismissible(
                key: UniqueKey(),
                background: Container(color: Colors.red),
                onDismissed: (direction) {
                  bloc.delete(item.id);
                },
                child: ListTile(
                  title: Text(item.lastName),
                  leading: Text(item.id.toString()),
                  trailing: Checkbox(
                    onChanged: (bool value) {
                      bloc.toggleBlock(item);
                    },
                    value: item.blocked,
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Row _getButtonsRow(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: EdgeInsets.all(0.0),
          child: RaisedButton(
            onPressed: () async {
              Client newClient = testClients[math.Random().nextInt(testClients.length)];
              bloc.add(newClient);
            },
            child: Text('Agregar'),
          ),
        ),
        Container(
          padding: EdgeInsets.all(0.0),
          child: RaisedButton(
            onPressed: () async {
              bloc.deleteLast();
            },
            child: Text('Borrar último'),
          ),
        ),
        Container(
          padding: EdgeInsets.all(0.0),
          child: RaisedButton(
            onPressed: () async {
              bloc.deleteAll();
            },
            child: Text('Borrar todos'),
          ),
        ),

      ],
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}