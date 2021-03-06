import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vinora/auth_provider.dart';
import 'package:vinora/chat/chat.dart';
import 'package:vinora/map/location.dart';
import '../pages/home_page.dart';
import '../pages/order_page.dart';
import '../pages/profile_page.dart';
import '../auth.dart';
class MainScreen extends StatefulWidget { 
  final String name;
  final String address;
  final String contactNumber;
  final String imagePath;
  final String companyId;
  final String id;
   MainScreen({Key key,  @required this.name,@required this.address,@required this.contactNumber,@required this.imagePath,@required this.companyId,@required this.id}): super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();

}
class _MainScreenState extends State<MainScreen> {
  
  int currentTab = 0;
  HomePage homePage;
  OrderPage orderPage;
  GetUserLocation order;
  Profile profilePage;

  List<Widget> pages;
  Widget currentPage;
  Widget page;
  @override
  void initState() {
    
    homePage = HomePage(name:widget.name,address:widget.address,contactNumber:widget.contactNumber,imagePath:widget.imagePath,companyId:widget.companyId);
    orderPage = OrderPage();
    order = GetUserLocation(companyId:widget.companyId,id:widget.id);
    profilePage = Profile();
    pages = [homePage, orderPage, order, profilePage];

    currentPage = homePage;
    
    super.initState();
    
    

  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        onTap: (index) {
          setState(() {
            currentTab = index;
            currentPage = pages[index];
            page=null;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
            ),
            title: Text("Cart"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.business_center,
            ),
            title: Text("Order"),
          ),
          
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            title: Text("Profile"),
          ),
        ],
      ),
      body: currentPage,
      
      floatingActionButton: FloatingActionButton (
                          
                                    child: Icon(Icons.chat),
                                    onPressed: (){
                                      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(id:widget.id,companyId: widget.companyId,)
      ),
    );
                                    },
                                  ),
    );
  }
}
