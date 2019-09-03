import 'package:flutter/material.dart';
import 'package:vinora/widgets/food_card.dart';
import 'auth.dart';
import 'auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:toast/toast.dart';
import 'companies/RoyalVintage.dart';
import 'data/food_data.dart';
String id="null",name="null",email="null",firstLetter="Nu";

class HomePage extends StatelessWidget {
  const HomePage(
    {
    this.onSignedOut
    });
  final VoidCallback onSignedOut;
  
  Future<void> _signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }
  
  Future<String> getUserId() async{
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final databaseReference = FirebaseDatabase.instance.reference();
    FirebaseUser user = await _firebaseAuth.currentUser();
    id=user.uid;
    databaseReference.child("User/"+id).once().then((DataSnapshot snap){
      name=snap.value["name"];
      email=snap.value["email"];
      firstLetter=name.substring(0,1).toUpperCase();
    });
    
    return user != null ? user.uid : null;
  }
  @override
  Widget build(BuildContext context) {
    getUserId();
    
            return Scaffold(
              appBar: AppBar(
                title: Text('Vinora'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Logout', style: TextStyle(fontSize: 17.0, color: Colors.white)),
                    onPressed: () => _signOut(context),
                  )
                ],
              ),
              body:SingleChildScrollView (child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      FlatButton(
                    child: Row(
                                
                                children: [
                                  Padding(padding: const EdgeInsets.all(15),
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage("images/logo1.png"),
                                      radius: 50,),
                                                      ),
                                                      Padding(padding: const EdgeInsets.all(15),
                                                      child: Column(
                                                        children:<Widget>[
                                                            Text("Royal Vintage",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                                            Text("Registered",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,color: Colors.red),)
                                                        ] 
                                                      ),
                                                      ),
                                                    ],
                                                  ),
                    onPressed: ()=>{
                      Navigator.push(context, MaterialPageRoute(builder:(context){
                        return MainScreen();
                      })),

                      
                    },
                    
                  ),
                  
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      FlatButton(
                    child: Row(
                                
                                children: [
                                  Padding(padding: const EdgeInsets.all(15),
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage("images/logo1.png"),
                                      radius: 50,),
                                                      ),
                                                      Padding(padding: const EdgeInsets.all(15),
                                                      child: Column(
                                                        children:<Widget>[
                                                            Text("Royal Vintage",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                                            Text("Registered",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,color: Colors.red),)
                                                        ] 
                                                      ),
                                                      ),
                                                    ],
                                                  ),
                    onPressed: ()=>{

                    },
                    
                  ),
                  
                    ],
                  ),
                ],
              ) ,
            ),    
                    drawer: Drawer(child: ListView(
                                            children: <Widget>[
                                              UserAccountsDrawerHeader(
                                            accountName: Text(name),
                                            accountEmail: Text(email),
                                            currentAccountPicture: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: Text(firstLetter,style: TextStyle(
                                              fontSize:36,
                                              
                                               ),),
                                            ),
                                            ),
                                            ListTile(
                                              title: Text("My Profile"),
                                              onTap: (){
                                    
                                              },
                                            ),
                                            ListTile(
                                              title: Text("My Profile"),
                                              onTap: (){
                                    
                                              },
                                            ),
                                            ListTile(
                                              title: Text("My Profile"),
                                              onTap: (){
                                    
                                              },
                                            ),
                                            ListTile(
                                              title: Text("My Profile"),
                                              onTap: (){
                                    
                                              },
                                            ),
                                            ListTile(
                                              title: Text("Exit"),
                                              onTap: (){
                                    
                                              },
                                            ),
                                            ],
                                          ),
                                            ),
                                            
                                          
                                            
                                        );
                                      }
                                    
                                      Image logo() {
                                        AssetImage assetImage=AssetImage('images/logo1.png');
                                     Image image=Image(image:assetImage,width: 150,height: 150);
                                 return  image;
                                  
                                      }

}