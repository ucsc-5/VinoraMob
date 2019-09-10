import 'package:vinora/models/category_mode1l.dart';
import 'package:firebase_database/firebase_database.dart';
final category = [Category1(
  id: "values[]",
            name: "Cup Masoor Parippu",
            imagePath: "https://cpimg.tistatic.com/04697293/b/4/Lal-Masoor-Dal.jpg",
            category: "1",
            price: "12",
            discount: "1",
            discription: "llll",
)
];
int count=0;
   class Load1{
      Load1(String value) 
     {
      category.removeAt(0);
     count++;
     
     if(count==1){
       final db1 = FirebaseDatabase.instance.reference().child("Food"); 
      db1.once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key,values) {
        if(values["MId"].toString()==value){
          category.add(
         Category1(
            id: values["MId"].toString(),
            name: values["Name"].toString(),
            imagePath: values["Image"],
            category: "1",
            price:  values["Price"].toString(),
            discount: values["Discount"].toString(),
            discription: values["Discription"].toString(),
         )
       );
        }
        
       
      
    });
 });
     }
     } 
 
   } 

