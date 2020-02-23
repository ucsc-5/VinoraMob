import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:vinora/companies/notReg.dart';
import 'package:vinora/theme.dart';
import 'auth.dart';
import 'auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'companies/RoyalVintage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class HomePage extends StatefulWidget {
  
  final VoidCallback onSignedOut;
  
  HomePage({Key key, this.onSignedOut}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String id="null",name="Loding..",email="Loding..",firstLetter="L";
  String url="https://www.stickpng.com/assets/images/585e4bf3cb11b227491c339a.png";
  Future<void> signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }
  String page=null;
  String item=null;
  String orderId=null;
  String comment=null;
  String returnGoods;
  String companyName;
  String companyId;
  Future<String> currentUser() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    FirebaseUser user = await _firebaseAuth.currentUser();
    Firestore.instance
        .collection('retailers')
        .document(user.uid)
        .get()
        .then((DocumentSnapshot ds) {
          setState(() {
            url=ds['url'];
          });
      // use ds as a snapshot
    });
    
      return user != null ? user.uid : null;
  }
  int currentTab = 0;
  Future<String> getUserId() async{
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    
    FirebaseUser user = await _firebaseAuth.currentUser().then((onValue){
      id=onValue.uid;
      Firestore.instance
        .collection('retailers')
        .document(onValue.uid)
        .get()
        .then((DocumentSnapshot ds) {
          setState(() {
            setState(() {
        name=ds['shopName'];
        email=ds['email'];
        firstLetter=name.substring(0,1).toUpperCase();
      });
          });
      // use ds as a snapshot
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
    title: Text("VinoraMob"),
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
                title: Text('Vinora Mob'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () => showAlertDialog(context),
                    color: Colors.red,
                  )
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentTab,
            onTap: (index) {
              setState(() {
                currentTab = index;
                page=null;
                item=null;
              });
            },
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_balance,
                ),
                title: Text("Registered Companies"),
              ),
              
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.business,
                ),
                title: Text("Other Companies"),
              ),
            ],
          ),
              body:page!=null?StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('orders').where('retailerId',isEqualTo: id).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new 
          Center(
            child: Text('Error: ${snapshot.error}'),
          )
          ;
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                companyName=document['companyName'];
                companyId=document['companyId'];
                return new ListTile(
                  contentPadding:EdgeInsets.only(top: 10,bottom: 10,left: 10),
                  onTap: (){
                    setState(() {
                      orderId=document.documentID;
                    page=null;
                    item='1';
                    });

                            },
                            onLongPress: (){
                              orderId=document.documentID;
                    confirmOrder(context);
                  },
                  leading:  CircleAvatar(
                                                child: Icon(Icons.add_shopping_cart),
                                              ),
                  title: new Padding(
                    padding: EdgeInsets.only(left:10),
                    child:Text(document['companyName'],style: AppTheme.headline,) 
                  ) ,
                  subtitle: new Padding(
                    padding: EdgeInsets.only(left:10),
                    child:Text("Order Date :"+document['year'].toString()+"-"+document['month'].toString()+"-"+document['date'].toString()+"\n"+"Rs:"+document['total'].toString()+"\n",style: AppTheme.subtitle,) ,
                  ) ,
                  trailing: new Padding(
                    padding: EdgeInsets.only(left:10,right: 10),
                    child: document['state'].toString()=='1'? Text("Confirmed", style: TextStyle(color: Colors.green,fontSize: 16,fontWeight: FontWeight.bold),):Text("Pending",style: TextStyle(color: Colors.amber,fontSize: 16,fontWeight: FontWeight.bold)),
                  ),
                );
              }).toList(),
            );
        }
      },
    ):item!=null&&orderId!=null?StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('orders/$orderId/items').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new 
          Center(
            child: Text('Error: ${snapshot.error}'),
          )
          ;
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  contentPadding:EdgeInsets.only(top: 10,bottom: 10,left: 10),
                  onTap: (){
                   editName(context,document);
                  },
                  
                  leading: CircleAvatar(
                    radius: 30,
                                backgroundImage: NetworkImage(
                                   document['itemImagePath'] ),
                                backgroundColor:
                                    Colors.transparent,
                              ),
                  title: new Padding(
                    padding: EdgeInsets.only(left:10),
                    child:Text(document['itemName'],style: AppTheme.headline,) 
                  ) ,
                  subtitle: new Padding(
                    padding: EdgeInsets.only(left:10),
                    child:Text("Brand : "+document['brand']+"\nQuantity : "+document['quantity'].toString()+" "+document['type'],style: AppTheme.subtitle,) ,
                  ) ,
                  trailing: new Padding(
                    padding: EdgeInsets.only(left:10,right: 10),
                    child:Text("Rs : "+document['total'].toString(),style: AppTheme.title,) ,
                  ),
                );
              }).toList(),
            );
        }
      },
    )
              :currentTab!=0? StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('retailers/${id}/notRegCompanies').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new 
          Center(
            child: Text('Error: ${snapshot.error}'),
          )
          ;
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  contentPadding:EdgeInsets.only(top: 10,bottom: 10,left: 10),
                  onTap: (){
                   Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen1(name:document['companyName'],address:document['address'],contactNumber:document['contactNumber'],imagePath:document['imagePath'],companyId: document['companyId'],id:id),
      ),
    );
                  },
                  leading: CircleAvatar(
                    radius: 30,
                                backgroundImage: NetworkImage(
                                   document['imagePath'] ),
                                backgroundColor:
                                    Colors.transparent,
                              ),
                  title: new Padding(
                    padding: EdgeInsets.only(left:10),
                    child:Text(document['companyName'],style: AppTheme.headline,) 
                  ) ,
                  subtitle: new Padding(
                    padding: EdgeInsets.only(left:10),
                    child:Text(document['address'],style: AppTheme.title,) ,
                  ) ,
                );
              }).toList(),
            );
        }
      },
    ): StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('retailers/${id}/registeredCompanies').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new 
          Center(
            child: Text('Error: ${snapshot.error}'),
          )
          ;
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                
                return new ListTile(
                  contentPadding:EdgeInsets.only(top: 10,bottom: 10,left: 10),
                  onTap: (){
                  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(name:document['companyName'],address:document['address'],contactNumber:document['contactNumber'],imagePath:document['imagePath'],companyId: document['companyId'],id:id),
      ),
    );
                  },
                  leading: CircleAvatar(
                    radius: 30,
                                backgroundImage: NetworkImage(
                                   document['imagePath'] ),
                                backgroundColor:
                                    Colors.transparent,
                              ),
                  title: new Padding(
                    padding: EdgeInsets.only(left:10),
                    child:Text(document['companyName'],style: AppTheme.headline,) 
                  ) ,
                  subtitle: new Padding(
                    padding: EdgeInsets.only(left:10),
                    child:Text(document['address'],style: AppTheme.title,) ,
                  ) ,
                );
              }).toList(),
            );
        }
      },
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
                                              leading: Icon(Icons.add_shopping_cart),
                                              title: Text("Return Goods and Comments"),
                                              onTap: (){

                                                setState(() {
                                                  page='1';
                                                  item=null;
                                                });
                                                Navigator.pop(context);
                                              },
                                            ),
                                            ListTile(
                                              leading: Icon(Icons.exit_to_app),
                                              title: Text("Exit"),
                                              onTap: (){
                                                showAlertDialog(context);
                                              },
                                            ),
                                            ],
                                          ),
                                            ),
                                            
                                            
                                          
                                            
                                        );
                                        
  }

