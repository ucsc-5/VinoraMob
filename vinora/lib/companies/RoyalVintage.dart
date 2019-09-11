import 'package:flutter/material.dart';
import 'package:vinora/chat/chat.dart';
import '../pages/home_page.dart';
import '../pages/order_page.dart';
import '../pages/favorite_page.dart';
import '../pages/profile_page.dart';
import '../data/food_data.dart';
import '../global.dart' as globals;
class MainScreen extends StatefulWidget {
  
  
  @override
  _MainScreenState createState() => _MainScreenState();

  
  
}

class _MainScreenState extends State<MainScreen> {
  
  int currentTab = 0;
  
  // Pages
  HomePage homePage;
  OrderPage orderPage;
  FavoritePage favoritePage;
  ProfilePage profilePage;

  List<Widget> pages;
  Widget currentPage;

  @override
  void initState() {
    
    homePage = HomePage();
    orderPage = OrderPage();
    favoritePage = FavoritePage();
    profilePage = ProfilePage();
    pages = [homePage, orderPage, favoritePage, profilePage];

    currentPage = homePage;
    
    super.initState();
    Load();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                title: Text('Royal Vintage'),
                
              ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        onTap: (index) {
          setState(() {
            currentTab = index;
            currentPage = pages[index];
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
            title: Text("Orders"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
            ),
            title: Text("Favorite"),
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
        builder: (context) => Chat(
          user: globals.Test.globalUser,
        ),
      ),
    );
                                    },
                                  ),
    );
  }
}
