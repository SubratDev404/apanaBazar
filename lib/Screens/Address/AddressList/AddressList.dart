import 'dart:convert';
import 'dart:io';
import 'package:apanabazar/Drawer.dart';
import 'package:apanabazar/Screens/Address/CreateAddress/CreateAddress.dart';
import 'package:apanabazar/Screens/Address/UpdateAddress/UpdateAddress.dart';
import 'package:apanabazar/Screens/Cart/Cart.dart';
import 'package:apanabazar/Screens/CheckOut/CheckOutModified.dart';
import 'package:apanabazar/Screens/NoItemsPage/NoPreviousAddress/NoPreviousAddress.dart';
import 'package:apanabazar/Screens/WelComeScreen/WelcomeScreen.dart';
import 'package:apanabazar/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddressList extends StatelessWidget {
  
  static int addressListItemId;
  static String fullAddress,landMarkAddress,pincode;
  @override
  Widget build(BuildContext context) {

    /// screen Orientation start///////////
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    /// screen Orientation end///////////
    
    
    
    return MaterialApp(

      builder: (context, child) {  // Preventing app text font size from Any device font size configuration
        return MediaQuery(
          child: child,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },

      debugShowCheckedModeBanner: false,
      home: AddressListScreen(),
    );
  }
}

class AddressListScreen extends StatefulWidget {
  

