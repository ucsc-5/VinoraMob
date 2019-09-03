import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
abstract class BaseAuth {
  
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String name,String email, String password,String mobile,String address);
  Future<String> currentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.reference();
  @override
  Future<String> signInWithEmailAndPassword(String email, String password) async {    
    AuthResult result= await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    final FirebaseUser user =result.user;
    return user.uid;
  }

  @override
  Future<String> createUserWithEmailAndPassword(String name,String email, String password,String mobile,String address) async {
    
      AuthResult result= await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    final FirebaseUser user =result.user;
    databaseReference.child("User/"+user.uid).set({
    'name': name,
    'email':email,
    'address':address,
    'mobile':mobile
  });
    return user.uid;
    
    
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
}