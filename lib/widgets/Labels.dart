import 'package:flutter/material.dart';

class LabelsWidget extends StatelessWidget {
  final String texto;
  final String textAccion;
  final String ruta;

  const LabelsWidget({
    Key key, 
    @required this.texto, 
    @required this.textAccion,
    @required this.ruta
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            this.texto,
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w300
            ),
          ),
          SizedBox(height: 10,),
          GestureDetector(
            onTap: (){
              Navigator.pushReplacementNamed(context, this.ruta);
            },
            child: Text(
              this.textAccion,
              style: TextStyle(
                color: Colors.blue[600],
                fontWeight: FontWeight.bold
              ),
            ),
          )
        ],
      ),
    );
  }
}