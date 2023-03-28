
import 'package:flutter/cupertino.dart';

class AdminMode extends ChangeNotifier {

  bool isAdmin = false;

  changeAdminMode (bool value){
    isAdmin = value;

    notifyListeners();

  }


}