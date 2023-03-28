
import 'package:deal/Screens/DrawerScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Language extends StatelessWidget {
  const Language({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("change_language").tr()),
        backgroundColor: Colors.black,

      ),
      drawer: Drawer(
        child: DrawerScreen(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: SingleChildScrollView(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  width: 120,
                  child: MaterialButton(
                      onPressed: ()async{
                        await context.setLocale(Locale('en',''));
                      },
                    color: Colors.amber,
                    child: Text('English'),
                  ),


                ),
              ),
              SizedBox(width: 30,),
              Expanded(
                child: Container(
                  width: 120,
                  child: MaterialButton(
                    onPressed: ()async{
                      await context.setLocale(Locale('ar',''));
                    },
                    color: Colors.amber,
                    child: Text('اللفه العربيه '),
                  ),

                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
