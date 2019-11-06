import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vinora/theme.dart';


class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String userId;
  double subTotal=0;
  @override
  void initState() {
    getCurrentUserId();
    
       Firestore.instance
      .collection('cart')
      .where("userId", isEqualTo: userId)
      .snapshots()
      .listen((data) =>
          data.documents.forEach((doc) => 
          subTotal+=doc["total"]));
        
        
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
            height: 290,
            child: Padding(
            padding: EdgeInsets.all(10),
            child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('cart').where("userId", isEqualTo:userId).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return new Text('Loading...');
              default:
                return new ListView(
                  children: snapshot.data.documents.map((DocumentSnapshot document) {
                    
                    
                    return Dismissible(
                      key: Key(document.documentID),
                      child: ListTile(
                      title: new Text(document['itemName'].toString(),style: AppTheme.title,),
                      subtitle: new Text("Quantity : "+document['quantity'].toString(),style: AppTheme.subtitle,),
                      trailing: Text("Total :"+document['total'].toString(),style: AppTheme.title,),
                      leading: CircleAvatar(radius: 30,
                                backgroundImage: NetworkImage(
                                   document['imageUrl'] ),
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
                                  });
                                    
                                    
                                    


                                  },
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
        FirebaseUser user = await _firebaseAuth.currentUser();
        setState(() {
          userId=user.uid;
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
          GestureDetector(
            
            child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(35.0),
              ),
              child: Center(
                child: Text(
                  "Proceed To Checkout",
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
  
}
