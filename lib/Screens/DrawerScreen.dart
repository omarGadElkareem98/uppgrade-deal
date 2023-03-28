
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deal/Screens/ContactUs.dart';
import 'package:deal/Screens/HomeScreen.dart';
import 'package:deal/Screens/Language.dart';
import 'package:deal/Screens/LoginScreen.dart';
import 'package:deal/Screens/NotificationsScreen.dart';
import 'package:deal/Screens/Terms.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_dialogs/flutter_dialogs.dart';

import '../Provider/UserProvider.dart';
import '../Services/UserServices.dart';
import '../main.dart';
import 'QrCodeScanner.dart';
import 'Rate.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset("images/logo.jfif"),
            SizedBox(height: 15,),
            Text('guest_message',style: TextStyle(decoration: TextDecoration.underline),).tr(),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("ratings").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if(!snapshot.hasError && snapshot.hasData){
                  List ratings = snapshot.data!.docs;
                  double sum = 0;
                  for(var rating in ratings){
                    sum += rating.data()['rating'];
                  }
                  double ratingScore = ratings.isEmpty ? 0 : sum / ratings.length;
                  return Text(context.locale.languageCode == 'en' ? '$ratingScore/5' : '5/$ratingScore',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.amber),);
                }else{
                  return Text('0/5',style: TextStyle(fontSize: 20,color: Colors.amber),);
                }
              },
            ),
            SizedBox(height: 10,),
            Text("deal_card",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 33
              
            ),
            ).tr(),
            SizedBox(height: 40,),
            ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return HomeScreen();
                }),);
              },
              title: Text('home_page').tr(),
              leading: Icon(
                Icons.home_filled,
                color: Colors.black,
              ),

            ),
            ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return NotificationsScreen();
                }),);
              },
              title: Text('notifications').tr(),
              leading: Icon(
                Icons.notifications,

              ),

            ),
            ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return Contactus();
                }),);
              },
              title: Text('contact_message').tr(),
              leading: Icon(
                Icons.connect_without_contact_rounded,
              ),

            ),
            ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return Terms();
                }),);
              },
              title: Text('terms_message').tr(),
              leading: Icon(
                Icons.contact_support,

              ),

            ),
            ListTile(
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Rate())
                );
              },
              title: Text('rate_message').tr(),
              leading: Icon(
                Icons.rate_review,

              ),

            ),
            ListTile(
              onTap: (){
                Share.share("my application",subject: "my app",sharePositionOrigin: Rect.largest);
              },
              title: Text('share_message').tr(),
              leading: Icon(
                Icons.share,
                color: Colors.black,
              ),

            ),
            ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return Language();
                } ),);
              },
              title: Text('change_language').tr(),
              leading: Icon(
                Icons.settings,
                color: Colors.black,
              ),

            ),
            FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
                if(snapshot.hasData && !snapshot.hasError) {
                  bool isLogged = snapshot.data!.getBool('isLogged') ?? false;
                  if (isLogged) {
                    return ListTile(
                      onTap: ()async{
                        String uid = Provider.of<UserProvider>(context,listen:false).uid;
                        await UserServices.changeUserStatus(uid: uid, status: 'offline');
                        await UserServices.clearUserToken(uid: uid);

                        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                        await sharedPreferences.setBool('isLogged',false);
                        await sharedPreferences.setString('email','');
                        await sharedPreferences.setString('password','');

                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                          return AuthWrapper(isLogged: false,);
                        }));
                      },
                      title: Text('logout_message').tr(),
                      leading: Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),

                    );
                  }else{
                    return ListTile(
                      onTap: ()async{
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                          return AuthWrapper(isLogged: false,);
                        }));
                      },
                      title: Text('login_message').tr(),
                      leading: Icon(
                        Icons.login,
                        color: Colors.black,
                      ),

                    );
                  }
                }else{
                  return Container();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
