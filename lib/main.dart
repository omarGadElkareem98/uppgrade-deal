import 'dart:async';

import 'package:deal/Screens/HomeScreen.dart';
import 'package:deal/Screens/LoginScreen.dart';
import 'package:deal/Screens/SplashScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Provider/AdminMode.dart';
import 'Provider/ConnectionProvider.dart';
import 'Provider/UserProvider.dart';
import 'Services/UserServices.dart';
import 'firebase_options.dart';

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

Future<void> showFlutterNotification(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'launch_background',
        ),
      ),
    );

    await UserServices.addUserNotifications(
        uid: message.data['uid'],
        title: notification.title!,
        body: notification.body!);
  }
}

Future<void> requestNotificationPermission() async {
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await EasyLocalization.ensureInitialized();
  await requestNotificationPermission();
  await setupFlutterNotifications();

  FirebaseMessaging.onMessage.listen(showFlutterNotification);

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  bool isLogged = await sharedPreferences.getBool('isLogged') ?? false;
  String email = await sharedPreferences.getString('email') ?? '';
  String password = await sharedPreferences.getString('password') ?? '';
  String passUid = '';

  if (isLogged) {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      String uid = value.user!.uid;
      passUid = uid;
      await UserServices.changeUserStatus(uid: uid, status: 'online');
    });
  }

  bool connection = (await Connectivity().checkConnectivity()) != ConnectivityResult.none;

  runApp(EasyLocalization(
      supportedLocales: [Locale('en', ''), Locale('ar', '')],
      path: "assets/lang",
      fallbackLocale: Locale('en', ''),
      child: MyApp(
        isLogged: isLogged,
        uid: passUid,
        connection: connection,
      )));
}

class AuthWrapper extends StatefulWidget {
  final bool isLogged;
  AuthWrapper({required this.isLogged});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {


  @override
  Widget build(BuildContext context) {
    return widget.isLogged ? HomeScreen() : LoginScreen();
  }
}

class ChooseLanguageWrapper extends StatelessWidget {
  final bool isLogged;
  ChooseLanguageWrapper({required this.isLogged});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          fontFamily:
              context.locale.languageCode == 'en' ? 'ACCORD' : 'GESSTWO'),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (BuildContext context,
              AsyncSnapshot<SharedPreferences> snapshot) {
            if (snapshot.hasData && !snapshot.hasError) {
              bool languageHasChose =
                  snapshot.data!.getBool('languageHasChose') ?? false;
              if (!languageHasChose) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("images/logo.jfif"),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        MaterialButton(
                          onPressed: () async {
                            await snapshot.data!
                                .setBool('languageHasChose', true);
                            await snapshot.data!
                                .setString('languageCode', 'en');
                            await context.setLocale(Locale('en', ''));
                            await Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) {
                              return LoginScreen();
                            }));
                          },
                          child: Ink(
                            padding: EdgeInsets.symmetric(vertical: 12.0,horizontal: 36),
                              decoration: BoxDecoration(
                                gradient: new RadialGradient(
                                    radius: 2,
                                    focalRadius: 3,

                                    colors: [
                                      Colors.brown.withOpacity(0.2),
                                      Colors.amber
                                    ]),
                              ),
                              child: Text('English',style: TextStyle(fontWeight: FontWeight.bold),)
                          ),
                        ),
                        Expanded(
                          child: MaterialButton(
                            onPressed: () async {
                              await snapshot.data!
                                  .setBool('languageHasChose', true);
                              await snapshot.data!.setString('languageCode','ar');
                              await context.setLocale(Locale('ar', ''));
                              await Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) {
                                return LoginScreen();
                              }));
                            },
                            child: Ink(
                                padding: EdgeInsets.symmetric(vertical: 12.0,horizontal: 36),
                                decoration: BoxDecoration(
                                  gradient: new RadialGradient(
                                      radius: 2,
                                      focalRadius: 3,

                                      colors: [
                                        Colors.brown.withOpacity(0.2),
                                        Colors.amber
                                      ]),
                                ),
                                child: Text('اللفه العربيه ',style: TextStyle(fontWeight: FontWeight.bold),)
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                String languageCode =
                    snapshot.data!.getString('languageCode') ?? 'en';
                return FutureBuilder(
                  future: languageCode == 'en' ? context.setLocale(Locale('en','')) : context.setLocale(Locale('ar','')),
                  builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                    if(snapshot.connectionState == ConnectionState.done){
                      return AuthWrapper(isLogged: isLogged);
                    }else{
                      return CircularProgressIndicator();
                    }
                  },
                );
              }
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  final bool isLogged;
  final String uid;
  final bool connection;

  const MyApp({super.key, required this.isLogged, required this.uid,required this.connection});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool connection;
  late StreamSubscription connectivity;

  void handleNetworkChange(value){
    setState(() {
      connection = value != ConnectivityResult.none;
    });
  }

  @override
  void initState(){
    super.initState();
    connection = widget.connection;
    connectivity = Connectivity().onConnectivityChanged.listen(handleNetworkChange);
  }

  @override
  void dispose() {
    connectivity.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 2)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        } else {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<AdminMode>(
                  create: (context) => AdminMode()),
              ChangeNotifierProvider<UserProvider>(
                  create: (context) => UserProvider(uid: widget.uid)),
              ChangeNotifierProvider<ConnectionProvider>(
                create: (context) => ConnectionProvider(connection)
              )
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  fontFamily: context.locale.languageCode == 'en'
                      ? 'ACCORD'
                      : 'GESSTWO'),

              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              home:Stack(
                children: [
                  ChooseLanguageWrapper(
                    isLogged: widget.isLogged,
                  ),
                  Overlay(
                    initialEntries: [
                      OverlayEntry(
                          builder: (context){
                            return !connection ? Align(
                              alignment: Alignment.bottomCenter,
                              child: Material(
                                child: Container(
                                    color: Colors.red,
                                    width:double.infinity,
                                    height: 30,
                                    padding:EdgeInsets.all(4.0),
                                    child:Center(
                                      child: Text('err_disconnect',style: TextStyle(color: Colors.white,fontSize: 14),).tr(),
                                    )
                                ),
                              ),
                            ) : Container();
                          }
                      )
                    ],
                  )
                ],
              ),

            ),
          );
        }
      },
    );
  }
}
