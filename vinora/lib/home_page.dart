import 'package:flutter/material.dart';
import 'auth.dart';
import 'auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'companies/RoyalVintage.dart';

class HomePage extends StatefulWidget {
  
  final VoidCallback onSignedOut;
  
  HomePage({Key key, this.onSignedOut}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String id="null",name="Loding..",email="Loding..",firstLetter="L";
  String url="https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg";
  Future<void> signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }
  Future<String> currentUser() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    FirebaseUser user = await _firebaseAuth.currentUser();
    final db1 = FirebaseDatabase.instance.reference().child("User/${user.uid}");
        db1.once().then((DataSnapshot snapshot){
          setState(() {
            url=snapshot.value['image'];
          });  
      }).catchError((e){
                                  print(e);
                                });
      return user != null ? user.uid : null;
  }
  
  Future<String> getUserId() async{
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final databaseReference = FirebaseDatabase.instance.reference();
    FirebaseUser user = await _firebaseAuth.currentUser();
    id=user.uid;
    databaseReference.child("User/"+id).once().then((DataSnapshot snap){
      setState(() {
        name=snap.value["name"];
        email=snap.value["email"];
        firstLetter=name.substring(0,1).toUpperCase();
      });
      
    });
    
    return user != null ? user.uid : null;
  }
  @override
  void initState() {
   
    super.initState();
    currentUser();
    getUserId();
  }
    showAlertDialog(BuildContext context) {

  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("No"),
    onPressed:  () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Yes"),
    onPressed:  () {
      signOut(context);
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("VinoraRep"),
    content: Text("Are you sure want to Exit ?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
              appBar: AppBar(
                title: Text('Vinora'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () => showAlertDialog(context),
                    color: Colors.red,
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
                                                            Text("Registered",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,color: Colors.green),)
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
                                                            Text("ABC pvt Ltd",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                                            Text("Not Registered",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,color: Colors.red),)
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
                                            currentAccountPicture: Container(
                      alignment: Alignment.center,
                        width: 150.0,
                        height: 150.0, 
                        decoration: BoxDecoration(
                            color: Colors.red,
                            image: DecorationImage(
                              alignment: Alignment.center,
                                image: NetworkImage(
                                  
                                    url),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.all(Radius.circular(85.0)),
                            boxShadow: [
                              BoxShadow(blurRadius: 7.0, color: Colors.black)
                            ])),
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
}