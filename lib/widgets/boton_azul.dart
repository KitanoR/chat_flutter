import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final String texto;
  final Function onPressed;
  final bool loader;

  const BotonAzul({
    Key key, 
    @required this.texto, 
    this.onPressed,
    this.loader = false
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        elevation: 2,
        highlightElevation: 5,
        color: Colors.blue,
        padding: EdgeInsets.all(0.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        onPressed: onPressed,
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF0575E6), Color(0xff021B79)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight),
              borderRadius: BorderRadius.circular(30.0)),
          child: Container(
            width: double.infinity,
            height: 55,
            child: Center(
              child: loader ? CircularProgressIndicator() 
              :
              Text(
                texto,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ));
  }
}
