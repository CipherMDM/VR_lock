import 'package:flutter/material.dart';
class icon_ extends StatefulWidget {
  var i;
  List added;
  static List new_apps=[];
 
  
  @override
  _iconState createState() => _iconState();

   icon_(this.i,this.added);
}


class _iconState extends State<icon_> {
  Icon icn =  Icon(Icons.check_box,color: Colors.grey.withOpacity(0.4),);
  bool added = false;

  iscontain(dynamic a,dynamic b){
     for(int i=0;i<a.length;i++){
       if(a[i].packageName==b.packageName){
         return true;
       }
     }
     return false;
  }

  @override
  void initState() {
    print(widget.added);
    print("\n\n\n");
    setState(() {
      
       if(iscontain(widget.added, widget.i)){
            icn = Icon(Icons.check_box,color: Colors.red,);
            added =true;
            icon_.new_apps.add(widget.i.packageName);
          
        }
      
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
                           if(!added){
                             added=true;
                             icn = Icon(Icons.check_box,color: Colors.red,);
                             icon_.new_apps.add(widget.i.packageName);

                           }else{
                             added=false;
                            icn = Icon(Icons.check_box,color: Colors.grey.withOpacity(0.4),);
                            icon_.new_apps.remove(widget.i.packageName);

                           }

                         });

      },
      child:Container(
                   height: 55,
                   child: CircleAvatar(
                     child: Padding(
                       padding: const EdgeInsets.only(top:38.0,left: 45),
                       child:  icn,
                     ),
                     backgroundImage:Image.memory(widget.i.icon).image,radius: 30,backgroundColor: Colors.white,),
                                    ),
    );
  }
}