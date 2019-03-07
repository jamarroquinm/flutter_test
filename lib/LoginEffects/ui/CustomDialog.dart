import 'package:flutter/material.dart';
import 'package:learning_flutter/LoginEffects/backend/enums/exports.dart';

class CustomDialog extends StatelessWidget {
  final DialogState state;

  CustomDialog({this.state});

  @override
  Widget build(BuildContext context) {
    return state == DialogState.DISMISSED ? Container() : _getAlert();
  }

  AlertDialog _getAlert(){
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      content: Container(
        width: 250.0,
        height: 100.0,
        child: state == DialogState.LOADING
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                "Procesando...",
                style: TextStyle(
                  fontFamily: "OpenSans",
                  color: Color(0xFF5B6978),
                ),
              ),
            )
          ],
        )
            : Center(
          child: Text('Proceso exitoso'),
        ),
      ),
    );
  }
}