  @override
  _AddressListScreenState createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {

 
  
  List showAddressList = [];
  bool isLoading = false;

  fetchAddressList() async {
    setState(() {
      isLoading = true;
    });
   // var url = "https://randomuser.me/api/?results=50";
    var showAddressList_url= "https://api.apanabazar.com/api/deliveryaddress";
    var response = await http.get(
      Uri.parse(showAddressList_url),
      headers: <String, String>{
          // 'Accept': 'application/json',
          //'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer '+WelcomeScreen.userToken
      },
    );
    // print(response.body);
    if(response.statusCode == 200){
      var items = json.decode(response.body)['data'];
      var res= json.decode(response.body)['response'];
      // print('Address body');
      // print(items);
      
      setState(() {
        showAddressList = items;
        isLoading = false;
      });
      
      if(showAddressList.length==0){

        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoPreviousAddress()));

      }

    }else{
      showAddressList = [];
      isLoading = false;
    }
  }
  

  Future hideBar() async =>
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

 
  @override
  void initState() {

   //hideBar();
    // TODO: implement initState
    super.initState();
    this.fetchAddressList();
    //BackButtonInterceptor.add(myInterceptor);
  }

  // @override
  // void dispose() {
  //   BackButtonInterceptor.remove(myInterceptor);
  //   super.dispose();
  // }

  // bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
  //   Fluttertoast.showToast(
  //     msg: 'Sorry can not back here',
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     timeInSecForIosWeb: 1,
  //     backgroundColor: themColor
  //   );
  //   //print("BACK BUTTON!"); // Do some stuff.
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {

    
    return Scaffold(
      backgroundColor: themColor,
      appBar: AppBar(
        backgroundColor: themColor,
        elevation: 0.0,
        title: Center(child: Text('Choose Address',style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontWeight: FontWeight.w800,fontSize: 20),),),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
          onPressed: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>ItemList()));
            Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Cart()));
          },
        ),
      ),

      endDrawer: Container(
        width: MediaQuery.of(context).size.width*0.7,
        child: MyDrawer()
      ),

      body: NotificationListener<OverscrollIndicatorNotification>(  // disallow scrolling shadow
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return null;
        },
      
      
        child:Stack(
          children: [

            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: themColor,

              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.add_circle,color: themColor,),
                    label: Text('Add New Address', style: TextStyle(color: themColor,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16),),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.white,
                      shadowColor: Colors.white60,
                      shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                      elevation: 10,
                    ),
                    onPressed: (){
                      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CreateAddress()));
                    }
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 50),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                  color: Colors.white
                ),

                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: ListView.builder(
                    itemCount: showAddressList.length,
                    itemBuilder: (context,index){
                      return ListTile(
                        title: 
                  
                          Stack(
                            children:[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top:4,bottom: 10),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height/5.5,
                                  child: Card(
                                    shape:RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                    elevation: 8,
                                    margin:EdgeInsets.only(left: 0,right: 0) ,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10,top: 10,right: 10),
                                      child: Column(
                                        children:[
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                        
                                              Container(
                                                width: MediaQuery.of(context).size.width/9,
                                                height: 35,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(15.0),
                                                  child: Image.asset("assets/images/location_icon.png",
                                                    height: 30,
                                                    //  fit: BoxFit.cover,
                                                    // alignment: Alignment.centerLeft,
                                                  )
                                                ),
                                              ),
                                        
                                              
                                              Padding(
                                                padding: EdgeInsets.only(top: 0,left: 0,bottom: 10),
                                                child:Container(
                                                  //width: MediaQuery.of(context).size.width/1.4,
                                                  width: MediaQuery.of(context).size.width/2,
                                                  height: 60,
                                                  color: Colors.white,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      // Row(
                                                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      //   children: [

                                                      //     // Checkbox(
                                                      //     //   value: this.value,
                                                      //     //   onChanged: (bool value) {
                                                      //     //     setState(() {
                                                      //     //       this.value = value;
                                                      //     //     });
                                                      //     //   },
                                                      //     // ), 

                                                      //     // ListTile(
                                                      //     //   title: Text(""),
                                                      //     //   leading: RadioListTile(
                                                      //     //     groupValue: radioItem,
                                                      //     //     title: Text('Radio Button Item 1'),
                                                      //     //     value: 'Item 1',
                                                      //     //     onChanged: (val) {
                                                      //     //       setState(() {
                                                      //     //         radioItem = val;
                                                      //     //       });
                                                      //     //     },
                                                      //     //   ),
                                                      //     // ),

                                                      //                 //                 RadioListTile(
                                                      //                 //                   title: Text("${data.name}"),
                                                      //                 //                   groupValue: id,
                                                      //                 //                   value: data.index,
                                                      //                 //                   onChanged: (val) {
                                                      //                 //                     setState(() {
                                                      //                 //                       radioItem = data.name ;
                                                      //                 //                       id = data.index;
                                                      //                 //                     });
                                                      //                 //                   },
                                        
        
                                                      //     // ListTile(
                                                      //     //   title: Text("Male"),
                                                      //     //   leading: Radio(
                                                      //     //     value: 1,
                                                      //     //     groupValue: val,
                                                      //     //     onChanged: (value) {
                                                      //     //       setState(() {
                                                      //     //         val = value;
                                                      //     //       });
                                                      //     //     },
                                                      //     //     activeColor: Colors.green,
                                                      //     //   ),
                                                      //     // ),
                                                      //     //     Text(
                                                      //     //       'Select Address',
                                                      //     //       style: new TextStyle(fontSize: 17.0),
                                                      //     //     ),
                                                      //     //      RadioListTile(
                                                      //     //      groupValue: radioItem,
                                                      //     //      title: Text('Radio Button Item 1'),
                                                      //     //     value: 'Item 1',
                                                      //     //      onChanged: (val) {
                                                      //     //        setState(() {
                                                      //     //         radioItem = val;
                                                      //     //        });
                                                      //     //     },
                                                      //     //  ),
                                                      //     //     Radio(
                                                      //     //       value: 1,
                                                      //     //       groupValue: id,
                                                      //     //       onChanged: (val) {
                                                      //     //         setState(() {
                                                      //     //           radioItem = 'One';
                                                      //     //            id = 1;
                                                      //     //         });
                                                      //     //       },
                                                      //     //     ),
                                                              
                                                      //     //   ],
                                                      //     // ),
                                                          
                                                        

                                                          
                                                      //     // Row(
                                                      //     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      //     //   children: [
                                                            
      
                                                      //   ],
                                                      // ),

                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text("Full Address: ",style: TextStyle(color:Colors.black54,fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                          Expanded(
                                                            child: SingleChildScrollView(
                                                              scrollDirection: Axis.horizontal,
                                                              child: Text(showAddressList[index]['fullAddress'].toString(),style: TextStyle(color:Colors.black,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text("LandMark Address: ",style: TextStyle(color:Colors.black54,fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                          Expanded(
                                                            child: SingleChildScrollView(
                                                              scrollDirection: Axis.horizontal,
                                                              child: Text(showAddressList[index]['additionalInfo'].toString(),style: TextStyle(color:Colors.black,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                                                            
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text("Pincode: ",style: TextStyle(color:Colors.black54,fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                          Text(showAddressList[index]['pincode'].toString(),style: TextStyle(color:Colors.black,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                        ],
                                                      )
                                        
                                                    ]
                                                  )    
                                                )
                                              ),
                                            ],
                                          ),
                                            
                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.end,
                                          //   children: [
                                            
                                          //     // ElevatedButton.icon(
                                          //     //   icon: Icon(Icons.keyboard_arrow_right_outlined,size: 50,),
                                          //     //   label: Text('Select', style: TextStyle(color: Colors.white),),
                                          //     //   onPressed: () async{
                                          //     //     // print("id");
                                          //     //     // WishList.itemId=showWishList[index]['itemid'].toString();
                                          //     //     // print(ItemList.itemlistId);
                                          //     //     // var response=await addToCartProcess();
                                          //     //     // bool res=response.response;
                                          //     //     // if(res==true){
                                          //     //     //   //scaffoldKey.currentState.showSnackBar(SnackBar(content:Text(" Added to Cart Successfully"))); 
                                          //     //     // }
                                          //     //   }
                                          //     // ),

                                          //   ]
                                          // ) ,
                                          //////////////////////////////////////

                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.end,
                                          //   children: [
                                            
                                          //     ButtonTheme(
                                          //       minWidth: MediaQuery.of(context).size.width/2,
                                          //       height: 35.0,
                                          //       child: Padding(
                                          //         padding: EdgeInsets.only(right: 20),
                                          //         child: RaisedButton(
                                          //           onPressed: () async{
                                          //             AddressList.listItemId= showAddressList[index]['id'] as int;
                                          //             // SharedPreferences prefsAddressListItemId= await SharedPreferences.getInstance();
                                          //             // prefsAddressListItemId.setInt("AddressId", AddressList.listItemId);
                                          //             // //prefsAddressListItemId.setInt("AddressId", 25);
                                          //             // print("Prefs checking ??????????????????????"+prefsAddressListItemId.setInt("AddressId", AddressList.listItemId).toString());
                                          //             Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CheckOut()));
                                          //             // fetchSelectedAddress();
                                          //             // var full=selectedAddressList[index]['fulladdress'].toString();
                                          //             // print("..............."+full);
                                                    

                                          //           },
                                          //           child: Row(
                                          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //             children: [
                                          //               Text("Select",style: TextStyle(color:Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                          //               SizedBox(
                                          //                 width: 100,
                                          //               ),
                                          //               Icon(Icons.arrow_forward,color: Colors.white,)
                                          //             ],
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     )

                                          //   ]
                                          // ) 
                                        
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [

                                              SizedBox(
                                                height: 30,
                                                child: ElevatedButton.icon(
                                                 // child: Icon(Icons.arrow_forward,color: Colors.white,),
                                                  icon: Icon(Icons.location_city,color: Colors.white,),
                                                  label: Text('Update Address', style: TextStyle(color: Colors.white),),
                                                  style: ElevatedButton.styleFrom(
                                                    primary: Colors.black54,
                                                    onPrimary: Colors.white,
                                                    shadowColor: Colors.white60,
                                                    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                    elevation: 10,
                                                  ),
                                                  onPressed: () async{

                                                    setState(() {

                                                      AddressList.addressListItemId= showAddressList[index]['id'] as int;
                                                      AddressList.fullAddress=showAddressList[index]['fullAddress'].toString();
                                                      AddressList.landMarkAddress=showAddressList[index]['additionalInfo'].toString();
                                                      AddressList.pincode=showAddressList[index]['pincode'].toString();
                                
                                                    });
                                                    

                                                    // SharedPreferences prefsAddressListItemId= await SharedPreferences.getInstance();
                                                    // prefsAddressListItemId.setInt("AddressId", AddressList.listItemId);
                                                    // //prefsAddressListItemId.setInt("AddressId", 25);
                                                    // print("Prefs checking ??????????????????????"+prefsAddressListItemId.setInt("AddressId", AddressList.listItemId).toString());
                                                    Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>UpdateAddress()));
                                                    // fetchSelectedAddress();
                                                    // var full=selectedAddressList[index]['fulladdress'].toString();
                                                    // print("..............."+full);
                                                  },
                                                        
                                                ),
                                              ),


                                              SizedBox(
                                                height: 30,
                                                child: ElevatedButton(
                                                  child: Icon(Icons.arrow_forward,color: Colors.white,),
                                                  // icon: Icon(Icons.keyboard_arrow_right_rounded,color: Colors.white,),
                                                  // label: Text('', style: TextStyle(color: Colors.white),),
                                                  style: ElevatedButton.styleFrom(
                                                    primary: Colors.black54,
                                                    onPrimary: Colors.white,
                                                    shadowColor: Colors.white60,
                                                    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                    elevation: 10,
                                                  ),
                                                  onPressed: () async{
                                                    AddressList.addressListItemId= showAddressList[index]['id'] as int;
                                                    // SharedPreferences prefsAddressListItemId= await SharedPreferences.getInstance();
                                                    // prefsAddressListItemId.setInt("AddressId", AddressList.listItemId);
                                                    // //prefsAddressListItemId.setInt("AddressId", 25);
                                                    // print("Prefs checking ??????????????????????"+prefsAddressListItemId.setInt("AddressId", AddressList.listItemId).toString());
                                                    Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CheckOutModified()));
                                                    // fetchSelectedAddress();
                                                    // var full=selectedAddressList[index]['fulladdress'].toString();
                                                    // print("..............."+full);
                                                  },
                                                        
                                                ),
                                              ),

                                              
                                              
                                              
                                            ]
                                          ),
                                          
                                        ]  
                                      ),
                                    ) 
                                  ),
                                ),
                              ),
                            ],
                          ),

                        );
                      }
                    ),
                ),
              ),

              
          
                
            )
          ],
        ),
      )  
    );
  }
}