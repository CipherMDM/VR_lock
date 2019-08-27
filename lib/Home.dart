// alert(){
//      showDialog(
//       context: context,
//       builder: (_) {
//         return new SimpleDialog(
//           title: Text("Select Network"),
//           children:[Container(
//             height: 300,
//             width: 300,
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: wifi.length,
//               itemBuilder: (_,i){
//                   return ListTile(
//                     title: Text(wifi[i].ssid.toString()),
//                     onTap: (){
//                       Navigator.of(context).pop();
//                       showDialog(context: context,builder:(_){
//                         TextEditingController cont = new TextEditingController();
//                         return AlertDialog(
//                           title: Text("Enter Password"),
//                           actions: <Widget>[
//                             GestureDetector(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(18.0),
//                                 child: Center(
                                  
//                                   child: Text("ok",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 20))),
//                               ),
//                               onTap: (){
//                                 Wifi.connection(wifi[i].ssid, cont.text);
//                                 print("object");
//                                 Navigator.of(context).pop();

//                               },
//                             )
//                           ],
//                           content: Container(
//                             height: 45,
//                             child: TextField(
//                                controller: cont,
//                                 decoration: InputDecoration(
//                                   contentPadding: EdgeInsets.all(8),
//                                   border: OutlineInputBorder(
                                    
//                                     borderRadius: BorderRadius.circular(20)
//                                   )
//                                 ),
//                             ),
//                           ),
//                         );
//                       });
                    
//                     },
//                     leading: Icon(Icons.wifi),
//                     );
//               },
//             ),
//           )
//           ]
//         );
//       },
//     );
//    }









