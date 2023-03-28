import "dart:convert";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:http/http.dart" as http;
import "CloudMessaging.dart";

class UserServices{
  static Future<bool> changeUserStatus({required String uid,required String status}) async{
    String uri = "https://deal.onrender.com/users/$uid/status";

    try{
      http.Response response = await http.post(
          Uri.parse(uri),
          headers: {
            'Content-Type':'application/json; charset=utf-8'
          },
          body: jsonEncode({
            'uid':uid,
            'status':status
          })
      );

      return response.statusCode == 200;
    }catch(err){
      print(err);
      return false;
    }
  }

  static Future<bool> createNewUser({
    required String name,
    required String phone,
    required String email,
    required String uid
  }) async{
      String uri = "https://deal.onrender.com/api/users";

      try{
        String token = await CloudMessaging.getDeviceToken();

        http.Response response = await http.post(
          Uri.parse(uri),
            headers: {
              'Content-Type':'application/json; charset=utf-8'
            },
            body: jsonEncode({
              'name':name,
              'phone':phone,
              'uid':uid,
              'email':email,
              'deviceToken':token
            })
        );

        print(response.statusCode);
        return response.statusCode == 201;
      }catch(err){
        return false;
      }
  }

  static Future notifyRegistration({required String uid}) async{
    String uri = 'https://deal.onrender.com/users/$uid/registration/notify';

    try{
       await http.post(
        Uri.parse(uri),
        headers: {
          'Content-Type':'application/json; charset=utf-8'
        },
      );
    }catch(err){
      print(err);
    }
  }

  static Future<List> getUserNotifications({required String uid}) async{
    String uri = 'https://deal.onrender.com/users/$uid/notifications';

    try{
      http.Response response = await http.get(
        Uri.parse(uri),
        headers: {
          'Content-Type':'application/json; charset=utf-8'
        },
      );

      return List.from(jsonDecode(response.body));
    }catch(err){
      print(err);
      return [];
    }
  }

  static Future addUserNotifications({
    required String uid,
    required String title,
    required String body
  }) async{
    String uri = 'https://deal.onrender.com/users/$uid/notifications';

    try{
      http.Response response = await http.post(
        Uri.parse(uri),
        headers: {
          'Content-Type':'application/json; charset=utf-8'
        },
        body:jsonEncode({
          'uid':uid,
          'title':title,
          'body':body
        })
      );
      print(response.statusCode);
      return response.statusCode == 201;
    }catch(err){
      print(err);
      return false;
    }
  }

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future addToFavorites(userId,dealId) async{
    List favorites = (await firestore.collection('favorites').get()).docs;
    int isAnyFavoriteExists = favorites.where((element) => element['userId'] == userId).toList().length;

    if(isAnyFavoriteExists == 0){
      await firestore.collection("favorites").add({
        'userId':userId,
        'favorites':[dealId]
      });
    }else{
      var favoriteDoc = favorites.where((element) => element['userId'] == userId).first;
      Map favorite = favoriteDoc.data();
      List currentFavorites = favorite['favorites'];
      if(!currentFavorites.contains(dealId)){
        currentFavorites.add(dealId);
      }

      await firestore.collection("favorites").doc(favoriteDoc.id).update({
        'favorites':currentFavorites
      });
    }
  }

  static Future removeFromFavorites(userId,dealId) async{
    List favorites = (await firestore.collection('favorites').get()).docs;

    var favoriteDoc = favorites.where((element) => element['userId'] == userId).first;
    Map favorite = favoriteDoc.data();
    List currentFavorites = favorite['favorites'];
    if(currentFavorites.contains(dealId)){
      currentFavorites.remove(dealId);
    }

    await firestore.collection("favorites").doc(favoriteDoc.id).update({
      'favorites':currentFavorites
    });
  }

  static Future getAllFavorites() async{

  }

  static Future publishRating({required String uid,required double rating})async{
    List ratings = (await firestore.collection('ratings').get()).docs;
    int isAnyRatingExists = ratings.where((element) => element['uid'] == uid).toList().length;

    if(isAnyRatingExists == 0){
      await firestore.collection("ratings").add({
        'uid':uid,
        'rating':rating
      });
    }else{
      var ratingDoc = ratings.where((element) => element['uid'] == uid).first;
      await firestore.collection("ratings").doc(ratingDoc.id).update({
        'rating':rating
      });
    }
  }

  static Future getRatingScore() async{

  }

  static Future changeUserToken({required String uid}) async{
    List users = (await FirebaseFirestore.instance.collection("users").where('uid',isEqualTo: uid).get()).docs;
    var user = users.isNotEmpty ? users.first : null;

    if(user != null){
      String? token = await CloudMessaging.getDeviceToken();


      if(token != null){
        await FirebaseFirestore.instance.collection("users").doc(user.id).update({
          'deviceToken': token
        });
      }
    }
  }

  static Future clearUserToken({required String uid}) async{
    List users = (await FirebaseFirestore.instance.collection("users").where('uid',isEqualTo: uid).get()).docs;
    var user = users.isNotEmpty ? users.first : null;

    if(user != null){
      await FirebaseFirestore.instance.collection("users").doc(user.id).update({
        'deviceToken': ''
      });
    }
  }
}