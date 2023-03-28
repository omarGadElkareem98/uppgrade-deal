import 'package:firebase_messaging/firebase_messaging.dart';

class CloudMessaging{
  static Future getDeviceToken() async{
    String? token = await FirebaseMessaging.instance.getToken();

    return token;
  }
}