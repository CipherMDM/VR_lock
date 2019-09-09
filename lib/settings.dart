import 'dart:io';

import 'package:flutter/material.dart';
import 'package:getinfo/config.dart';

import 'package:settings_plugin/settings_plugin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
  String fg;
  Settings(this.fg);
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.cancel,color: Colors.red,),
                 onPressed: (){
                   showDialog(context: context,builder: (context){
                          TextEditingController cont = TextEditingController();
                          return AlertDialog(
                             title: Text("Admin Panel"),
                             content: Container(
                               height: 35,
                               child: Container(
                                 height: 35,
                                 child: TextField(
                                   
                                   controller: cont,
                                   decoration: InputDecoration(
                                     suffixIcon: Icon(Icons.visibility),
                                     hintText: "Enter Pin",
                                     contentPadding: EdgeInsets.only(left: 15,right: 8,top: 8,bottom: 8),
                                     border: OutlineInputBorder(
                                       borderRadius: BorderRadius.circular(20)
                                     )
                                   ),
                                 ),
                               ),
                             ),
                             actions: <Widget>[
                               Padding(
                                 padding: const EdgeInsets.all(18.0),
                                 child: GestureDetector(
                                   onTap: (){
                                       if(cont.text=="1234"){
                                          Navigator.of(context).pop();
                                          var route = MaterialPageRoute(builder: (context)=>Config());
                                          Navigator.push(context, route);
                                         
                                       }
                                   },
                                   child: Text("Enter",style:TextStyle(color: Colors.red)),
                                 ),
                               ),
                               Padding(
                                 padding: const EdgeInsets.all(18.0),
                                 child: GestureDetector(
                                   child: Text("cancel"),
                                   onTap: (){
                                     Navigator.of(context).pop();
                                   },
                                 ),
                               )
                             ],
                          );
                   });
                 },
          )
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.only(right:10.0),
            child: Center(child: Text("Settings",style: TextStyle(color: Colors.black),),),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection("Informations").where("Device_info.id",isEqualTo:widget.fg).snapshots(),
        builder: (context, snapshot) {
        
          List<DocumentSnapshot> doc = snapshot.data.documents;
          
          return !snapshot.hasData?Center(child: CircularProgressIndicator(),):ListView.builder(
            itemCount: doc.last["Settings"].length,
            itemBuilder: (context,i){
                return getSettings(doc.last["Settings"][i]);
            },
          );
        }
      ),
    
    );
  }



Widget getSettings(String settings){
  switch(settings){
    case "Display":{
      return  Container(
                
                  child: Column(
                    children: <Widget>[
                      ListTile(
                                onTap: (){
                                   SettingsPlugin.display();
                                }, 
                                  trailing: Icon(Icons.arrow_forward_ios,color: Colors.black,),       
                                leading: Icon(Icons.mobile_screen_share,color: Colors.black,) ,
                                title:Text("Display",style: TextStyle(color: Colors.black),) ,
                                   ),
                       Container(
                         height: 1,
                         color: Colors.black.withOpacity(0.1),
                       )            
                    ],
                  ),
              
                );
                

    }

    case "Sound":{
      return Container(
                
                  child: Column(
                    children: <Widget>[
                      ListTile(
                                onTap: (){
                                   SettingsPlugin.sound();
                                },    
                                  trailing: Icon(Icons.arrow_forward_ios,color: Colors.black,),    
                                leading: Icon(Icons.music_note,color: Colors.black,) ,
                                title:Text("Sound",style: TextStyle(color: Colors.black),) ,
                                   ),
                       Container(
                         height: 1,
                         color: Colors.black.withOpacity(0.1),
                       )            
                    ],
                  ),
                );
                
    }
    case "Date_Time":{
      return  
                Container(
                
                  child: Column(
                    children: <Widget>[
                      ListTile(
                                onTap: (){
                                   SettingsPlugin.date_time();
                                },      
                                trailing: Icon(Icons.arrow_forward_ios,color: Colors.black,), 
                                leading: Icon(Icons.access_time,color: Colors.black,) ,
                                title:Text("Date & Time",style: TextStyle(color: Colors.black),) ,
                                   ),
                       Container(
                         height: 1,
                         color: Colors.black.withOpacity(0.1),
                       )            
                    ],
                  ),
                );
    }
    case "Wifi":{

      return Container(
                
                  child: Column(
                    children: <Widget>[
                      ListTile(
                                onTap: (){
                                   SettingsPlugin.wifi();
                                },      
                                trailing: Icon(Icons.arrow_forward_ios,color: Colors.black,), 
                                leading: Icon(Icons.wifi,color: Colors.black,) ,
                                title:Text("wifi",style: TextStyle(color: Colors.black),) ,
                                   ),
                       Container(
                         height: 1,
                         color: Colors.black.withOpacity(0.1),
                       )            
                    ],
                  ),
                );
         


    }

    case "Bluetooth" :{

      return Container(
                
                  child: Column(
                    children: <Widget>[
                      ListTile(
                                onTap: (){
                                   SettingsPlugin.wifi();
                                },      
                                trailing: Icon(Icons.arrow_forward_ios,color: Colors.black,), 
                                leading: Icon(Icons.bluetooth,color: Colors.black,) ,
                                title:Text("Bluetooth",style: TextStyle(color: Colors.black),) ,
                                   ),
                       Container(
                         height: 1,
                         color: Colors.black.withOpacity(0.1),
                       )            
                    ],
                  ),
                );



    }


  }
 
               
}




}