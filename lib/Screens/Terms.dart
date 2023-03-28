
import 'package:deal/Screens/DrawerScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Terms extends StatelessWidget {
  const Terms({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('terms_message').tr()),
        backgroundColor: Colors.black,
      ),
      drawer: Drawer(
        child: DrawerScreen() ,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("terms_message",
                style: TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.underline

                ),
              ).tr(),
              Text('Welcome to the "Deal Card" Application,'
                  " as this application helps you to obtain discounts offered by Deal Card exclusively for us. "
                  'Before using the "Deal Card" application, please read these terms and our privacy policy carefully'
                  'Access to and use of the "Deal Card" application is provided by you based on your agreement to these terms and the relevant privacy policy '
                  'if you enter the application or use it in any way that includes obtaining any service or information on or through the "Deal Card" application'
                  'you acknowledge that you have read and understood these terms, and you agree to obide by them and that what you have done from Operations or through the application are subject to these terms and the privacy policy'
                  'in the event you do not agree to these terms at any time, please stop your use of the "Deal Card" application immediately'
                ,
                style: TextStyle(
                    color: Colors.grey,
                  letterSpacing: 3


                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
