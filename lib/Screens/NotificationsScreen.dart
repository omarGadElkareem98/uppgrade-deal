
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deal/Screens/DrawerScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/UserProvider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('notifications').tr()),
        backgroundColor: Colors.black,
      ),
      drawer: Drawer(
        child: DrawerScreen(),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("notifications").orderBy("timestamp",descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if(snapshot.hasData && !snapshot.hasError){
            String uid = Provider.of<UserProvider>(context,listen: false).uid;
            List notifications = snapshot.data!.docs.where((element) => element['sender'] == uid).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Icon(Icons.notifications,color: Colors.black,size: 30,),
                      SizedBox(width: 5,),
                      Text(notifications.length.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(height: 20,)
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context,i){
                      Map notification = notifications[i].data();
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(

                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: Colors.grey
                                )

                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${notification['title']}',style: TextStyle(color: Colors.grey,fontStyle: FontStyle.italic),),
                                Text('${notification['body']}',style: TextStyle(color: Colors.grey,fontStyle: FontStyle.italic)),
                              ],
                            )
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }else{
            return Center(
              child: Text("no_notifications_message").tr(),
            );
          }
        },
      )
    );
  }
}

