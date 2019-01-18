import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';   //*1*
import 'package:http/http.dart' as http;  //*2*
import 'package:url_launcher/url_launcher.dart';  //*3*

/*
  Aplicación para consumir un webservice y deserializar el json recibido. Se
  consumen las notas de Hacker News y según la API que se expone en
  https://github.com/HackerNews/API, las llamadas tienen la forma
    https://hacker-news.firebaseio.com/v0/item/<id>.json
  que formateadas es
    https://hacker-news.firebaseio.com/v0/item/<id>.json?print=pretty

  Notas
  -----
   *1*  Se importó gestures.dart para cachar el tap sobre un texto
   *2*  http es una biblioteca para hacer requests http; la dependencia se
        agregó a pubspec.yaml como http: 0.12.0+1
   *3*  url_launcher es una biblioteca para abrir una url en el navegador del
        móvil desde flutter; la dependencia se agregó a pubspec.yaml como
        url_launcher: 4.0.3
   *4*  Se define la firma de una función para pasarla como parámetro; esta
        técnica permite pasar la función _setIdItem desde _SendRequestState a
        URLInput para que en esta última clase se haga una actualización de la url
        y el estado a partir del input del usuario
   *5*  Se espera como input el id numérico de la nota en Hacker News, pero a falta
        de validación en este ejercicio se hace una verificación posterior del
        input; si no es numérico o es negativo se usa 0
   *6*  Se simula un hiperlink cachando el tap sobre un texto y usando url_launcher
   *7*  factory se usa para devolver una instancia que no necesariamente se está
        creando; podria devolver una del caché o la instancia de una subclase


  Clases
  ------
  InvokerStarter es widget principal, invocado por main()

  SendRequestPage es el widget en pantalla

  _SendRequestState conserva el estado de SendRequestPage y su funcionalidad;
  carga en pantalla dos widgets:
    - URLInput con el text field para el input del usuario
    - RequestSender para mostrar un resultado si el usuario introduce una url

  RequestSender hace el request http y controla el display del resultado
    - Con el parámetro introducido por el usuario se completa el url que se
      pasará el FutureBuilder para obtener el future
    - Luego de realizado el future se obtiene un AsyncSnapshot; en éste los estados
      posibles del connectionState son:
      . none: el future es null (ya que la url lo es también)
      . waiting: request en progreso, se muestra CircularProgressIndicator
      . active: no se aplica a Future (pero sí a Stream), se muestra un texto vacío
      . done: request concluido; se muestra el resultado o el error
    - el método buildMessage() da forma al displey del resultado
      . un texto vacío si la respuesta fue nula o fracasó la deserialización
      . título de la nota, autor y url

  URLInput es el widget que muestra un TextField para el input del usuario; en su
  callback se devuelve la implementación de la función SetIdItem con el input
  del usuario como parámetro

  PostHolder es el holder con los campos de los post de Hacker News según su API;
  actualmente solo incluye la deserialización pero en esa misma clase se agregaría
  la serialización
 */


class InvokerStarter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Prueba de lectura de post de Hacker News',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SendRequestPage(title: 'Prueba de lectura de post de Hacker News'),
    );
  }
}


typedef SetIdItem = Function(String strIdItem); //*4*

class URLInput extends StatelessWidget {
  URLInput(this.setIdItem, {Key key}) : super(key: key);

  final SetIdItem setIdItem;

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.all(10.0),
      child: new Row(
        children: <Widget>[
          new Expanded(child: new TextField(
            decoration: InputDecoration(
                hintText: 'Escribe el id del item en Hacker News'
            ),
            onSubmitted: setIdItem,
          ))
        ],
      ),
    );
  }
}


class RequestSender extends StatelessWidget {
  RequestSender(this.strIdItem, {Key key}) : super(key: key);

  final String strIdItem;

