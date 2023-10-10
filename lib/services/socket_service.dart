import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:chat/global/env.dart';
import 'package:chat/services/auth_services.dart';
import 'dart:developer' as developer;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket get socket => this._socket;

  void connect() async {
    final token = await AuthServices.getToken();

    // Dart client
    this._socket = IO.io(
      ENV.socketUrl, 
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
        'forceNew': true,
        'query': { 'x-token': token }
      },
    );

    this._socket.onConnect((_) {
      developer.log('Conectado');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.onDisconnect((_) {
      developer.log('Desconectado');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // Agregar más eventos según sea necesario
  }

  void emit(String event, dynamic data) {
  if (_socket != null) {
    _socket.emit(event, data);
  }
}

  void disconnect() {
    this._socket.disconnect();
  }
}
