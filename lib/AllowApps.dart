import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:getinfo/InstalledApps.dart';
import 'package:getinfo/Systemapps.dart';
import 'added_apps.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'database/policy.dart';



class Appconfig extends StatefulWidget {

  List current_apps = [];
  List all_apps=[];
  Appconfig(this.current_apps,this.all_apps);
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

  List new_apps = [];


 Future db(List apps) async {
        var store = StoreRef.main();
        Database db = await AppDatabase.instance.database;
        store.record("Apps").update(db, apps);
       


}
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save),onPressed: (){
                 print(icon_.new_apps);
                 db(icon_.new_apps);
          },)
        ],
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
               InstalledApps(widget.all_apps,widget.current_apps),
               SystemApps(),
             
            ],
          );
        }
      ),
    );
  }
}



