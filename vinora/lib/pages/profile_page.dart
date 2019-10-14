import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:vinora/login_page.dart';
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  ProgressDialog pr;
  var imageUrl="https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg";
  File newProfilePic;
  final db=FirebaseDatabase.instance.reference();
  String name="Name Loading ...";
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
     newProfilePic=image; 
     uploadImage();
    });
    
  }
  
  uploadImage() async{
    setState(() {
     isLoading=true; 
    });
    if(newProfilePic!=null){
    final StorageReference firebaseStorageRef=FirebaseStorage.instance.ref().child(
      'profilepics/${DateTime.now()}.jpg'
    );
    
    StorageUploadTask task=firebaseStorageRef.putFile(newProfilePic);
    StorageTaskSnapshot storageTaskSnapshot = await task.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                    FirebaseUser user = await _firebaseAuth.currentUser();
                    
                      FirebaseDatabase.instance.reference().child('User')
                            .child(user.uid)
                            .update({
                            'image':downloadUrl
                            }).catchError((e){
                                  print(e);
                                });
        final db1 = FirebaseDatabase.instance.reference().child("User/${user.uid}"); 
      
      
        
    
      db1.once().then((DataSnapshot snapshot){
        setState(() {
          isLoading=false;
          imageUrl=snapshot.value['image'];
        });
        
      }).catchError((e){
  print(e);
                                });
      
    
    
    }
  
  }
  @override
  void initState() {
    
        currentUser();
        super.initState();
        
      }
      Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    final db1 = FirebaseDatabase.instance.reference().child("User/${user.uid}");
        db1.once().then((DataSnapshot snapshot){
          setState(() {
            name=snapshot.value['name'];
            imageUrl=snapshot.value['image'];
          });
        
      }).catchError((e){
                                  print(e);
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
              child: Container(color: Colors.deepOrange.withOpacity(0.8)),
              clipper: getClipper(),
            ),
            Positioned(
                left: MediaQuery.of(context).size.width/12,
                top: MediaQuery.of(context).size.height / 4,
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                        width: 150.0,
                        height: 150.0, 
                        decoration: BoxDecoration(
                            color: Colors.red,
                            image: DecorationImage(
                              alignment: Alignment.center,
                                image: NetworkImage(
                                  
                                    imageUrl),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.all(Radius.circular(75.0)),
                            boxShadow: [
                              BoxShadow(blurRadius: 7.0, color: Colors.black)
                            ])),
                    SizedBox(height: 20.0),
                    getLoader(),
                    SizedBox(height: 20.0),
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                        margin: new EdgeInsets.symmetric(horizontal: 5.0),
                          
                        height: 30.0,
                        width: 95.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.greenAccent,
                          color: Colors.green,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () {
                              editName(context);
                            },
                            child: Center(
                              child: Text(
                                'Edit Name',
                                style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        )),
                        
                        Container(
                          margin: new EdgeInsets.symmetric(horizontal: 5.0),
                        height: 30.0,
                        width: 95.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.greenAccent,
                          color: Colors.green,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                getImage();
                              });
                              
                            },
                            child: Center(
                              child: Text(
                                'Edit Photo',
                                style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        )),
                        
                    Container(
                      margin: new EdgeInsets.symmetric(horizontal: 5.0),
                        height: 30.0,
                        width: 95.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.redAccent,
                          color: Colors.red,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () {
                              logOut();
                                                          },
                                                          child: Center(
                                                            child: Text(
                                                              'Log out',
                                                              style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                                                            ),
                                                          ),
                                                        ),
                                                      ))
                                                    ],
                                                  ),
                                                  
                                                  
                                                  
                                                ],
                                              ))
                                        ],
                                      ));
                                    }
                                    Future<bool> editName(BuildContext context) async {
                                      return showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Change Your Name', style: TextStyle(fontSize: 16.0)),
                                              content: Container(
                                                height: 80.0,
                                                width: 80.0,
                                                child: Column(
                                                  children: <Widget>[
                                                    TextField(
                                                      decoration: InputDecoration(
                                                          labelText: 'New Name',
                                                          labelStyle: TextStyle(
                                                              fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.bold)),
                                                      onChanged: (value) {
                                                        name=value;
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('Exit'),
                                                  textColor: Colors.blue,
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    
                                                  },
                                                ),
                                                FlatButton(
                                                  child: Text('Update'),
                                                  textColor: Colors.blue,
                                                  onPressed: () {
                                                  
                                                    setState(() {
                                                      isLoading=true;
                                                      updateName(name);
                                                    });                     
                                                                          
                                                    Navigator.of(context).pop(); 
                                                                     
                                                                    },
                                                                  )
                                                                ],
                                                              );
                                                            });
                                                      }
                                                    
                                                      Future<bool> updateName(String name) async{
                                                        final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                                                      FirebaseUser user = await _firebaseAuth.currentUser();
                                                        
                                                        FirebaseDatabase.instance.reference().child('User')
                                                              .child(user.uid)
                                                              .update({
                                                              'name':name
                                                              }).catchError((e){
                                                                print(e);
                                                              });
                                                              setState(() {
                                                               isLoading=false; 
                                                              });
                                                              return true;
                                                        
                                                      }
                                    getLoader() {
                                  return isLoading
                                      ? Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            CircularProgressIndicator(),
                                          ],
                                        )
                                      : Container();
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
    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 300, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}