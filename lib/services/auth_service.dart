import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


import 'package:chat_fer/global/environment.dart';
import 'package:chat_fer/models/login_response.dart';
import 'package:chat_fer/models/usuario.dart';

class AuthService with ChangeNotifier {

  Usuario _usuario;
  bool _loader = false;
  final _storage = new FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    final data = {
      'email': email,
      'password': password
    };
    this.loader = true;
    final resp = await http.post('${Enviroment.apiUrl}/login',
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );
    this.loader = false;
    if(resp.statusCode == 200){
      final response = loginResponseFromJson(resp.body);
      this._usuario = response.usuario;
      await this._guardarToken(response.token);
      return true;
    }
    return false;

  }

  Future<bool> register(String nombre, String email, String password) async {
    final data = {
      'nombre': nombre,
      'email': email,
      'password': password
    };
    this.loader = true;
    final resp = await http.post('${Enviroment.apiUrl}/login/new',
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );
    this.loader = false;
    if(resp.statusCode == 200){
      final response = loginResponseFromJson(resp.body);
      this._usuario = response.usuario;
      await this._guardarToken(response.token);
      return true;
    }
    final respBody = jsonDecode(resp.body);
    return respBody['msg'];
  }

  Future<bool> isLoggedIn()  async {
    final token = await _storage.read(key: 'token');
    final resp = await http.get('${Enviroment.apiUrl}/login/renew/',
      headers: {
        'Content-Type': 'application/json',
        'x-token': token
      }
    );
    if(resp.statusCode == 200){
      final response = loginResponseFromJson(resp.body);
      this._usuario = response.usuario;
      await this._guardarToken(response.token);
      return true;
    }
    this.logout();
    return false;

  }



  /// getters
  bool get loader => this._loader;

  set loader(bool loader){
    this._loader = loader;
    notifyListeners();
  }

  Usuario get usuario => this._usuario;

  set usuario(Usuario usuario) {
    this._usuario = usuario;
    notifyListeners();
  }

  // getters del token estatica
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;  
  }
  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future _guardarToken(String token) async {
    return  await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}