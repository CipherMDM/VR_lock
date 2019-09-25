import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'added_apps.dart';

class InstalledApps extends StatefulWidget {
  @override
  _InstalledAppsState createState() => _InstalledAppsState(apps);
  List current_apps = [];
  List apps=[];
  InstalledApps(this.apps,this.current_apps);
}

class _InstalledAppsState extends State<InstalledApps> {

  List apps=[];
  _InstalledAppsState(this.apps);
  @override
  void initState() {
    
    super.initState();
    
  }

   Stream getApps() async*{
     apps = await DeviceApps.getInstalledApplications(includeAppIcons: true,onlyAppsWithLaunchIntent: true,includeSystemApps: false);
     if(mounted)
     setState(() {
       
     });
     
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 0),
        child: Container(
          

          child: StreamBuilder(
            stream:apps.isEmpty? getApps():null,
            builder: (context, snapshot) {
              return apps.isEmpty? Center(child:CircularProgressIndicator(),):
              GridView.count(
                
                               // Create a grid with 2 columns. If you change the scrollDirection to
                               // horizontal, this produces 2 rows.
                               
                               crossAxisCount: 4,
                               // Generate 100 widgets that display their index in the List.
                               children: List.generate(apps.length, (i) {
                                 return Container(
                        height: 105,
                        
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: GestureDetector(
                            onTap: (){
                             
                              },
                            child: Center(
                              child:Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  icon_(apps[i],widget.current_apps),
                                  
                                  Center(
                                    child: Text(apps[i].appName.toString().split(" ")[0].split("_")[0])
                                    )
                                  
                                ],
                              ) 
                            ),
                          )
                          
                          
                          //  ListTile(
                          //    onTap:()=> DeviceApps.openApp(apps[i].packageName),
                          //    leading: Image.memory(apps[i].icon) ,
                          //    title:Text(apps[i].appName) ,
                          // ),
                        ),
                        
                      );
                               }),
                             );
              
            }
          ),
            
        ),
      );
      }
}


