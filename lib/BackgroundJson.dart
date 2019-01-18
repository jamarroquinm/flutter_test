import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


/*
  Aplicación que ilustra el consumo de un webservice tipo GET en segundo plano y
  otro tipo POST en el que se envían una serie de datos en un json para crear un
  nuevo registro para que, en caso de éxito, el servidor devuelva el id del nuevo
  registro.

  Para tareas en segundo plano se utiliza la función compute(), que ejecuta
  acciones de gran carga o duración en un isolate.
  Los isolates de Dart son actores independientes parecidos a los threads
  aunque no comparten memoria y se comunican solo mediante mensajes; estos mensajes
  pueden ser tipos primitivos (null, int, bool, etc.) u objetos simples (como
  List); pasar objetos complejos podría producir errores.
  Los métodos que se ejecutan en un isolate no pueden ser de instancia por lo que
  deben mantenerse en el nivel principal de la aplicación.

  Para este ejercicio se consume el Rest de pruebas de
  https://jsonplaceholder.typicode.com/

  Notas:
  -----
  *1* Image.network(url) es el método que permite abrir imágenes desde la web
  *2* Se usa la función compute en fetchPhotos() para ejecutar parsePhotos() en
      un isolate
 */


//clase principal invocada desde main() que abre MainRoute como primera route
class GetPostWSStarter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Webservice GET y POST';

    return MaterialApp(
      title: appTitle,
      home: MainRoute(),
    );
  }
}


//La clase que representa la pantalla inicial
class MainRoute extends StatefulWidget{
  @override
  MainRouteState createState() => MainRouteState();
}


/*
  Esta clase guarda el estado de MainRoute y controla el funcionamiento de la misma:
   - Muestra dos botones para navegar a las pantallas secundarias
   - Un botón abre PhotoRoute para recuperar un listado de fotos via GET en
     segundo plano
   - Otro botón abre PostHolder para simular la creación de un registro en un
     servidor vía POST, para lo cual se crea un objeto PostHolder con los datos
     a registrar, y que se pasan como json, y el url del webservice
 */
class MainRouteState extends State<MainRoute>{
  bool _getPhotos = false;
  bool _postData = false;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Consumo de webservice'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Descarga fotos'),
                  onPressed: () {
                    _getPhotos = true;
                    _postData = false;
                    _runAction();
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Post data'),
                  onPressed: () {
                    _getPhotos = false;
                    _postData = true;
                    _runAction();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _runAction() {
    setState(() {
      if(_getPhotos){
        //abrir pantalla de fotos
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PhotoRoute(title: 'Galería',)),
        );
      } else if(_postData){
        //abrir pantalla de post
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              PostRoute(
                title: 'Carga de datos',
                postSent: PostHolder(
                    id: 0,
                    title: 'Alta de permisos',
                    body: 'Se otorga permiso de acceso a los servidores de producción',
                    userId: 560),
                url: 'https://jsonplaceholder.typicode.com/posts',
          )),
        );
      }
    });
  }
}



/*
************************************************************
 Pantalla y auxiliares para consumir el webservice de photos
*/

/*
  Representa el display principal para lo que invoca el método que consume el
  el webservice y muestra el resultado
   - Si hay datos, se muestra el listado generado en PhotosList
   - Si no hay datos, se mantiene un CircularProgressIndicator en pantalla
 */
class PhotoRoute extends StatelessWidget {
  final String title;

  PhotoRoute({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Photo>>(
        future: fetchPhotos(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? PhotosList(photos: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}


/*
  A partir del json recuperado del webservice se muestra un listado de fotos
  cada una de las cuales se recupera individualmente usando la url definida en
  thumbnailUrl en el json del response
 */
class PhotosList extends StatelessWidget {
  final List<Photo> photos;

  PhotosList({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Image.network(photos[index].thumbnailUrl); //*1*
      },
    );
  }
}


//Holder o contenedor de los datos de cada ítem descargado
class Photo {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  Photo({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      albumId: json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}


/*
  Método que ejecuta la llamada http al webservice y devuelve la lista de
  objetos Photo invocando el método parsePhotos(). Se ejecuta junto con
  parsePhotos() en un isolate
 */
Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response =
  await client.get('https://jsonplaceholder.typicode.com/photos');

  return compute(parsePhotos, response.body); //*2*
}

// Genera la lista de objetos Photo a partir del response
List<Photo> parsePhotos(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}
//************************************************************



/*
************************************************************
 Pantalla y auxiliares para hacer un post vía webservice
*/

/*
  Es la clase que representa la pantalla de consumo de webservice POST, invoca
   dicho servicio y presenta el resultado. Los datos para ello se reciben en su
   constructor
*/
class PostRoute extends StatelessWidget {
  final String title;
  final PostHolder postSent;
  final String url;

  PostRoute({Key key, this.title, @required this.postSent, @required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<PostHolder>(
        future: post(url, postSent.getJsonString()),
        builder: (context, snapshot) {
          return snapshot.hasError
            ? Text(snapshot.error.toString())
            :  snapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : buildPostDisplay(snapshot, postSent);
        },
      ),
    );
  }

  //el método que arma el resultado a mostrar a partir del response del webservice
  Widget buildPostDisplay(AsyncSnapshot snapshot, PostHolder postResponseSent){
    Widget result;

    if(snapshot.connectionState != ConnectionState.done){
      result = Text('proceso sin concluir...');
    }

    if (snapshot.hasError) {
      result = Text(
        '${snapshot.error}',
        style: TextStyle(color: Colors.red),
      );
    } else if(snapshot.data == null){
      result = Text('No data returned by server');
    }

    PostHolder postResponseNew = snapshot.data as PostHolder;
    if(postResponseNew.id == null){
      result = Text('[No data returned by server]');
    } else if(postResponseNew.id <= 0 ){
      result = Text('[No valid id returned by server]');
    } else {
      result = Text(
          'Id de nuevo registro: ${postResponseNew.id}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      );
    }

    Widget dataToDisplay = Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Se creó un nuevo registo con los siguientes datos:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          Text(
            'título: ${postResponseSent.title}',
            style: TextStyle(fontSize: 20.0),
          ),
          Text(
            'Cuerpo: ${postResponseSent.body}',
            style: TextStyle(fontSize: 20.0),
          ),
          Text(
            'Id de usuario: ${postResponseSent.userId}',
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(height: 20.0),
          result,
        ],
      ),
    );

    return dataToDisplay;
  }
}

/*
  Método auxiliar que invoca el webservice POST. A diferencia de fetchPhotos(),
  este método no corre en un isolate dada la poca carga de datos y tiempo que se
  estima y por lo mismo no recurre a un segundo método para parsear el json del
  response
 */
Future<PostHolder> post(String url, var body)async{
  return await http
    .post(Uri.encodeFull(url), body: body, headers: {"Accept":"application/json"})
    .then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }

      final jsonResponse  = json.decode(response.body);
      PostHolder postResponse = PostHolder.fromJson(jsonResponse);

      return postResponse;
    }
  );
}


//Holder o contenedor de los datos recibidos en respuesta al POST
class PostHolder {
  final int id;
  final String title;
  final String body;
  final int userId;

  PostHolder({this.id, this.title, this.body, this.userId});

  factory PostHolder.fromJson(Map<String, dynamic> json) {
    return PostHolder(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      userId: json['userId'],
    );
  }

  String getJsonString(){
    var result = jsonEncode({
      'title': title,
      'body': body,
      'userId': userId
    });

    return result;
  }
}

//************************************************************
