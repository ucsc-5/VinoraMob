import 'package:flutter/material.dart';
import 'auth.dart';
import 'auth_provider.dart';
import 'root_page.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        
        title: 'Vinora',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: RootPage(),
      ),
    );
  }
}