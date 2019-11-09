import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vinora/components/show_more_button.dart';
import 'package:vinora/components/upper_bar.dart';
import 'package:vinora/pages/ordering.dart';
import 'package:vinora/theme.dart';



class HomePage extends StatefulWidget{
  final String name;
  final String address;
  final String contactNumber;
  final String imagePath;
  final String companyId;
  HomePage({Key key,  @required this.name,@required this.address,@required this.contactNumber,@required this.imagePath,@required this.companyId}):super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  bool isExpanded=false;
  
  @override
  Widget build(BuildContext context){
    
        return Scaffold(
          body: 
          Container(
                width: double.maxFinite,
                height: double.maxFinite,
                child: Stack(
                  children: <Widget>[
                    Image.network(
                        widget.imagePath),
                    Positioned(
                      top: 155,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(25.0))),
                        child: Column(
                          children: <Widget>[
                            UpperBar( isExpanded: isExpanded,name:widget.name,address:widget.address,contactNumber:widget.contactNumber),
                        ShowMoreButton(
                            isExpanded: isExpanded,
                            callback: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            }),
                            Container(
                              height:300,
                              child:StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('items').where("companyId", isEqualTo: widget.companyId).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
          
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new
          Center(
            child: Text('Loading...'),
          ) ;
          
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  onTap: (){
                    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Ordering(name:document['itemName'],description:document['description'],unitPrice:document['unitPrice'],imagePath:document['itemImagePath'],itemId: document.documentID,countity: document['quantity'].toDouble(),companyId:widget.companyId,address: widget.address,companyContact: widget.contactNumber,companyName: widget.name,companyImage: widget.imagePath,brand: document['brand'],state: document['state'],type: document['type'],),
      ),
    );
                  },
                  leading: CircleAvatar(radius: 30,
                                backgroundImage: NetworkImage(
                                   document['itemImagePath'] ),
                                backgroundColor:
                                    Colors.transparent,
                              ),
                  title: new Text(document['itemName'],style: AppTheme.headline),
                  subtitle: new Text(document['description'],style: AppTheme.subtitle,),
                  trailing: Text("Rs : "+document['unitPrice'].toString(),style: AppTheme.title,),
                );
              }).toList(),
            );
        }
      },
    ),
                            )
                      
                      ],
                    ),
                    
                  ),
                ),
              ],
            ))
      
    );
  }

    

}