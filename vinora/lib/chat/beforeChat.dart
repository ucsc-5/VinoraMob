import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class BChat extends StatefulWidget {
  @override
  _BChatState createState() => _BChatState();
}

class _BChatState extends State<BChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Members"),
      ),
    );
  }
}