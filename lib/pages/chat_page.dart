import 'dart:io';

import 'package:chat_fer/models/mensaje_response.dart';
import 'package:chat_fer/services/auth_service.dart';
import 'package:chat_fer/services/chat_service.dart';
import 'package:chat_fer/services/socket_service.dart';
import 'package:chat_fer/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final TextEditingController _textEditingController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _estaEscribiendo = false;
  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);
    this.socketService.socket.on('mensaje-personal', _escucharMensaje);
    _cargarHistorial(this.chatService.usuarioDestino.uid);
  }

  void _cargarHistorial(String usuarioID) async {
    List<Mensaje> chat = await this.chatService.getChat(usuarioID);
    final history = chat.map((mensaje) => new ChatMessage(
      text: mensaje.mensaje, 
      uid: mensaje.de,
      animationController: new AnimationController(
          vsync: this,
          duration: new Duration(milliseconds: 0)
        )..forward()
      )
    );

    setState(() {
      _messages.insertAll(0, history);
    });
  }

 

  void _escucharMensaje(dynamic data) {
    final newMessage = new ChatMessage(
      uid: data['uid'], 
      text: data['mensaje'],
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200)
      ),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    final usuarioDestino = chatService.usuarioDestino;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              child: Text(usuarioDestino.nombre.substring(0,2), style: TextStyle(fontSize: 12),),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(height: 3,),
            Text(usuarioDestino.nombre, style: TextStyle(color: Colors.black87, fontSize: 12),)
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (_, i) => _messages[i],
                itemCount: _messages.length,
                reverse: true,
              ),
            ),
            Divider(height: 1,),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        )
     ),
   );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textEditingController,
                decoration: InputDecoration.collapsed(hintText: 'Escribe tu mensaje...'),
                focusNode: _focusNode,
                onSubmitted: _handleSubmit,
                onChanged: (String texto){
                  if(texto.trim().length > 0){
                    _estaEscribiendo = true;
                  }else {
                    _estaEscribiendo = false;
                  }
                  setState(() {
                    
                  });
                },
              ),
            ),
            // boton de enviar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: 
                Platform.isIOS 
                ? CupertinoButton(
                  child: Text('Enviar'),
                  onPressed: _estaEscribiendo ? () => _handleSubmit(_textEditingController.text.trim()) : null,
                ) :
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconTheme(
                    data:  IconThemeData(
                      color: Colors.blue[400]
                    ),
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.white,
                      icon: Icon(Icons.send), 
                      color: Colors.blue[400], 
                      onPressed: _estaEscribiendo ? () => _handleSubmit(_textEditingController.text.trim()) : null,
                    ),
                  ),
                )
                ,
            )

          ],
        ),
      ),
    );
  }

  _handleSubmit(String texto) {
    if(texto.length == 0) return;
    _textEditingController.clear();
    _focusNode.requestFocus();

    final usuarioEmisor = authService.usuario;

    final newMessage = new ChatMessage(
      uid: usuarioEmisor.uid, 
      text: texto,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200)
      ),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _estaEscribiendo = false;
    });

    this.socketService.emit('mensaje-personal',{
      'de': usuarioEmisor.uid,
      'para': chatService.usuarioDestino.uid,
      'mensaje': texto
    });
  } 

  @override
  void dispose() {
    // TODO: off del socket
    for(ChatMessage message in _messages){
      message.animationController.dispose();

    }
    this.socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}