

import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:deal/Screens/ServiceDeals.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../Provider/ConnectionProvider.dart';
import 'DrawerScreen.dart';
import 'ShoesDetails.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HomeScreen extends StatefulWidget {
   HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late bool showAlert;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();


  @override
  void initState() {
    super.initState();
    showAlert = Provider.of<ConnectionProvider>(context,listen:false).isConnected;
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Stack(
          children: [
            WillPopScope(
              onWillPop: ()async{
                bool closeApp = await showDialog(
                    context: context,
                    builder: (context){
                      return ActionConfirm(
                        message: 'leaving_msg'.tr()
                      );
                    }
                );

                return closeApp;
              },
              child: Scaffold(
                drawerEnableOpenDragGesture: false,
                key: _scaffoldKey,
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Container(
                    height: double.infinity,
                    color: Colors.black,
                    child: Stack(
                      children: [
                        Align(
                          child: IconButton(
                            onPressed: (){
                              _scaffoldKey.currentState!.openDrawer();
                            }, icon: Icon(Icons.menu,color: Colors.white,size: 35,),
                          ),
                          alignment: context.locale.languageCode == 'en' ? Alignment.centerLeft : Alignment.centerRight,
                        ),
                        Align(
                          child: Image.asset('images/deal.png'),
                          alignment: Alignment.topCenter,
                        ),
                        Align(
                          child: Text('Deal Card',style: TextStyle(color: Colors.white),),
                          alignment: Alignment.bottomCenter,
                        )
                      ],
                    ),
                  ),
                ),
                drawer: Drawer(
                  child: DrawerScreen(),
                ),
                body: Column(
                  children: [
                    StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("carousels").snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                        if(snapshot.hasData && !snapshot.hasError){
                          var carousels = snapshot.data!.docs;
                          return carousels.isEmpty ? Center(
                            child: Container(
                              width: double.infinity,
                              height: 250,
                              color:Colors.black54,
                              child: Text('no carousels'),
                            ),
                          ): CarouselSlider.builder(
                            options: CarouselOptions(
                                height: 210,
                                autoPlay: true,
                                initialPage: 0,
                                viewportFraction: 1,
                                autoPlayInterval: Duration(seconds: 3),
                              padEnds: false
                            ),
                            itemCount: carousels.length,
                            itemBuilder: (context,i,pi){
                              Map carousel = carousels[i].data();
                              return Container(
                                width:double.infinity,
                                height: 250,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: Image.memory(base64Decode(carousel['encoding'])).image,
                                      fit: BoxFit.cover
                                    )
                                ),
                              );
                            },
                          );
                        }else{
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("services").snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if(snapshot.hasData && !snapshot.hasError){
                            List services = snapshot.data.docs;
                            return GridView.builder(
                              itemCount: services.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                  childAspectRatio: 257 / 160,
				  crossAxisSpacing: 2,
  				  mainAxisSpacing: 3,
                                ),
                                itemBuilder: (context,i){
                                  Map service = services[i].data();
                                  return InkWell(
                                    onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                        return ServiceDeals(category:service['serviceName'],arCategory:service['arServiceName']);
                                      }));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: Image.memory(base64Decode(service['image'])).image
                                        ),
                                          borderRadius: BorderRadius.circular(8.0)
                                      ),
                                      child: Stack(
                                        children: [
                                          Align(
                                            child: AutoSizeText(
                                                service['serviceName'] ?? '',
                                                maxLines:1,
                                                style:TextStyle(color:Colors.white,fontSize:14,fontWeight: FontWeight.bold)
                                            ),
                                            alignment: Alignment.topCenter,
                                          ),
                                          Align(
                                            child: AutoSizeText(
                                                service['arServiceName'] ?? '',
                                                maxLines:1,
                                                style:TextStyle(color:Colors.white,fontSize:14,fontWeight: FontWeight.bold)
                                            ),alignment: Alignment.bottomCenter,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                            );
                          }else{
                            return Center(
                                child: CircularProgressIndicator()
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Overlay(
              initialEntries: [
                OverlayEntry(
                    builder: (context){
                      return !Provider.of<ConnectionProvider>(context,listen:false).isConnected ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Material(
                          child: Container(
                              color: Colors.red,
                              width:double.infinity,
                              height: 30,
                              padding:EdgeInsets.all(4.0),
                              child:Center(
                                child: Text('failed to connect to the internet',style: TextStyle(color: Colors.white,fontSize: 14),),
                              )
                          ),
                        ),
                      ) : Container();
                    }
                )
              ],
            ),
            Overlay(
              initialEntries: [
                OverlayEntry(
                    builder: (context){
                      return !showAlert ? Align(
                        alignment: Alignment.center,
                        child: AlertDialog(
                          content: Text('reConnMess'.tr()),
                          actions: [
                            TextButton(
                            onPressed: (){
                              setState(() {
                                showAlert = !showAlert;
                              });
                            },
                            child: Text('ok')
                            )
                          ],
                        ),
                      ) : Container();
                    }
                )
              ],
            ),
          ],
        )
      );
  }
}
class ActionConfirm extends StatelessWidget{
  final String message;
  ActionConfirm({super.key,required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(onPressed: (){
          Navigator.of(context).pop(true);
        }, child: Text("yes")),
        TextButton(onPressed: (){
          Navigator.of(context).pop(false);
        }, child: Text("no")),
      ],
      content: Text(message),
    );
  }

}