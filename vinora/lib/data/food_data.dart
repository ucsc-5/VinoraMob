import '../models/food_model.dart';
import 'package:firebase_database/firebase_database.dart';
final foods = [Food()];
int count=0;
   
     Future<void> Load() async
     {
     count++;
     if(count==1){
       foods.removeAt(0);
       final db = await FirebaseDatabase.instance.reference().child("Category");
      db.once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key,values) {
       foods.add(
         Food(
            id: values["id"],
            name: values["Name"],
            imagePath: values["Image"],
            category: "1",
            price: 22.0,
            discount: 33.5,
            ratings: 99.0,
         )
       );
      
    });
 });
     }
     } 
 

