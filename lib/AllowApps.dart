import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:getinfo/InstalledApps.dart';
import 'package:getinfo/Systemapps.dart';

class Appconfig extends StatefulWidget {
  @override
  _AppconfigState createState() => _AppconfigState();
}

class _AppconfigState extends State<Appconfig>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  List apps=[];

  Stream getApps() async*{
     apps = await DeviceApps.getInstalledApplications(includeAppIcons: true,onlyAppsWithLaunchIntent: true,includeSystemApps: false);
     if(mounted){
     setState(() {
       
     });
     }
     
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this,initialIndex: 0,length: 2);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        bottom: TabBar(controller: _controller,indicatorColor: Colors.white,
           tabs: <Widget>[
             Tab(child: Text("Installed Apps"),),
             Tab(child: Text("Systemp Apps"),)
           ],
        ),
      ),
      body: StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return TabBarView(
            controller: _controller,
            children: <Widget>[
               InstalledApps(snapshot.data),
               SystemApps(),
             
            ],
          );
        }
      ),
    );
  }
}



