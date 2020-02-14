import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:vinora/login_page.dart';

class ReqPage extends StatefulWidget {
  String companyId;
  ReqPage({Key key,  @required this.companyId}):super(key: key);
  @override
  _ReqPageState createState() => _ReqPageState();
}

class _ReqPageState extends State<ReqPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  ProgressDialog pr;
  var imageUrl="https://www.stickpng.com/assets/images/585e4bf3cb11b227491c339a.png";
  File newProfilePic;
  
  String name="Name Loading ...";
  String address="Loading...";
  int status=1;
  String userId;
  @override
  void initState() {
    
        currentUser();
        super.initState();
        
      }
      Future<String> currentUser() async {
    
    Firestore.instance
        .collection('companies')
        .document(widget.companyId)
        .get()
        .then((DocumentSnapshot ds) {
          setState(() {
            name=ds['companyName'];
            imageUrl=ds['imagePath'];
            address=ds['address'];
            
          });
      // use ds as a snapshot
    });
    FirebaseUser user = await _firebaseAuth.currentUser().then((onValue){
      userId=onValue.uid;
      Firestore.instance
        .collection('companies/${widget.companyId}/notRegRetailers')
        .document(onValue.uid)
        .get()
        .then((DocumentSnapshot ds) {
          setState(() {
           status=ds['state'];
            
          });
      // use ds as a snapshot
    });
    });
    
   
      return user != null ? user.uid : null;
  }
  bool isLoading = false;
      @override
      Widget build(BuildContext context) {
        return new Scaffold(
            body: new Stack(
              
          children: <Widget>[
            ClipPath(
              child: Container(color: Colors.deepPurple.withOpacity(0.9)),
              clipper: getClipper(),
            ),
            Positioned(
                left: MediaQuery.of(context).size.width/12,
                top: MediaQuery.of(context).size.height / 4,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: new EdgeInsets.only(left: 70),
                      alignment: Alignment.center,
                        width: 200.0,
                        height: 200.0, 
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            image: DecorationImage(
                              alignment: Alignment.center,
                                image: NetworkImage(
                                  
                                    imageUrl),
                                fit: BoxFit.cover),
                            
                            )),
                    SizedBox(height: 20.0),
                   
                    SizedBox(height: 20.0),
                   Column(
                     
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 50),
                          child:
                          Text(
                      name,
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                        ),
                        
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                        margin: new EdgeInsets.only(left: 65),
                          
                        height: 50.0,
                        width: 200.0,
                        child: status==1?Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.greenAccent,
                          color: Colors.green,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () {
                              updateState();
                            },
                            child: Center(
                              child: Text(
                                'Request',
                                style: TextStyle(color: Colors.white, fontFamily: 'Montserrat',fontSize: 18,fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ):Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.greenAccent,
                          color: Colors.red,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () {
                              cancelState();
                            },
                            child: Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.white, fontFamily: 'Montserrat',fontSize: 18,fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                        ),
                     
                                                    ],
                                                  ),
                                                  
                                                  
                                                  
                                                ],
                                              ))
                                        ],
                                      ));
                                    }
                                    
                                                    
                                    Future<bool> updateState() async{
                                      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                                    FirebaseUser user = await _firebaseAuth.currentUser();
                                      
                                      final DocumentReference postRef = Firestore.instance.document('companies/${widget.companyId}/notRegRetailers/${userId}');
                                      Firestore.instance.runTransaction((Transaction tx) async {
                                        DocumentSnapshot postSnapshot = await tx.get(postRef);
                                        if (postSnapshot.exists) {
                                          await tx.update(postRef, <String, dynamic>{'state': 2});
                                        }
                                      });

                                      final DocumentReference postRef1 = Firestore.instance.document('retailers/$userId/notRegCompanies/${widget.companyId}');
                                      Firestore.instance.runTransaction((Transaction tx) async {
                                        DocumentSnapshot postSnapshot1 = await tx.get(postRef1);
                                        if (postSnapshot1.exists) {
                                          await tx.update(postRef1, <String, dynamic>{'state': 2});
                                        }
                                      });
                                      setState(() {
                                        status=2;
                                      });
                                           
                                            return true;
                                      
                                    }

                                    Future<bool> cancelState() async{
                                      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                                    FirebaseUser user = await _firebaseAuth.currentUser();
                                      
                                      final DocumentReference postRef = Firestore.instance.document('companies/${widget.companyId}/notRegRetailers/${userId}');
                                      Firestore.instance.runTransaction((Transaction tx) async {
                                        DocumentSnapshot postSnapshot = await tx.get(postRef);
                                        if (postSnapshot.exists) {
                                          await tx.update(postRef, <String, dynamic>{'state': 1});
                                        }
                                      });

                                      final DocumentReference postRef1 = Firestore.instance.document('retailers/$userId/notRegCompanies/${widget.companyId}');
                                      Firestore.instance.runTransaction((Transaction tx) async {
                                        DocumentSnapshot postSnapshot1 = await tx.get(postRef1);
                                        if (postSnapshot1.exists) {
                                          await tx.update(postRef1, <String, dynamic>{'state': 1});
                                        }
                                      });
                                      setState(() {
                                        status=1;
                                      });
                                            
                                            return true;
                                            
                                      
                                    }
                                   
                              
                                void logOut() {
                                  _firebaseAuth.signOut();
                                  Navigator.push(context, MaterialPageRoute(builder:(context){
                              return (LoginPage());
                      }));
                                }
         
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height-500 );
    path.quadraticBezierTo(size.width/2,300, size.width/2, size.height-500);
    path.quadraticBezierTo(size.width/2,300, size.width, size.height-500);

    path.lineTo(size.width,0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}