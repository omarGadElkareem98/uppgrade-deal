
import 'package:deal/Screens/DrawerScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../Services/CloudMessaging.dart';

class Contactus extends StatelessWidget {
  const Contactus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    title: Center(child: Text('contact_message').tr()),
    backgroundColor: Colors.black,
      ),
      drawer: Drawer(
    child: DrawerScreen(),
      ),
      body: SingleChildScrollView(
    child: Column(
      children: [
        Center(
          child: Image.asset('images/logo.jfif')

        ),
        SizedBox(height: 30,),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextFormField(
            maxLines: 15,
            keyboardType: TextInputType.multiline,
            minLines: 5,
            decoration: InputDecoration(
              hintText: 'review_message'.tr(),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(15.0),

              ),




            ),
          ),
        ),
        SizedBox(height: 20,),
        Container(
          width: 250,

          child: MaterialButton(onPressed: ()async{
            String token = await CloudMessaging.getDeviceToken();
            print(token);
          },
            color: Colors.amber,

            child: Text("send_message".tr(),
              style: TextStyle(fontSize: 20.0,fontStyle: FontStyle.italic),

            )

            ,),
        ),

      ],
    ),
      ),
    );
  }
}
