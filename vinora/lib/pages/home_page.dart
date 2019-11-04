import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vinora/components/show_more_button.dart';
import 'package:vinora/components/upper_bar.dart';
import 'package:vinora/theme.dart';
import '../widgets/bought_foods.dart';
import '../widgets/food_category.dart';
import '../widgets/search_file.dart';
import '../pages/category_page.dart';

// Data
import '../data/food_data.dart';

// Model 
import '../models/food_model.dart';

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
  
  List<Food> _foods = foods;
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
                              height: 300,
                              child:StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('items').where("companyId", isEqualTo: widget.companyId).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
          
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
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

    Widget _buildFoodItems(Food food){
    return GestureDetector(
      
      onTap: (){
         var route = new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new Category(value: food.id,),
                );
                Navigator.of(context).push(route);
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 20),
        child: BoughtFood(
          id: food.id,
          name: food.name,
          imagePath: food.imagePath,
          category: food.category,
          discount: food.discount,
          price: food.price,
          
        ),
      ),
        
      );
  }

}