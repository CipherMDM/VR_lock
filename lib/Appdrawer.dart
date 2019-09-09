import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:getinfo/settings.dart';

class AppDraw extends StatefulWidget {

  String fg;

  AppDraw(this.fg);


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
     apps = await DeviceApps.getInstalledApplications(includeAppIcons: true,onlyAppsWithLaunchIntent: true,includeSystemApps: true);
    
     if(mounted)
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
                      var  route = MaterialPageRoute(builder: (context)=>Settings(widget.fg));
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
              return apps.isEmpty?Center(child:CircularProgressIndicator()):
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
                            onTap: (){DeviceApps.openApp(apps[i].packageName);},
                            child: Center(
                              child:Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 55,
                                    child:  Image.memory(apps[i].icon),
                                  ),
                                  Center(child: Text(apps[i].appName.toString().split(" ")[0].split("_")[0]))
                                  
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
      ),
    );
  }
}