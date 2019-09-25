import 'dart:async';

import 'package:flutter/material.dart';
import 'package:getinfo/database/policy.dart';
import 'Home.dart';
import 'package:sembast/sembast.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:device_apps/device_apps.dart';





void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

    bool isConfig = true;
    var store = StoreRef.main();
    List apps = [];
    List all_apps=[];


    

  @override
  void initState() {

  
    super.initState();
  }


  @override
  Widget build(BuildContext context)  {
    
    
    
    return MaterialApp(
      
      
      home:Home(apps),
      debugShowCheckedModeBanner: false,
    );
  }
}




