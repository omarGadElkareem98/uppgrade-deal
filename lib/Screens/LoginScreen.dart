import 'package:deal/Provider/UserProvider.dart';
import 'package:deal/Screens/HomeScreen.dart';
import 'package:deal/Screens/RegisterScreen.dart';
import 'package:deal/Services/UserServices.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
   LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var FormKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordIsShown = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: FormKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text('welcome_message',

                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.amber,
                              fontWeight: FontWeight.bold
                            ),
                          ).tr(),
                        ],
                      ),
                      SizedBox(height: 25,),
                      TextFormField(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.amber
                              )
                          ),
                          border: OutlineInputBorder(

                          ),
                          hintText: 'email_message'.tr(),


                        ) ,
                        controller: emailController,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'email_input_error'.tr();
                          }
                          return null;
                        },

                      ),
                      SizedBox(height: 30,),
                      TextFormField(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.amber
                            )
                          ),
                            border: OutlineInputBorder(

                            ),
                            suffix: InkWell(
                              onTap: (){
                                setState(() {
                                  passwordIsShown = !passwordIsShown;
                                });
                              },
                              child: Icon(passwordIsShown ? Icons.visibility : Icons.visibility_off),
                            ),
                            hintText: 'password_message'.tr(),


                        ) ,
                        obscureText: !passwordIsShown,
                        controller: passwordController,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'password_input_error'.tr();
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30,),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            gradient: new RadialGradient(
                                radius: 8,
                                focalRadius: 3,

                                colors: [
                                  Colors.amber,
                                  Colors.brown.withOpacity(0.2),
                                ]),
                          ),
                        child: ElevatedButton(onPressed: ()async{
                          if(FormKey.currentState!.validate()){

                            try{
                              var auth = FirebaseAuth.instance;
                              UserCredential creds = await auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
                              String uid = creds.user!.uid;

                              bool status = await UserServices.changeUserStatus(uid: uid, status: 'online');
                              await UserServices.changeUserToken(uid: uid);
                              print(status);
                              if(status){
                                Provider.of<UserProvider>(context,listen: false).changeUserId(uid);
                                SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

                                await sharedPreferences.setBool('isLogged', true);
                                await sharedPreferences.setString('email', emailController.text);
                                await sharedPreferences.setString('password', passwordController.text);

                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                  return HomeScreen();
                                } ), );
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar
                                  (content: Text("smthwr").tr(),
                                  backgroundColor: Colors.red
                                  ,),);
                              }

                            } on FirebaseAuthException catch (ex){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar
                                (content: Text('${ex.message.toString()}'),
                                backgroundColor: Colors.red
                                ,),);
                            }

                          }
                        },
                          child: Text("login_message".tr(),
                            style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w100),

                          ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.black,
                            )

                          ,),
                      ),
                      SizedBox(height: 30,),

                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('no_account_yet').tr(),
                            TextButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return RegisterScreen();
                              } ),);
                            }, child: Text('sign_up_message',style: TextStyle(decoration: TextDecoration.underline,fontSize: 16),).tr() )
                          ],
                        ),
                      ),

                      SizedBox(height: 30,),

                      TextButton(onPressed: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                          return HomeScreen();
                        }),);
                      }, child: Text('skip_message',style: TextStyle(color: Colors.black,fontSize: 16,decoration: TextDecoration.underline,fontWeight: FontWeight.w100),).tr())
                    ],
                  ),
                ),
              ),
            ),
      ),
    );

  }
}
