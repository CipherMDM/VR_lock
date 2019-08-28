import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:getinfo/settings.dart';

class AppDraw extends StatefulWidget {
  @override
  _AppDrawState createState() => _AppDrawState();
}

class _AppDrawState extends State<AppDraw> {


  List apps=[];
  @override
  void initState() {
    
    super.initState();
    
  }

   Stream getApps() async*{
     apps = await DeviceApps.getInstalledApplications(includeAppIcons: true,onlyAppsWithLaunchIntent: true);
     setState(() {
       
     });
     
  }





  
  
  




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,
        
       appBar: AppBar(
            elevation: 0.0,

            leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.black,),onPressed: (){Navigator.of(context).pop();},),
            
            backgroundColor: Colors.white,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings,color: Colors.black,),
                onPressed: (){
                      var  route = MaterialPageRoute(builder: (context)=>Settings());
                      Navigator.of(context).push(route);
                },
              )
            ],
          ),
      body: Padding(
        padding: const EdgeInsets.only(right: 0),
        child: Container(
          

          child: StreamBuilder<Object>(
            stream:apps.isEmpty? getApps():null,
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: apps.length,
                itemBuilder: (context,i){
                 
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 80,
                        
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                             onTap:()=> DeviceApps.openApp(apps[i].packageName),
                             leading: Image.memory(apps[i].icon) ,
                             title:Text(apps[i].appName) ,
                          ),
                        ),
                        
                      ),
                      Container(
                        color: Colors.black.withOpacity(0.1),
                        height: 1,
                      )
                    ],
                  );
                },
              );
            }
          ),
            
        ),
      ),
    );
  }
}