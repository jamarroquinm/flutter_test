import 'package:flutter/material.dart';

//el siguiente paquete se agregó bajo dependencies en pubspec.yaml
import 'package:english_words/english_words.dart';

/*
  Ejercicio basado en las partes 1 y 2 del tutorial que inicia en
  https://flutter.io/docs/get-started/codelab

  La aplicación consta de dos pantallas:
   - en la primera hay un listado "infinito" y scrollable de nombres random
     tomados de english_words que pueden seleccionarse o deseleccionarse
   - la seguna pantalla enlista los nombres elegidos en la primera pantalla

   Notas:
    - StartupNamerApp es la clase controladora, ejecutada desde main()
    - La primera pantalla es RandomWords
    - La segunda pantalla se crea al vuelo en el método _pushedSaved() de la
      la clase RandomWordsState
    - RandomWordsState guarda el estado de RandomWords y concentra su funcionalidad
    - La lista scrollable es un ListView
 */

class StartupNamerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: new ThemeData(
          primaryColor: Colors.yellow
      ),
      home: RandomWords(),
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushedSaved),
        ],
      ),
      body: _buildSuggestions(),
    );

  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: /*1*/ (context, i) {
        if(i.isOdd) return Divider(); /*2*/

        final index = i ~/ 2; /*3*/
        if(index >= _suggestions.length){
          _suggestions.addAll(generateWordPairs().take(10)); /*4*/
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair){
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
          pair.asPascalCase,
          style: _biggerFont
      ),
      trailing: new Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null
      ),
      onTap: () {
        setState(() {
          if(alreadySaved){
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushedSaved(){
    Navigator.of(context).push(
        new MaterialPageRoute<void>(
            builder: (BuildContext context) {
              final Iterable<ListTile> tiles = _saved.map(
                    (WordPair pair) {
                  return new ListTile(
                      title: new Text(
                          pair.asPascalCase,
                          style: _biggerFont
                      )
                  );
                },
              );
              final List<Widget> divided = ListTile
                  .divideTiles(
                  context: context,
                  tiles: tiles)
                  .toList();

              return new Scaffold(
                appBar: new AppBar(
                  title: const Text("Saved suggestions"),
                ),
                body: new ListView(children: divided),
              );
            }
        )
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}