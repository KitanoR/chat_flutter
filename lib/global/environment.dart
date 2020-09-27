import 'dart:io';

class Enviroment {
  static String apiUrl = Platform.isAndroid ? 'http://192.168.1.4:3000/api' :'http://localhost:3000/api' ;
  static String apiUrlSocket = Platform.isAndroid ? 'http://192.168.1.4:3000' :'http://localhost:3000' ;
}