import 'package:flutter/material.dart';
import 'package:vinora/chat/chat.dart';
import 'package:vinora/companies/req.dart';
import '../pages/home_page.dart';
import '../pages/profile_page.dart';

class MainScreen1 extends StatefulWidget { 
  final String name;
  final String address;
  final String contactNumber;
  final String imagePath;
  final String companyId;
  final String id;
   MainScreen1({Key key,  @required this.name,@required this.address,@required this.contactNumber,@required this.imagePath,@required this.companyId,@required this.id}): super(key: key);
  @override
  _MainScreen1State createState() => _MainScreen1State();

}
class _MainScreen1State extends State<MainScreen1> {
  
  int currentTab = 0;
  HomePage homePage;
  ReqPage reqPage;
  Profile profilePage;

  List<Widget> pages;
  Widget currentPage;

  @override
  void initState() {
    
    homePage = HomePage(name:widget.name,address:widget.address,contactNumber:widget.contactNumber,imagePath:widget.imagePath,companyId:widget.companyId);
    profilePage = Profile();
    reqPage=ReqPage(companyId:widget.companyId);
    pages = [homePage,reqPage, profilePage];

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
              Icons.library_add,
            ),
            title: Text("Request"),
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
     
    );
  }
}