  @override
  Widget build(BuildContext context) {

    int _idItem = 0;  //*5*
    if(strIdItem != null){
      int tmp = int.tryParse(strIdItem);
      if(tmp != null && tmp > 0){
        _idItem = tmp;
      }
    }
    String url = 'https://hacker-news.firebaseio.com/v0/item/$_idItem.json';
    return new Container(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
            future: http.get(url).then((response) => response.body),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return new Text('Input a URL to start');
                case ConnectionState.waiting:
                  return new Center(child: new CircularProgressIndicator());
                case ConnectionState.active:
                  return new Text('');
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return new Text(
                      '${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    );
                  } else {
                    if(snapshot.data != null){
                      return buildMessage(snapshot);
                    }
                    return new Text('');
                  }
              }
            }));
  }

//crea el display resultante con el json recuperado
  Widget buildMessage(AsyncSnapshot snapshot){
    if(snapshot == null){
      return new Text('');
    }

    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return new Text('Input a URL to start');
      case ConnectionState.waiting:
        return new Center(child: new CircularProgressIndicator());
      case ConnectionState.active:
        return new Text('');
      case ConnectionState.done:
        if (snapshot.hasError) {
          return new Text(
            '${snapshot.error}',
            style: TextStyle(color: Colors.red),
          );
        } else if(snapshot.data == null || snapshot.data == 'null'){
          return new Text('');
        }
    }

    PostHolder post;

    try{
      post = PostHolder.fromJson(json.decode(snapshot.data));
    } catch(e){
      return Text(e.toString());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8.0, left: 8.0, bottom: 16.0),
          child: Text(
            post.title,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            'by ${post.by}',
            style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: getHyperlink(post.url, post.url),
        ),
      ],
    );
  }


  RichText getHyperlink(String text, String url){ //*6*
    return new RichText(
        text: new TextSpan(
          text: text,
          style: new TextStyle(fontSize: 16.0, color: Colors.blue),
          recognizer: new TapGestureRecognizer()
            ..onTap = () {
              launch(url);
            },
        )
    );
  }
}


class SendRequestPage extends StatefulWidget {
  SendRequestPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SendRequestState createState() => new _SendRequestState();
}


class _SendRequestState extends State<SendRequestPage> {
  String _strIdItem;

  void _setIdItem(String strIdItem) {
    setState(() {
      _strIdItem = strIdItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
            new URLInput(_setIdItem),
            new Expanded(child: new RequestSender(_strIdItem))
          ],
        ),
      ),
    );
  }
}


class PostHolder {
  final int id;	              //The item's unique id
  final String deleted;	      //true if the item is deleted
  final String type;	        //The type of item. One of "job", "story", "comment", "poll", or "pollopt"
  final String by;	          //The username of the item's author
  final int time;	            //Creation date of the item, in Unix Time (seconds since 19700101T000000)
  final String text;	        //The comment, story or poll text. HTML
  final String dead;	        //true if the item is dead
  final String parent;	      //The comment's parent: either another comment or the relevant story
  final String poll;	        //The pollopt's associated poll
  final List<dynamic> kids;	  //The ids of the item's comments, in ranked display order
  final String url;	          //The URL of the story
  final int score;	          //The story's score, or the votes for a pollopt
  final String title;	        //The title of the story, poll or job
  final List<dynamic> parts;	//A list of related pollopts, in display order
  final int descendants;	    //In the case of stories or polls, the total comment count

  PostHolder({this.id,
    this.deleted,
    this.type,
    this.by,
    this.time,
    this.text,
    this.dead,
    this.parent,
    this.poll,
    this.kids,
    this.url,
    this.score,
    this.title,
    this.parts,
    this.descendants});

  //deserialización
  factory PostHolder.fromJson(Map<String, dynamic> json) {  //*7*
    return PostHolder(
      id: json['id'],
      deleted: json['deleted'],
      type: json['type'],
      by: json['by'],
      time: json['time'],
      text: json['text'],
      dead: json['dead'],
      parent: json['parent'],
      poll: json['poll'],
      kids: json['kids'],
      url: json['url'],
      score: json['score'],
      title: json['title'],
      parts: json['parts'],
      descendants: json['descendants'],
    );
  }

  //serialización
  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'deleted': deleted,
        'type': type,
        'by': by,
        'time': time,
        'text': text,
        'dead': dead,
        'parent': parent,
        'poll': poll,
        'kids': kids,
        'url': url,
        'score': score,
        'title': title,
        'parts': parts,
        'descendants': descendants,
      };
}


