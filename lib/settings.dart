import 'package:flutter/material.dart';
import 'package:connect_wifi/connect_wifi.dart';


class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.only(right:55.0),
            child: Center(child: Text("Settings",style: TextStyle(color: Colors.black),),),
          ),
        ),
      ),
      body: ListView(
          children: [
            Container(
            
              child: Column(
                children: <Widget>[
                  ListTile(
                            onTap: (){
                               ConnectWifi.openWifi();
                            },       
                            leading: Icon(Icons.wifi,color: Colors.black,) ,
                            title:Text("Wifi",style: TextStyle(color: Colors.black),) ,
                               ),
                   Container(
                     height: 1,
                     color: Colors.black.withOpacity(0.1),
                   )            
                ],
              ),
            ),
                   ]
        ),
    
    );
  }
}