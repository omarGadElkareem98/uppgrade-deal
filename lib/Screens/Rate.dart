import 'package:deal/Provider/UserProvider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../Services/UserServices.dart';
import 'LoginScreen.dart';

class Rate extends StatelessWidget {
  Rate({Key? key}) : super(key: key);
  double rate = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("rate_message").tr(),
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  rate = rating;
                },
              ),
              SizedBox(height: 15,),
              ElevatedButton(
                  onPressed: ()async{
                    String uid = Provider.of<UserProvider>(context,listen: false).uid;
                    if(uid.isNotEmpty){
                      await UserServices.publishRating(uid: uid, rating: rate);
                      Navigator.pop(context);
                    }else{
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context){
                            return LoginScreen();
                          })
                      );
                    }
                  },
                  child: Text('rate'.tr())
              )
            ],
          ),
        ),
      ),
    );
  }
}
