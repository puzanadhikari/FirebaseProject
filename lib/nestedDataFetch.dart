import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NestedDataFetch extends StatefulWidget {
  const NestedDataFetch({super.key});

  @override
  State<NestedDataFetch> createState() => _NestedDataFetchState();
}

class _NestedDataFetchState extends State<NestedDataFetch> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nested Data"),backgroundColor: Colors.green,),
      body: SingleChildScrollView(

      ),
    );
  }
}