import 'package:deal/Screens/LoginScreen.dart';
import 'package:deal/Services/UserServices.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';



import 'constants.dart';

class RegisterScreen extends StatelessWidget {
   RegisterScreen({Key? key}) : super(key: key);

   TextEditingController emailController = TextEditingController();
   TextEditingController passwordController = TextEditingController();
   TextEditingController nameController = TextEditingController();
   TextEditingController phoneController = TextEditingController();

  var FormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0,right: 8.0,left:8.0),
            child: Align(
              alignment: context.locale.languageCode == 'en' ? Alignment.centerLeft : Alignment.centerRight,
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border:Border.all(color: Colors.black,width: 3)
                  ),
                  child: Icon(Icons.arrow_back),
                ),
              ),
            ),
          ),
        ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Form(
                key: FormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Center(child: Text("new_account",style: TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),).tr()),
                    SizedBox(height: 30,),
                    TextFormField(
                      validator: (data){
                        if(data!.isEmpty){
                          return "name_input_error".tr();
                        }
                        return null;

                      },
                      controller: nameController,

                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          hintText: 'name_message'.tr(),
                          hintStyle: TextStyle(color: Colors.black),

                          enabledBorder:   OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: Colors.black)
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)
                          )
                      ),

                    ),
                    SizedBox(height: 30,),
                    TextFormField(
                      validator: (data){
                        if(data!.isEmpty){
                          return "email_input_error".tr();
                        }
                        return null;

                      },
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: 'email_message'.tr(),
                          hintStyle: TextStyle(color: Colors.black),

                          enabledBorder:   OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: Colors.black)
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)
                          )
                      ),
                    ),
                    SizedBox(height: 30,),
                    TextFormField(
                      controller: phoneController,

                      validator: (data){
                        if(data!.isEmpty){
                          return "phone_input_error".tr();
                        }

                        return null;
                      },

                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(

                          hintText: 'phone_message'.tr(),
                          hintStyle: TextStyle(color: Colors.black),

                          enabledBorder:   OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: Colors.black)
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)
                          )
                      ),
                    ),
                    SizedBox(height: 30,),
                    TextFormField(
                      validator: (data){
                        if(data!.isEmpty){
                          return "password_input_error".tr();
                        }
                        return null;
                      },

                      controller: passwordController,

                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          hintText: 'password_message'.tr(),
                          hintStyle: TextStyle(color: Colors.black),

                          enabledBorder:   OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: Colors.black)
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)
                          )
                      ),
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
                           UserCredential creds = await auth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
                           String uid = creds.user!.uid;

                           await UserServices.createNewUser(
                               name: nameController.text,
                               phone: phoneController.text,
                               email: emailController.text,
                               uid: uid
                           );

                           await UserServices.notifyRegistration(uid: uid);
                           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                             return LoginScreen();
                           }));
                         } on FirebaseAuthException catch (ex){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar
                          (content: Text('${ex.message.toString()}'),
                          backgroundColor: Colors.red
                          ,),);
                         }


                          }
                      },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.black,
                        ),
                        child: Text("register_message",
                          style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w100),

                        ).tr()

                        ,),
                    ),
                    SizedBox(height: 10,),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("ask_for_account",
                          style: TextStyle(fontSize: 15.0,color: Colors.black),
                        ).tr(),
                        MaterialButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return LoginScreen();
                          }));
                        },
                          child: Text("sign_in_message",
                            style: TextStyle(fontSize: 17.0,color: Colors.blueAccent,decoration: TextDecoration.underline),
                          ).tr(),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}
