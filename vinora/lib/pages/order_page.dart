import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:vinora/theme.dart';


class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  String userId;
  double subTotal=0;
  double updateQuantity;
  String availableCount;
  String companyId;
  String shopName;
  int date;
  int month;
  int year;
  @override
  void initState() {
    subTotal=0;
    getCurrentUserId();
    date=new DateTime.now().day;
    month=new DateTime.now().month;
    year=new DateTime.now().year;
    
  }
 
      @override
      Widget build(BuildContext context) {
       
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(
              "Your Food Cart",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0.0,
            centerTitle: true,
          ),
          body:Column(
            children: <Widget>[
              Container(
            height: 260,
            child: Padding(
            padding: EdgeInsets.all(10),
            child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('cart').where("retailerId", isEqualTo:userId).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return new
              Center(
                child:Text('Loading...') ,
              );
               
              default:
                return new ListView(
                  children: snapshot.data.documents.map((DocumentSnapshot document) {
                    
                    
                    return Dismissible(
                      key: Key(document.documentID),
                      child: ListTile(
                        onTap: (){
                          editQuantity(context,document);
                                                   
                                                  },
                                                title: new Text(document['itemName'].toString(),style: AppTheme.title,),
                                                subtitle: new Text("Quantity : "+document['quantity'].toString(),style: AppTheme.subtitle,),
                                                trailing: Text("Total :"+document['total'].toString(),style: AppTheme.title,),
                                                leading: CircleAvatar(radius: 30,
                                                          backgroundImage: NetworkImage(
                                                             document['itemImagePath'] ),
                                                          backgroundColor:
                                                              Colors.transparent,
                                                        ),
                                              ),
                                              background: Container(
                                                              color: Colors.red,
                                                              padding: EdgeInsets.all(25),
                                                              child: Text("Delete ?",textScaleFactor: 1.5,style: TextStyle(color: Colors.white),),
                                                            ),
                                                            onDismissed: (direction){
                                                              final DocumentReference postRef1 = Firestore.instance.document('cart'+'/${document.documentID}');
                                                              Firestore.instance.runTransaction((Transaction tx) async {
                                                              DocumentSnapshot postSnapshot1 = await tx.get(postRef1);
                                                              if (postSnapshot1.exists) {
                                                                
                                                                final DocumentReference postRef = Firestore.instance.document('items/'+postSnapshot1.data['itemId']);
                                                              Firestore.instance.runTransaction((Transaction tx) async {
                                                              DocumentSnapshot postSnapshot = await tx.get(postRef);
                                                              if (postSnapshot.exists) {
                                                               await tx.update(postRef, <String, dynamic>{'quantity': postSnapshot.data['quantity'] + postSnapshot1.data['quantity']});
                                                              }
                                                            }); 
                                                              }
                                                            }).then((t){
                                                              Firestore.instance.document("cart"+'/${document.documentID}').delete();
                                                              snapshot.data.documents.remove(document);
                                                            });},
                                              ); 
                                               
                                            }).toList(),
                                          );
                                      }
                                    },
                                  ),
                                    ),
                                    ),
                                    
                                      ],
                                    ),
                                    bottomNavigationBar: _buildTotalContainer(),  
                                  );
                                }
                                
                                void getCurrentUserId() async {
                                  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                                  FirebaseUser user = await _firebaseAuth.currentUser().then((onValue){
                                    
                                    getSubTotal(onValue.uid);
                                            Firestore.instance
                                            .collection('retailers')
                                            .document(onValue.uid)
                                            .get()
                                            .then((DocumentSnapshot ds) {
                                             setState(() {
                                               shopName=ds.data['shopName'];
                                               userId=onValue.uid;
                                             });
                                          
                                            
                                               Firestore.instance
                                          .collection('cart')
                                          .where("retailerId", isEqualTo: onValue.uid)
                                          .snapshots()
                                          .listen((data) =>
                                              data.documents.forEach((doc) => 
                                              companyId=doc['companyId']));    
                                        });
                                        
                                        
                                                                      });
                                                                      
                                                                      
                                                                    }
                                                              
                                                                    Widget _buildTotalContainer() {
                                                                  return Container(
                                                                    height: 220.0,
                                                                    padding: EdgeInsets.only(
                                                                      left: 10.0,
                                                                      right: 10.0,
                                                                    ),
                                                                    child: Column(
                                                                      children: <Widget>[
                                                                        Row(
                                                                          mainAxisSize: MainAxisSize.max,
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: <Widget>[
                                                                            Text(
                                                                              "Subtotal",
                                                                              style: TextStyle(
                                                                                  color: Color(0xFF9BA7C6),
                                                                                  fontSize: 16.0,
                                                                                  fontWeight: FontWeight.bold),
                                                                            ),
                                                                            Text(
                                                                              subTotal.toString(),
                                                                              style: TextStyle(
                                                                                  color: Color(0xFF6C6D6D),
                                                                                  fontSize: 16.0,
                                                                                  fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height: 10.0,
                                                                        ),
                                                                        Row(
                                                                          mainAxisSize: MainAxisSize.max,
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: <Widget>[
                                                                            Text(
                                                                              "Discount",
                                                                              style: TextStyle(
                                                                                  color: Color(0xFF9BA7C6),
                                                                                  fontSize: 16.0,
                                                                                  fontWeight: FontWeight.bold),
                                                                            ),
                                                                            Text(
                                                                              "0.0",
                                                                              style: TextStyle(
                                                                                  color: Color(0xFF6C6D6D),
                                                                                  fontSize: 16.0,
                                                                                  fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height: 10.0,
                                                                        ),
                                                                        
                                                                        SizedBox(
                                                                          height: 10.0,
                                                                        ),
                                                                        Divider(
                                                                          height: 2.0,
                                                                        ),
                                                                        SizedBox(
                                                                          height: 20.0,
                                                                        ),
                                                                        Row(
                                                                          mainAxisSize: MainAxisSize.max,
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: <Widget>[
                                                                            Text(
                                                                              "Cart Total",
                                                                              style: TextStyle(
                                                                                  color: Color(0xFF9BA7C6),
                                                                                  fontSize: 16.0,
                                                                                  fontWeight: FontWeight.bold),
                                                                            ),
                                                                            Text(
                                                                              subTotal.toString(),
                                                                              style: TextStyle(
                                                                                  color: Color(0xFF6C6D6D),
                                                                                  fontSize: 16.0,
                                                                                  fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height: 20.0,
                                                                        ),
                                                                        FlatButton(
                                                                          onPressed: (){
                                                                            addOrder();
                                    
                                                                                                                  },
                                                                                                                  child: Container(
                                                                                                                    height: 50.0,
                                                                                                                    decoration: BoxDecoration(
                                                                                                                      color: Theme.of(context).primaryColor,
                                                                                                                      borderRadius: BorderRadius.circular(35.0),
                                                                                                                    ),
                                                                                                                    child: Center(
                                                                                                                      child: Text(
                                                                                                                        "Confirm Order",
                                                                                                                        style: TextStyle(
                                                                                                                          color: Colors.white,
                                                                                                                          fontSize: 18.0,
                                                                                                                          fontWeight: FontWeight.bold,
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                SizedBox(
                                                                                                                  height: 20.0,
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          );
                                                                                                        }
                                                                                                      
                                                                                                        Future<bool> editQuantity(BuildContext context, document) async{
                                                                                                           
                                                                                                          return showDialog(
                                                                                                                      context: context,
                                                                                                                      barrierDismissible: false,
                                                                                                                      builder: (BuildContext context) {
                                                                                                                        return AlertDialog(
                                                                                                                          title: Text('Update Your Cart ', style: TextStyle(fontSize: 16.0)),
                                                                                                                          content: Container(
                                                                                                                            height: 80.0,
                                                                                                                            width: 80.0,
                                                                                                                            child: Column(
                                                                                                                              children: <Widget>[
                                                                                                                                TextField(
                                                                                                                                  decoration: InputDecoration(
                                                                                                                                      labelText: 'New Quantity',
                                                                                                                                      labelStyle: TextStyle(
                                                                                                                                          fontFamily: 'Montserrat',
                                                                                                                                          fontWeight: FontWeight.bold)),
                                                                                                                                          keyboardType: TextInputType.number,
                                                                                                                                          
                                                                                                                                  onChanged: (value) {
                                                                                                                                    updateQuantity=double.parse(value) ;
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
                                                                                                                                 
                                                                                                                                  updateQuantityMethod(updateQuantity,document);
                                                                                                                                    });                     
                                                                                                                                                          
                                                                                                                                    Navigator.of(context).pop(); 
                                                                                                                                                      
                                                                                                                                                    },
                                                                                                                                                  )
                                                                                                                                                ],
                                                                                                                                              );
                                                                                                                                            });
                                                                                                                                                              }
                                                                                                                                  
                                                                                                                                    Future<bool> updateQuantityMethod(double updateQuantity,document) async {
                                                                                                                                      
                                                                                                                                      if(updateQuantity>=0){
                                                                                                                                          
                                                                                                                                final DocumentReference postRef1 = Firestore.instance.document('cart/${document.documentID}');
                                                                                                                                Firestore.instance.runTransaction((Transaction tx) async {
                                                                                                                                  DocumentSnapshot postSnapshot1 = await tx.get(postRef1);
                                                                                                                                  if (postSnapshot1.exists) {
                                                                                                                                    await tx.update(postRef1, <String, dynamic>{'quantity': updateQuantity,'total':updateQuantity*postSnapshot1.data['unitPrice']});
                                                                                                                                    
                                                                                                                                      }
                                                                                                                                });
                                                                                                                                      }else{
                                                                                                                                        Toast.show("Quantity can't be less than 0. Error.", context, duration: 4, gravity:  Toast.BOTTOM,backgroundColor: Colors.red);
                                                                                                                                      }
                                                                                                                                      
                                                                                                                                    }
                                                                                                                                    
                                                                            
                                                                              void addOrder(){                                                                             

                                                                              final DocumentReference postRef2 = Firestore.instance.document('retailers/$userId');
                                                                              
                                                                              Firestore.instance.runTransaction((Transaction tx) async {
                                                                                DocumentSnapshot postSnapshot2 = await tx.get(postRef2);
                                                                                if (postSnapshot2.exists) {
                                                                                  await tx.update(postRef2, <String, dynamic>{'orderState': 0});
                                                                                }
                                                                              });

                                                                                DocumentReference ref= Firestore.instance.collection('orders').document();
                                                                            ref.setData({ 'total':subTotal,
                                                                            'createDate':new DateTime.now().toString(),
                                                                            'retailerId':userId,
                                                                            'companyId':companyId,
                                                                            'shopName':shopName,
                                                                            'state':-1,
                                                                            'saleRepId':"",
                                                                            'tempTotal':0,
                                                                            'stockManagerId':"",
                                                                            'date':date,
                                                                            'month':month,
                                                                            'year':year,
                                                                            'encDate':year*10000+month*100+date,
                                                                            'saleRepAccept':0,
                                                                            'companyName':'Royal Vintage' }).then((onValue){
                                                                            int count=1;
                                                                              var x=Firestore.instance
                                                                          .collection('cart')
                                                                          .where("retailerId", isEqualTo: userId);
                                                                          x.snapshots()
                                                                          .forEach((data) {
                                                                            count=data.documents.length;
                                                                           
                                                                                data.documents.forEach((doc) { 
                                                                               if(data.documents.length==count){
                                                                                 Firestore.instance.collection('orders/${ref.documentID}/items').document()
                                                                            .setData (doc.data).then((onValue) {
                                                                               Firestore.instance.document("cart/${doc.documentID}").delete();
                                                                               data.documents.remove(doc);
                                                                            });
                                                                               }
                                                                                 
                                                                                count=0;
                                                                             
                                                                          });
                                                                             
                                                                              });
                                                                              
                                                                            }).then((onValue){
                                                                              setState(() {
                                                                                Toast.show("Order added Successfully.", context, duration: 4, gravity:  Toast.BOTTOM,backgroundColor: Colors.green);
                                                                              });
                                                                            });
                                                                             
                                                                              }
                                    
                                      void getSubTotal(String uid) {
                                        Firestore.instance
      .collection('cart')
      .where("retailerId", isEqualTo: uid)
      .snapshots()
      .listen((data) =>
          data.documents.forEach((doc) => 
          subTotal+=doc["total"]));
                                      }
  
}
