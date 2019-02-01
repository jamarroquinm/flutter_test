import 'dart:async';

import 'package:learning_flutter/DBBasics/models/ClientModel.dart';
import 'package:learning_flutter/DBBasics/backend/Database.dart';

class ClientsBloc {
  final _clientController = StreamController<List<Client>>.broadcast();

  ClientsBloc() {
    getClients();
  }

  Stream get clients => _clientController.stream;

  void add(Client client) {
    DBProvider.db.newClient(client);
    getClients();
    getClients();
  }

  void update(Client client) {
    DBProvider.db.updateClient(client);
    getClients();
  }

  void toggleBlock(Client client) {
    DBProvider.db.blockOrUnblock(client);
    getClients();
  }

  void delete(int id) {
    DBProvider.db.deleteClient(id);
    getClients();
  }

  void deleteAll() {
    DBProvider.db.deleteAll();
    getClients();
  }

  void deleteLast() {
    DBProvider.db.deleteLast();
    getClients();
  }

  void getClients() async {
    _clientController.sink.add(await DBProvider.db.getAllClients());
  }

  void dispose() {
    _clientController.close();
  }
}
