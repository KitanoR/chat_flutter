
import 'package:chat_fer/services/chat_service.dart';
import 'package:chat_fer/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_fer/models/usuario.dart';
import 'package:chat_fer/services/auth_service.dart';
import 'package:chat_fer/services/socket_service.dart';

class UsuariosPage extends StatefulWidget {

  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final usuarioService = UsuariosService();
  List<Usuario> usuarios = [];

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    this._cargarUsuarios();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final providerAuth = Provider.of<AuthService>(context);
    final socketProvider = Provider.of<SocketService>(context);

    final usuario = providerAuth.usuario;
    return Scaffold(
      appBar: AppBar(
        title: Text(usuario.nombre, style: TextStyle(color: Colors.black87),),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.black87),
          onPressed: () async {
            socketProvider.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          },
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socketProvider.serverStatus == ServerStatus.Online ? 
              Icon(Icons.check_circle, color: Colors.blue[400],)
              :
              Icon(Icons.offline_bolt, color: Colors.red,),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400],),
          waterDropColor: Colors.blue[400],
        ),
        child: _listViewUsuarios(),
      ),
   );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      separatorBuilder: (_, i) => Divider(), 
      itemCount: usuarios.length,
      itemBuilder: (_, i) => _usuarioListTile(usuarios[i]), 
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
        title: Text(usuario.nombre),
        subtitle: Text(usuario.email),
        leading: CircleAvatar(
          child: Text(usuario.nombre.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        trailing: Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: usuario.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
        onTap: () {
          final chatService = Provider.of<ChatService>(context, listen: false);
          chatService.usuarioDestino = usuario;
          Navigator.pushNamed(context, 'chat');
        },
      );
  }

  _cargarUsuarios() async{
    // monitor network fetch
    this.usuarios = await usuarioService.getUsuario();
    setState(() {
      
    });
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}

