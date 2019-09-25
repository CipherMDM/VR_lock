import 'dart:io';

import 'package:flutter/material.dart';
import 'package:getinfo/AllowApps.dart';
import 'Home.dart';



class Config extends StatefulWidget {
  List current_apps =[];
  List all_apps=[];
  Config(this.current_apps,this.all_apps);
  @override
  _ConfigState createState() => _ConfigState(current_apps);
}

class _ConfigState extends State<Config> {
  bool config = false;
  List apps=[];
  _ConfigState(this.apps);
  @override
  Widget build(BuildContext context) {
    return config?Home(null): Scaffold(
        appBar:  PreferredSize(
          preferredSize: Size.fromHeight(80.0), // here the desired height
          child: AppBar(elevation: 0,backgroundColor: Colors.transparent, 
          
         
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search,color: Colors.black,),onPressed: (){ showSearch(context: context,delegate: searchbar(apps,widget.all_apps));},)
          ]
          
            ,title:  Center(child: Text("Admin Settings",style: TextStyle(color: Colors.black),)),),
        ),
        
        body: ListView(
          padding: EdgeInsets.all(0.8),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Material(
                borderRadius: BorderRadius.circular(20),
                elevation: 5,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top:18.0),
                    child: ListTile(
                        trailing: Icon(Icons.arrow_forward_ios),
                      
                        leading: Icon(Icons.settings),
                        title: Text("Allowed Settings"),
                        subtitle: Text("only allowed Settings will display to the user"),
                      ),
                  ),
                  
                  height: 100,
                  decoration: BoxDecoration(
                  
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ),
            ),
             Padding(
              padding: const EdgeInsets.all(18.0),
              child: Material(
                borderRadius: BorderRadius.circular(20),
                elevation: 5,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top:18.0),
                    child: ListTile(
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: (){
                        var route = MaterialPageRoute(builder:(context)=> Appconfig(widget.current_apps,widget.all_apps));
                        Navigator.push(context, route);
                      },
                      leading: Icon(Icons.apps),
                      title: Text("Allowed Apps"),
                      subtitle: Text("only allowed apps will display\nto the user"),
                    ),
                  ),
                  
                  height: 100,
                  decoration: BoxDecoration(
                  
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ),
            ),
             Padding(
              padding: const EdgeInsets.all(18.0),
              child: Material(
                borderRadius: BorderRadius.circular(20),
                elevation: 5,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top:18.0),
                    child: ListTile(
                      trailing: Icon(Icons.arrow_forward_ios),
                    
                      leading: Icon(Icons.wifi),
                      title: Text("Default Settings"),
                      subtitle: Text("Wifi , Bluetooth , camera ,\nInternet"),
                    ),
                  ),
                  
                  height: 100,
                  decoration: BoxDecoration(
                  
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ),
            ),
             Padding(
              padding: const EdgeInsets.all(18.0),
              child: Material(
                borderRadius: BorderRadius.circular(20),
                elevation: 5,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top:18.0),
                    child: ListTile(
                      trailing: Icon(Icons.arrow_forward_ios),
                    
                      leading: Icon(Icons.storage),
                      title: Text("Permissions"),
                      subtitle: Text("Allow every permission\nlisted"),
                    ),
                  ),
                  
                  height: 100,
                  decoration: BoxDecoration(
                  
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ),
            ),
             Padding(
              padding: const EdgeInsets.all(18.0),
              child: Material(
                borderRadius: BorderRadius.circular(20),
                elevation: 5,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top:18.0),
                    child: ListTile(
                      trailing: Icon(Icons.arrow_forward_ios,color: Colors.white,),
                      onTap: (){exit(0);},
                      leading: Icon(Icons.warning,color: Colors.white,),
                      title: Text("Kiosk Settings",style: TextStyle(color: Colors.white),),
                     
                    ),
                  ),
                  
                  height: 100,
                  decoration: BoxDecoration(
                  
                    color: Colors.redAccent[200],
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ),
            )
          ],
        )
    );
  }
}

class searchbar extends SearchDelegate{
  List apps =[];
  List all_apps=[];
  searchbar(this.apps,this.all_apps);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear_all),onPressed: (){
        query="";
      },)
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions

    List<items> item = [
        items("Allowed Settings","only allowed Settings will display to the user"),
         items("Allowed Apps","only allowed apps will display\nto the user"),
        items("Default Settings","Wifi , Bluetooth , camera ,\nInternet"),
         items("Permissions","Allow every permission\nlisted")
    ];

    if(!query.isEmpty){
      item = item.where((text)=>text.name.toLowerCase().startsWith(query.toLowerCase()) || 
                            text.name.toLowerCase().contains(query.toLowerCase()) ||
                            text.discription.toLowerCase().contains(query.toLowerCase())
                            ).toList();
    }
  
    return ListView.builder(
      itemCount: item.length,
      itemBuilder: (context,i){
        return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Material(
                borderRadius: BorderRadius.circular(20),
                elevation: 5,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top:18.0),
                    child: ListTile(
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: (){
                        switch(item[i].name){
                            case "Allowed Apps":{
                              var route = MaterialPageRoute(builder:(context)=> Appconfig(apps,all_apps));
                              Navigator.push(context, route);

                            }
                        }
                      },
                    
                      leading: Icon(Icons.storage),
                      title: Text(item[i].name),
                      subtitle: Text(item[i].discription),
                    ),
                  ),
                  
                  height: 100,
                  decoration: BoxDecoration(
                  
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ),
            );
      },
    );
  }

}

class items{
  String name;
  String discription;
  items(this.name,this.discription);
}