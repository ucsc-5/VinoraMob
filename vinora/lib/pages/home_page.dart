import 'package:flutter/material.dart';
import '../widgets/bought_foods.dart';
import '../widgets/food_category.dart';
import '../widgets/search_file.dart';
import '../pages/category_page.dart';

// Data
import '../data/food_data.dart';

// Model 
import '../models/food_model.dart';

class HomePage extends StatefulWidget{
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  
  List<Food> _foods = foods;
  
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        children: <Widget>[
          
          FoodCategory(),
          SizedBox(height: 20.0,),
          SearchField(),
          SizedBox(height: 20.0,),
          
          SizedBox(height: 20.0),
          Column(
            children: _foods.map(_buildFoodItems).toList(),
            
          ),
        ],
      ),
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