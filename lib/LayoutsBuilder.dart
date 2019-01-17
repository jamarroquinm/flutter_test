import 'package:flutter/material.dart';

/*
  Ejercicio tomado de
  https://flutter.io/docs/development/ui/layout
  https://github.com/flutter/website/blob/master/src/_includes/code/layout/lakes-interactive/main.dart

  La aplicación es una pantalla estática que muestra el acomodo de elementos típicos:
   - Una imagen que cubre la mitad superior
   - Textos que funcionan como título y subtítulos
   - Contador numérico de "favoritos" junto con ícono de estrella seleccionable
   - Menu de textos con íconos (no funcional) para llamar, enviar y compartir
   - Párrafo de texto libre

  Notas:
   - LayoutsBuilderApp es la clase principal, invocada desde main()
   - LayoutsBuilderApp controla el layout desde build()
     . Las principales secciones del layout se separaron para mejorar el código
     . _titleSection coloca el título y subtítulo y llama al widget de "favoritos"
     . _buttonSection coloca los textos y botones del menú; dado que cada una
       de las tres opciones de este "menú" tiene la misma estructura, se agregó
       el método _buildButtonColumn que construye cada ítem
     . _textSection coloca un texto libre
     . la imagen usada está en el directorio físico ..\learning_flutter\images\
       cuya referencia debe agregarse en pubspec.yaml bajo assets; ahí la ruta
       es relativa a dicho archivo pubspec.yaml
   - La funcionalidad de seleccionar/deseleccionar el ícono de "favoritos"
     incrementa o decrementa el contador; ya que esto cambia el estado de la
     aplicación se requiere una clase que herede de StatefulWidget, en este caso
     es FavoriteWidget, cuyo estado lo guarda _FavoriteWidgetState
 */

class LayoutsBuilderApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Color _color = Theme.of(context).primaryColor;


    Widget _titleSection = Container(
        padding: const EdgeInsets.all(32.0),
        child: Row(
            children: [
              Expanded(
                //una columna en un Expand ocupa el espacio disponible
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, //al inicio del row
                    children: [
                      Container(
                        //el texto en un Container para definir el padding
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Oeschinen Lake Campground',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        'Kandersteg, Switzerland',
                        style: TextStyle(color: Colors.grey[500]),
                      )
                    ],
                  )
              ),
              FavoriteWidget(),
              /////
            ]
        )
    );

    Widget _buttonSection = Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButtonColumn(_color, Icons.call, 'CALL'),
            _buildButtonColumn(_color, Icons.near_me, 'ROUTE'),
            _buildButtonColumn(_color, Icons.share, 'SHARE'),
          ],
        ));


    Widget _textSection = Container(
      padding: const EdgeInsets.all(32.0),
      child: Text(
        'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese '
            'Alps. Situated 1,578 meters above sea level, it is one of the '
            'larger Alpine Lakes. A gondola ride from Kandersteg, followed by a '
            'half-hour walk through pastures and pine forest, leads you to the '
            'lake, which warms to 20 degrees Celsius in the summer. Activities '
            'enjoyed here include rowing, and riding the summer toboggan run.',
        softWrap: true,
      ),
    );


    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Top Lakes'),
        ),
        body: ListView(
          children: [
            Image.asset(
              'images/lake.jpg',
              height: 240.0,
              fit: BoxFit.cover,
            ),
            _titleSection,
            _buttonSection,
            _textSection,
          ],
        ),
      ),
    );
  }

  static Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class FavoriteWidget extends StatefulWidget{
  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget>{
  bool _isFavorited = true;
  int _favoriteCount = 41;

  void _toggleFavorite() {
    setState(() {
      if(_isFavorited){
        _favoriteCount -= 1;
        _isFavorited = false;
      } else {
        _favoriteCount += 1;
        _isFavorited = true;
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(0.0),
          child: IconButton(
            icon: (
                _isFavorited ? Icon(Icons.star) : Icon(Icons.star_border)
            ),
            color: Colors.red,
            onPressed: _toggleFavorite,
          ),
        ),
        SizedBox(
          width: 18.0,
          child: Container(
              child: Text('$_favoriteCount')
          ),
        ),
      ],
    );
  }
}