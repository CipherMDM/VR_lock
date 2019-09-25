import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:getinfo/database/policy.dart';
import 'package:getinfo/settings.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class AppDraw extends StatefulWidget {

  String fg;
  List apps = [];
  List all_apps = [];

  AppDraw(this.fg,this.apps,this.all_apps);

  
 


  @override
  _AppDrawState createState() => _AppDrawState();
}

class _AppDrawState extends State<AppDraw> {


 
  @override
  void initState() {
    super.initState();
    
  }

   Stream getApps() async*{
   
     var store = StoreRef.main();
     Database db = await AppDatabase.instance.database;

  

     store.record("Apps").get(db).then((data)async{
             widget.apps = await DeviceApps.getInstalledApplications(includeAppIcons: true,onlyAppsWithLaunchIntent: true,includeSystemApps: true);
             widget.apps = widget.apps.where((app)=>data.contains(app.packageName)&&app.packageName!="com.example.getinfo").toList();

     });

    
     if(mounted)
     setState(() {
       
     });
     
  }





  
  
  




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor:  Colors.white,
        
       appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(bottom:10.0,top: 10),
              child: TextField(decoration: InputDecoration(
                fillColor: Colors.grey,
                contentPadding: EdgeInsets.all(8),
                hintText: "Search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40)
                )
              ),),
            ),
            elevation: 0.0,

            leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.black,),onPressed: (){Navigator.of(context).pop();},),
            
            backgroundColor: Colors.white,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings,color: Colors.black,),
                onPressed: (){
                      var  route = MaterialPageRoute(builder: (context)=>Settings(widget.fg,widget.apps,widget.all_apps));
                      Navigator.of(context).push(route);
                },
              )
            ],
          ),
      body: Padding(
        padding: const EdgeInsets.only(right: 0),
        child: Container(
          

          child: StreamBuilder<Object>(
            stream:widget.apps.isEmpty? getApps():null,
            builder: (context, snapshot) {
              return Container(
                child: widget.apps.isEmpty?Center(child:CircularProgressIndicator()):
                GridView.count(
                       
                  
                        // Create a grid with 2 columns. If you change the scrollDirection to
                        // horizontal, this produces 2 rows.
                        
                        crossAxisCount: 4,
                        // Generate 100 widgets that display their index in the List.
                        children: List.generate(widget.apps.length, (i) {
                          return Container(
                          height: 105,
                          
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: GestureDetector(
                              onTap: (){DeviceApps.openApp(widget.apps[i].packageName);},
                              child: Center(
                                child:Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 55,
                                      child:  Image.memory(widget.apps[i].icon),
                                    ),
                                    Center(child: Text(widget.apps[i].appName.toString().split(" ")[0].split("_")[0]))
                                    
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
                               ),
              );
              
            }
          ),
            
        ),
      ),
    );
  }
}