Future<bool> confirmOrder(BuildContext context) async {
                                      return showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Confirm the Order', style: TextStyle(fontSize: 16.0)),
                                              content: Container(
                                                height:50.0,
                                                width: 50.0,
                                                
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('No'),
                                                  textColor: Colors.blue,
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    
                                                  },
                                                ),
                                                FlatButton(
                                                  child: Text('Confirm'),
                                                  textColor: Colors.blue,
                                                  onPressed: () {
                                                    confirmOrder1();
                                                                                                       
                                                                                                          
                                                                                                         
                                                                                                                           
                                                                                                                              
                                                                                                        Navigator.of(context).pop(); 
                                                                                                                         
                                                                                                                        },
                                                                                                                      )
                                                                                                                    ],
                                                                                                                  );
                                                                                                                });
                                                                                                          }
                                                    
                                                    
                                                      Future<bool> editName(BuildContext context,DocumentSnapshot document) async {
                                                                                          return showDialog(
                                                                                              context: context,
                                                                                              barrierDismissible: false,
                                                                                              builder: (BuildContext context) {
                                                                                                return AlertDialog(
                                                                                                  title: Text('Add Your Comment', style: TextStyle(fontSize: 16.0)),
                                                                                                  content: Container(
                                                                                                    height: 140.0,
                                                                                                    width: 100.0,
                                                                                                    child: Column(
                                                                                                      children: <Widget>[
                                                                                                        TextField(
                                                                                                          decoration: InputDecoration(
                                                                                                              labelText: 'Comment',
                                                                                                              labelStyle: TextStyle(
                                                                                                                  fontSize: 14,
                                                                                                                  fontFamily: 'Montserrat',
                                                                                                                  fontWeight: FontWeight.bold)),
                                                                                                          onChanged: (value) {
                                                                                                            comment=value;
                                                                                                          },
                                                                                                        ),
                                                                                                        TextField(
                                                                                                          decoration: InputDecoration(
                                                                                                              labelText: 'Quantity of Return Goods (Kg)',
                                                                                                              labelStyle: TextStyle(
                                                                                                                  fontSize: 14,
                                                                                                                  fontFamily: 'Montserrat',
                                                                                                                  fontWeight: FontWeight.bold)),
                                                                                                          onChanged: (value) {
                                                                                                            returnGoods=value;
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
                                                                                                      child: Text('Send'),
                                                                                                      textColor: Colors.blue,
                                                                                                      onPressed: () {
                                                                                                      
                                                                                                       
                                                                                                          
                                                                                                          addReturnGoods(name,document);
                                                                                                                           
                                                                                                                              
                                                                                                        Navigator.of(context).pop(); 
                                                                                                                         
                                                                                                                        },
                                                                                                                      )
                                                                                                                    ],
                                                                                                                  );
                                                                                                                });
                                                                                                          }
                                                                                                        
                                                                                                          Future<bool> addReturnGoods(String name,DocumentSnapshot document) async{
                                                                                                            DateTime now = DateTime.now();
                                                                                                            Firestore.instance.collection('returnGoods').document()
                                                                                                      .setData({ 'orderId': orderId,
                                                                                                      'companyName':companyName,
                                                                                                      'companyId':companyId, 
                                                                                                      'retailerId': id,
                                                                                                      'items':document.data,
                                                                                                      'comment':comment,
                                                                                                      'returnGoodsQuantity':double.parse(returnGoods),
                                                                                                      'time':now  });
                                                                                                            
                                                                                                        Toast.show("Successfuly Send", context, duration: 4, gravity:  Toast.BOTTOM,backgroundColor: Colors.green);    
                                                                                                            
                                                                                                                  return true;
                                                                                                            
                                                                                                          }
                                                                                                           void confirmOrder1() async {
                                                                                                             
                                                      final DocumentReference postRef = Firestore.instance.document('orders/$orderId');
                                          Firestore.instance.runTransaction((Transaction tx) async {
                                            DocumentSnapshot postSnapshot = await tx.get(postRef);
                                            if (postSnapshot.exists) {
                                              await tx.update(postRef, <String, dynamic>{'state':  1});
                                            }
                                          });
                                          Toast.show("Successfuly Confirmed", context, duration: 4, gravity:  Toast.BOTTOM,backgroundColor: Colors.green);
}
                                                    }
                                                    
                                                   