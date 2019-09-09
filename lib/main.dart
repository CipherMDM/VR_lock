
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getinfo/config.dart';
import 'Home.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';




void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

    bool isConfig = true;
    var store = StoreRef.main();
  
    Future<Database>  openDB()async{

  
    String dbPath = 'sample.db';
    
   



    
    DatabaseFactory dbFactory = databaseFactoryIo;

    // We use the database factory to open the database
    Database db = await dbFactory.openDatabase(dbPath);
    try{
       store.record("Config").get(db);
    }catch(_){
        print("object");
        store.record("Config").put(db, false);
    }
   
    return db;
  }

  @override
  void initState() {
    // TODO: implement initState
   
    super.initState();
  }


  @override
  Widget build(BuildContext context)  {

    
        
    return MaterialApp(

      
      home:Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}




