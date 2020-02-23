import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class BaseAuth {
  
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String name,String email, String password,String mobile,String address);
  Future<String> currentUser();
  Future<void> signOut();
  Future<void> loadFood();
  Future currentUserDetails();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  @override
  Future<String> signInWithEmailAndPassword(String email, String password) async {    
    AuthResult result= await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    final FirebaseUser user =result.user;
    
    return user.uid;
  }
    
  
  @override
  Future<String> createUserWithEmailAndPassword(String name,String email, String password,String mobile,String address) async {
    String user1=" "; 
    
      AuthResult result= await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).then((onValue){
        user1=onValue.user.uid;
          Firestore.instance.collection('retailers').document(onValue.user.uid)
  .setData({ 
    'shopName': name,
    'email':email,
    'address':address,
    'contactNumber':mobile,
    'iniCoord':new GeoPoint(6.053519, 80.220978),
    'orderState':0,
    'url':"https://www.stickpng.com/assets/images/585e4bf3cb11b227491c339a.png",
    'state':1,
    'retailerId':user1
     });
      Firestore.instance
    .collection('companies')
    .snapshots()
    .listen((data) =>
        data.documents.forEach((doc) {
          Firestore.instance.collection('companies/${doc.documentID}/notRegRetailers').document(onValue.user.uid)
          .setData({ 
            'shopName': name,
            'email':email,
            'address':address,
            'contactNumber':mobile,
            'iniCoord':new GeoPoint(6.053519, 80.220978),
            'orderState':0,
            'url':"https://www.stickpng.com/assets/images/585e4bf3cb11b227491c339a.png",
            'state':1,
            'retailerId':user1
            });

            Firestore.instance.collection('retailers/$user1/notRegCompanies').document(doc.documentID)
          .setData(doc.data);
        }
          
        )); 
      });
 
    return user1;
    
    
  }

  @override
  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
      return user != null ? user.uid : null;
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  Future<void> loadFood() async{
    
    return null;
  }

  @override
  Future<FirebaseUser> currentUserDetails() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user != null ? user : null;
  }
}