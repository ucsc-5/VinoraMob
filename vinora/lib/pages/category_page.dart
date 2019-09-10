import 'package:flutter/material.dart';
import 'package:vinora/data/category.dart';
import 'package:vinora/models/category_mode1l.dart';
import 'package:vinora/widgets/bout_category.dart';
import '../widgets/food_category.dart';
import '../widgets/search_file.dart';
// Data


// Model 

class Category extends StatefulWidget {
  final String value;
  
  Category({Key key, this.value}) : super(key: key);
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<Category1> _category = category;
  @override
  void initState() {
    Load1("${widget.value}");
    super.initState();
  }
 
   
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Royal Vintage"),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        children: <Widget>[
          
          FoodCategory(),
          SizedBox(height: 20.0,),
          SearchField(),
          SizedBox(height: 20.0,),
          
          SizedBox(height: 20.0),
          Column(
            children: category.map(_buildFoodItems).toList(),
            
          ),
        ],
      ),
    );
  }


  Widget _buildFoodItems(Category1 category){
    return Container(
      
      child: GestureDetector(
        onTap: (){
         
      },
        child: BoughtCategory(
          id: category.id,
          name:category.name,
          imagePath: category.imagePath,
          category: category.category,
          discount: category.discount,
          price: category.price,
          discription: category.discription,
        ),
      ),
        
      );
  }
  
}