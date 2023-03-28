import 'package:connectivity_plus_platform_interface/src/enums.dart';
import 'package:flutter/material.dart';

class ConnectionProvider extends ChangeNotifier{
  bool isConnected;

  ConnectionProvider(this.isConnected);

  setConnection(bool connection){
    this.isConnected = connection;

    notifyListeners();
  }
}