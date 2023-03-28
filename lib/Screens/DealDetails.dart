import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginScreen.dart';
import 'QrCodeScanner.dart';

class DealDetails extends StatefulWidget {
  final Map deal;
  const DealDetails({Key? key, required this.deal}) : super(key: key);

  @override
  State<DealDetails> createState() => _DealDetailsState();
}

class _DealDetailsState extends State<DealDetails> {

  @override
  Widget build(BuildContext context) {
    bool lrt = context.locale.languageCode == 'en';
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        width: double.infinity,
        color: Colors.black,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  child: TextButton(
                    child: Text('back_message',style: TextStyle(fontSize: 20),).tr(),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                  alignment: Alignment.centerLeft,
                ),
              ),

              SizedBox(height: 20,),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Image.memory(base64Decode(widget.deal['shopImage'])).image
                  )
                ),
              ),
              SizedBox(height: 20,),
              Align(
                child: Text('${"shop_name_message".tr()}: ${lrt ? widget.deal['shopName'] : widget.deal['arShopName']}',style: TextStyle(color: Colors.white,fontSize: 18),),
                alignment: lrt ? Alignment.centerLeft : Alignment.centerRight,
              ),
              Divider(height: 2,color: Colors.white,),

              SizedBox(height: 20,),
              Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${"discount_message".tr()}:${widget.deal['discount']}',style: TextStyle(color: Colors.white,fontSize: 18),),
                    ElevatedButton(
                        onPressed: ()async {
                          SharedPreferences sp = await SharedPreferences.getInstance();
                          bool isLogged = await sp.getBool('isLogged') ?? false;
                          if(isLogged){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context){
                                  return QrCodeScanner();
                                })
                            );
                          }else{
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context){
                                  return LoginScreen();
                                })
                            );
                          }
                        },
                        child: Text('redeem').tr()
                    )
                  ],
                ),
                alignment: Alignment.centerLeft,
              ),
              Divider(height: 2,color: Colors.white,),


              SizedBox(height: 20,),
              Align(
                child: Text('${"contact_msg".tr()}: ${widget.deal['contact']}',style: TextStyle(color: Colors.white,fontSize: 18),).tr(),
                alignment: lrt ? Alignment.centerLeft : Alignment.centerRight,
              ),
              Divider(height: 2,color: Colors.white,) ,


              SizedBox(height: 20,),
              Align(
                child: Text('${"work_time".tr()}: ${widget.deal['workTime']}',style: TextStyle(color: Colors.white,fontSize: 18),).tr(),
                alignment: lrt ? Alignment.centerLeft : Alignment.centerRight,
              ),
              Divider(height: 2,color: Colors.white,) ,

              SizedBox(height: 20,),
              Align(
                child: Text('${"address_message".tr()}: ${lrt ? widget.deal['address'] : widget.deal['arAddress']}',style: TextStyle(color: Colors.white,fontSize: 18),),
                alignment: lrt ? Alignment.centerLeft : Alignment.centerRight,
              ),
              Divider(height: 2,color: Colors.white,),

              SizedBox(height: 20,),
              Align(
                child: Text('${"expire_message".tr()}: ${widget.deal['expiryDate']}',style: TextStyle(color: Colors.white,fontSize: 18),).tr(),
                alignment: lrt ? Alignment.centerLeft : Alignment.centerRight,
              ),
              Divider(height: 2,color: Colors.white,),

              SizedBox(height: 20,),
              Align(
                child: Text('${"others_message".tr()}: ${lrt ? widget.deal['description'] : widget.deal['arDescription']}',style: TextStyle(color: Colors.white,fontSize: 18),).tr(),
                alignment: lrt ? Alignment.centerLeft : Alignment.centerRight,
              ),
              Divider(height: 2,color: Colors.white,),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
