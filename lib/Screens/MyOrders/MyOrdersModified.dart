import 'dart:convert';
import 'dart:io';

import 'package:apanabazar/CurvedBottomNavigationBar/CurvedButtonNavigationBar.dart';
import 'package:apanabazar/Drawer.dart';
import 'package:apanabazar/Model/OwnDeliveryStatusModel.dart';
import 'package:apanabazar/Screens/MyOrders/MyOrderDetails.dart';
import 'package:apanabazar/Screens/MyOrders/MyOrdersCancel.dart';
import 'package:apanabazar/Screens/NoItemsPage/NoItemMyOrders/NoItemsInMyOrders.dart';
import 'package:apanabazar/Screens/WelComeScreen/WelcomeScreen.dart';
import 'package:apanabazar/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';


class MyOrdersModified extends StatelessWidget {
  static String orderno;
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
      home: MyOrdersModifiedScreen(),
    );
  }
}

class MyOrdersModifiedScreen extends StatefulWidget {
  

  @override
  _MyOrdersModifiedScreenState createState() => _MyOrdersModifiedScreenState();
}

class _MyOrdersModifiedScreenState extends State<MyOrdersModifiedScreen> {

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  List showMyOrdersList = [];
  bool isLoading = true;

  fetchMyOrdersList() async {
   
   // var url = "https://randomuser.me/api/?results=50";
    var showMyOrdersList_url= "https://apanabazar.com/Gateway/order_list";
    //var showMyOrdersList_url= "http://61.12.81.38/apanabazar.com/Gateway/order_list";
    var response = await http.post(
      Uri.parse(showMyOrdersList_url),
      // headers: <String, String>{
      //     // 'Accept': 'application/json',
      //     //'Content-type': 'application/json',
      //   'Accept': 'application/json',
      //   'Authorization': 'Bearer '+Login.token
      // },
      body: {
        "token": WelcomeScreen.userToken.toString(),
        "userid": WelcomeScreen.userUserid.toString()
      }
    );
    // print(response.body);
    if(response.statusCode == 200){
      var items = json.decode(response.body)['data'];
      var deliveryType = json.decode(response.body)['data'][0]['islocalpickup'];
      var res= json.decode(response.body)['status'];
        print('my orders body');
        print("////////////////////// "+deliveryType.toString());
      
      setState(() {
        showMyOrdersList = items;
        isLoading = false;
      });
      
      if(showMyOrdersList.length==0){

        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

      }

    }else{
      showMyOrdersList = [];
      isLoading = false;
    }
  }

  Future<OwnDeliveryStatusModel> fetchOwnDeliveryStatus() async {
   
   // var url = "https://randomuser.me/api/?results=50";
    var OwnDeliveryStatus_url= "https://delivery.apanabazar.comy/Api/updateOrderStatus";
    //var OwnDeliveryStatus_url= "http://61.12.81.38/ab_delivery/Api/updateOrderStatus";
    var response = await http.post(
      Uri.parse(OwnDeliveryStatus_url),
      // headers: <String, String>{
      //     // 'Accept': 'application/json',
      //     //'Content-type': 'application/json',
      //   'Accept': 'application/json',
      //   'Authorization': 'Bearer '+Login.token
      // },
      body: {
        "orderno": orderno.toString(),
        "userid": WelcomeScreen.userUserid.toString()
      }
    );
    // print(response.body);
    if(response.statusCode == 200){
     
      var res= json.decode(response.body);
        print('my orders body');
        print(res.toString());
        
        fetchMyOrdersList();
      
      setState(() {
        
        isLoading = false;
      });
      

      return OwnDeliveryStatusModel.fromJson(json.decode(response.body));
      

    }else{
      showMyOrdersList = [];
      isLoading = false;
    }
  }

  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //BackButtonInterceptor.add(myInterceptor);
    this.fetchMyOrdersList();
  }

 


  String cancelStatus,message;
  String currentStatus,localPickUp,itemReady,orderno;

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: themColor,
        elevation: 0.0,
        title: Center(child: Text('My Orders',style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontWeight: FontWeight.w800,fontSize: 20),),),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
          onPressed: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>ItemList()));
            Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CurvedBottomNavigationBar()));
          },
        ),
      ),

      endDrawer: Container(
        width: MediaQuery.of(context).size.width*0.7,
        child: MyDrawer()
      ),



      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return null;
        },
      
        child: Stack(
          children: [

            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: themColor,
              // child: Align(
              //   alignment: Alignment.topRight,
              //   child:InkWell(
              //     child: Column(
              //       children: [
              //         Image.asset("assets/images/cart_icon.png",color: Colors.white,width: 80,height: 40,),
              //         Text("Go To Cart",style: TextStyle(color: Colors.white),),
              //       ],
              //     ),
              //     onTap: (){
              //       Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Cart()));
              //     },
              //   )
              //   // child: RaisedButton(
              //   //   color: Colors.white,
              //   //   child: Text("Go to Cart", style: TextStyle(color: themColor),),
              //   //   onPressed: (){
              //   //     Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Cart()));
              //   //   }
              //   // ),
              // ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                  color: Colors.white,
                ),

                child: isLoading

               // ? new Center( child: new CircularProgressIndicator(),):
                
                ? shimmerEffect() :

                Padding(
                  padding: EdgeInsets.only(top: 5,bottom: 2),
                  child: ListView.builder(
                    itemCount: showMyOrdersList.length,
                    itemBuilder: (context,index){

                      currentStatus=showMyOrdersList[index]['status'].toString();
                      orderno=showMyOrdersList[index]['reference_number'].toString();
                      localPickUp=showMyOrdersList[index]['islocalpickup'].toString();
                      itemReady=showMyOrdersList[index]['details']['delivery'][0]['itemready'].toString();
                      print("item ready................."+itemReady.toString());


                      if(currentStatus=="1"){
                      // message="Active";
                      // print("item placed");
                      }
                      if(currentStatus=="2"){
                      // message="Canceled";
                      //  print("item shipped");
                      }
                      if(currentStatus=="3"){
                      // message="Canceled";
                      // print("item delivered");
                      }


                      ////////// order status /////////////
                      cancelStatus=showMyOrdersList[index]['iscanceled'];
                      if(cancelStatus=="0"){
                        message="Active";
                       print("item active");
                      }
                      if(cancelStatus=="1"){
                        message="Canceled";
                       print("item canceled");
                      }

                      ////////// current status//////////////
                      

                      // if(cancelStatus=="1"){
                      //   message="Active";
                      //   print("item active");
                      // }
                      // if(cancelStatus=="2"){
                      //   message="Canceled";
                      //   print("item canceled");
                      // }
                      // if(cancelStatus=="3"){
                      //   message="Canceled";
                      //   print("item canceled");
                      // }

                      return ListTile(
                        title: 
                
                        Stack(
                          children: [
                            // Container(
                            //   width: MediaQuery.of(context).size.width,
                            //   height: 80,
                            //   decoration: BoxDecoration(
                            //     color: Colors.black54,
                            //     borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                            //   ),
                            // ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Container(
                                
                                height: MediaQuery.of(context).size.height*0.3,
                                child: Card(
                                  shadowColor: Colors.black54,
                                  shape:RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0)
                                  ),
                                  elevation: 8,
                                  margin:EdgeInsets.only(left: 5,right: 5) ,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5,top: 10,right: 5),
                                    child: Column(
                                      children:[
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                      
                                            Column(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: Colors.black12,
                                                  ),
                                                  
                                                  width: MediaQuery.of(context).size.width/6,
                                                  height: MediaQuery.of(context).size.height/9.5,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(top:5,right: 5,left: 5),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(15.0),
                                                      child: Image.asset("assets/images/cart_icon.png",color: themColor,
                                                        height: MediaQuery.of(context).size.height*0.2,
                                                        width: 60,
                                                        // fit: BoxFit.cover,
                                                        // alignment: Alignment.centerLeft,
                                                      )
                                                    ),
                                                  ),
                                                ),

                                               

                                                Padding(
                                                  padding: const EdgeInsets.only(top: 2,bottom: 2),
                                                  child: Container(
                                                    
                                                    width: MediaQuery.of(context).size.width*0.075,
                                                    height: MediaQuery.of(context).size.height*0.1,
                                                    color: Colors.white,
                                                    child: Column(
                                                      children: [

                                                        RotatedBox(
                                                          quarterTurns: -1,
                                                          child:cancelStatus=="0" ? 
                                                          new Container(
                                                            width: MediaQuery.of(context).size.width*0.2,
                                                            //color: Colors.blue,
                                                            //width:MediaQuery.of(context).size.width/5 ,
                                                            //height: 20,
                                                            
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              
                                                              
                                                              
                                                              children: [
                                                                currentStatus=="1" ? 
                                                                Center(child: FittedBox(child: new Text("Placed",overflow: TextOverflow.ellipsis,maxLines: 1,style:TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 15),)))
                                                                  
                                                                :currentStatus=="2" ?
                                                                localPickUp=="1" ?

                                                                Center(child: FittedBox(child: new Text("Pickup Ready",overflow: TextOverflow.ellipsis,maxLines: 1,style:TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 15),)))

                                                                : Center(child: FittedBox(child: new Text("Shipped",overflow: TextOverflow.ellipsis,maxLines: 1,style:TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 15),)))
                                                                
                                                                :
                                                                localPickUp=="1" ?
                                                                Center(child: FittedBox(child: new Text("Pickup complete",overflow: TextOverflow.ellipsis,maxLines: 1,style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),)))
                                                                : Center(child: FittedBox(child: new Text("Delivered",overflow: TextOverflow.ellipsis,maxLines: 1,style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),)))
                                                              ],
                                                            )
                                                                  
                                                                
                                                                  // child:Center(
                                                                  //   child:Text("Active",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                                                                  // )
                                                          )
                                                                        
                                                          : Center(
                                                            child: FittedBox(child: new Text("Cancelled",overflow: TextOverflow.ellipsis,maxLines: 1,style:TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 15),))
                                                          ),
                                                        ),


                                                      ]  
                                                    ),
                                                    
                                                  ),
                                                )
                                              ],
                                            ),
                                      
                                            
                                            Padding(
                                              padding: EdgeInsets.only(top: 0,left: 5),
                                              child:Container(
                                                width: MediaQuery.of(context).size.width/1.6,
                                                height: MediaQuery.of(context).size.height*0.25,  // card height
                                                color: Colors.white,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                      
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            FittedBox(child: Text(showMyOrdersList[index]['reference_number'].toString(),maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color:Colors.black,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))),
                                                           
                                                            // Row(
                                                            //   crossAxisAlignment: CrossAxisAlignment.end,
                                                            //   mainAxisAlignment: MainAxisAlignment.end,
                                                            //   children: [
                                                            //     cancelStatus=="0" ? 
                                                            //     new Container(
                                                            //       width:MediaQuery.of(context).size.width/5 ,
                                                            //       height: 20,
                                                                  
                                                            //       child: Column(
                                                            //         mainAxisAlignment: MainAxisAlignment.center,
                                                                    
                                                                    
                                                            //         children: [
                                                            //           currentStatus=="1" ? 
                                                            //           new Text("Placed",overflow: TextOverflow.ellipsis,maxLines: 1,style:TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 15),)
                                                                        
                                                            //           :currentStatus=="2" ?
                                                            //           new Text("Shipped",overflow: TextOverflow.ellipsis,maxLines: 1,style:TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 15),)
                                                                      
                                                            //           : new Text("Delivered",overflow: TextOverflow.ellipsis,maxLines: 1,style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
                                                            //         ],
                                                            //       )
                                                                        
                                                                      
                                                            //             // child:Center(
                                                            //             //   child:Text("Active",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                                                            //             // )
                                                            //     )
                                                                      
                                                            //     : new Text("Cancelled",overflow: TextOverflow.ellipsis,maxLines: 1,style:TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 15),),
                                                            //   ],
                                                            // ),

                                                          ],
                                                        ),

                                                        SizedBox( height: 5,),

                                                        Row(
                                                          
                                                          children: [
                                                           
                                                            FittedBox(child: Text("₹"+showMyOrdersList[index]['price'].toString(),maxLines: 1,style: TextStyle(color:Colors.black45,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))),
                                                            SizedBox(width: 10,),
                                                            showMyOrdersList[index]['transactiontype'].toString() =="1" ?
                                                            FittedBox(child: Text("Cash",overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.black87,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "Roboto"))) :
                                                            FittedBox(child: Text("Online",overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.black87,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "Roboto"))),
                                                          ],
                                                        ),

                                                        SizedBox( height: 5,),
                                                        
                                                      

                                                        // SingleChildScrollView(
                                                        //   scrollDirection: Axis.horizontal,
                                                        //   child: Padding(
                                                        //     padding: EdgeInsets.only(left: 0,top: 5),
                                                        //     child: Text(showMyOrdersList[index]['details']['delivery'][0]['itemname'].toString(), maxLines: 1,style: TextStyle(color:Colors.black54,fontSize: 15.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                        //   )
                                                        // ),

                                                        // Container(
                                                        //   width: MediaQuery.of(context).size.width/2,
                                                        //   child: Row(
                                                        //     //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        //     children: [
                                                        //       Text("Brand: ",style: TextStyle(color:Colors.black45,fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: "RaleWay")),
                                                        //       Container(
                                                        //         child: Flexible(
                                                        //           child: Text(showMyOrdersList[index]['details']['delivery'][0]['brndname'].toString(),maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color:Colors.black54,fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                        //         ),
                                                        //       )
                                                        //       // SingleChildScrollView(
                                                        //       //   scrollDirection: Axis.horizontal,
                                                        //       //   child: Padding(
                                                        //       //     padding: EdgeInsets.only(left: 1,top: 5),
                                                        //       //     child: Text(showMyOrdersList[index]['details']['delivery'][0]['brndname'].toString(),overflow: TextOverflow.visible,style: TextStyle(color:Colors.black26,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                        //       //   )
                                                        //       // ),
                                                        //     ]
                                                        //   ),
                                                        // ),
                                                        Container(
                                                          child: Row(
                                                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [

                                                              Row(
                                                                children: [
                                                                  Icon(Icons.location_city,color: Colors.black45,size: 20,),
                                                                  FittedBox(child: Text("Sold By: ",style: TextStyle(color:Colors.black54,fontSize: 12.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay")))
                                                                ],
                                                              ),
                                                             
                                                               
                                                              FittedBox(child: Text(showMyOrdersList[index]['details']['delivery'][0]['vname'].toString(),style: TextStyle(color:Colors.black54,fontSize: 14.0,fontWeight: FontWeight.w800,fontFamily: "Roboto"))),
                                                                
                                                            
                                                              //Text(showMyOrdersList[index]['details']['delivery'][0]['vname'].toString(),maxLines: 1,style: TextStyle(color:Colors.black38,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                              // Container(
                                                              //   width: MediaQuery.of(context).size.width,
                                                              //   child: SingleChildScrollView(
                                                              //     scrollDirection: Axis.horizontal,
                                                              //      child: Padding(
                                                              //        padding: EdgeInsets.only(left: 0,top: 0),
                                                              //       child: Text(showMyOrdersList[index]['details']['delivery'][0]['vname'].toString(),style: TextStyle(color:Colors.black38,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                              //     )
                                                              //   ),
                                                              // ),
                                                            ]
                                                          ),
                                                        ),

                                                        SizedBox( height: 5,),

                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Image.asset("assets/images/calendar.png",width: 30,height: 20,color: Colors.black45,),
                                                           // Text("Placed On: ",style: TextStyle(color:Colors.black38,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                            FittedBox(child: Text(showMyOrdersList[index]['od'].toString(),style: TextStyle(color:Colors.black87,fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))),
                                                            // InkWell(
                                                            //   child: Image.asset('assets/images/delete_icon.png',color: themColor,height: 30,),
                                                            //   onTap: () {
                                                            //     print("ok");
                                                            //     // WishList.wishid=showWishList[index]['wishid'].toString();
                                                            //     // print(WishList.wishid);
                                                            //     // deleteWishListItemProcess();
                                                            //     //fetchWishList();
                                                            //   },
                                                            // )
                                                          ],
                                                        ),

                                                        SizedBox( height: 5,),

                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                          
                                                            localPickUp=="0" ?
                                                            FittedBox(
                                                              child: Row(
                                                                children: [
                                                                  Icon(Icons.person,color: Colors.black87 ,),
                                                                  Text("Delivery",style: TextStyle(color:Colors.black54,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                                                                ],
                                                                
                                                              )
                                                            ) :
                                                            FittedBox(
                                                              child: Row(
                                                                children:[
                                                                Icon(Icons.person,color: Colors.green,),
                                                                Text("Own Pickup",style: TextStyle(color:Colors.green,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                                                                ]
                                                              )
                                                            ),
                                                            
                                                          ],
                                                        ),

                                                        SizedBox( height: 5,),


                                                        currentStatus=="3" ? 
                                                        Text("Order Completed") :
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                          
                                                            itemReady=="1" && localPickUp=="1" ?

                                                            SizedBox(
                                                              height: 30,
                                                              child: ElevatedButton.icon(
                                                                icon: Icon(Icons.arrow_forward),
                                                                label: FittedBox(child: Text('Ready To Pickup', style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold,fontFamily: "Roboto"))),
                                                                style: ElevatedButton.styleFrom(
                                                                  primary: Colors.green,
                                                                  onPrimary: Colors.white,
                                                                  shadowColor: Colors.white60,
                                                                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                  elevation: 10,
                                                                ),
                                                                //label: Text('Cancel', style: TextStyle(color: Colors.white),),
                                                                onPressed: cancelStatus=="0" ? () async{
                                                                  
                                                                  var response=await fetchOwnDeliveryStatus();
                                                                  bool res=response.status;
                                                                  var message=response.message;
                                                                  if(res==true){
                                                                    
                                                                    fetchMyOrdersList();
                                                                   
                                                                    scaffoldKey.currentState.showSnackBar(SnackBar(content:Text(message.toString()))); 
                                                                  }
                                                                  if(res==false){
                                                                    
                                                                    fetchMyOrdersList();
                                                                   
                                                                    scaffoldKey.currentState.showSnackBar(SnackBar(content:Text(message.toString()))); 
                                                                  }
                                                                }: null
                                                              ),
                                                            ) :
                                                             
                                                            Text("")
                                                            
                                                          ],
                                                        ),

                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 30),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [

                                                              SizedBox(
                                                                height: 30,
                                                                child: ElevatedButton(
                                                                  child: Icon(Icons.cancel),
                                                                  style: ElevatedButton.styleFrom(
                                                                    primary: themColor,
                                                                    onPrimary: Colors.white,
                                                                    shadowColor: Colors.white60,
                                                                    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                    elevation: 10,
                                                                  ),
                                                                  //label: Text('Cancel', style: TextStyle(color: Colors.white),),
                                                                  onPressed:  cancelStatus=="0"  &&  currentStatus=="1" ? () async{
                                                                    
                                                                    MyOrdersModified.orderno=showMyOrdersList[index]['reference_number'].toString();
                                                                  

                                                                    //print(MyOrders.orderno);
                                                                    Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>MyOrderCancel()));
                                                                    // WishList.itemId=showWishList[index]['itemid'].toString();
                                                                    // print(ItemList.itemlistId);
                                                                    // var response=await addToCartProcess();
                                                                  //  bool res=response.response;
                                                                    // if(res==true){
                                                                    //   scaffoldKey.currentState.showSnackBar(SnackBar(content:Text(" Added to Cart Successfully"))); 
                                                                    // }
                                                                  }: null
                                                                ),
                                                              ),

                                                              SizedBox(
                                                                height: 30,
                                                                child: ElevatedButton(
                                                                  child: Icon(Icons.arrow_forward),
                                                                  style: ElevatedButton.styleFrom(
                                                                      primary: Colors.black54,
                                                                      onPrimary: Colors.white,
                                                                      shadowColor: Colors.white60,
                                                                      shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                      elevation: 10,
                                                                  ),
                                                                  //label: Text('Cancel', style: TextStyle(color: Colors.white),),
                                                                  onPressed: (){

                                                                    MyOrdersModified.orderno=showMyOrdersList[index]['reference_number'].toString();
                                                                    print("order No");
                                                                    print( MyOrdersModified.orderno);
                                                                    Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> MyOrdersDetails()));
                                                                  },
                                                                ),
                                                              ),
                                
                                                            ],
                                                          ),
                                                        )
                                                      
                                                        


                                                        

                                                        

                                                        // SizedBox(
                                                        // height: 5,
                                                        // ),

                                                        // Container(
                                                        //   height: 1,
                                                        //   width: MediaQuery.of(context).size.width/1.5,
                                                        //   color: Colors.black38,
                                                        // ),

                                                        // SizedBox(
                                                        // height: 10,
                                                        // ),

                                                       

                                                        // Order placed status start

                                                        // Padding(
                                                        //   padding: const EdgeInsets.only(top: 5,right: 5),
                                                        //   child: Row(
                                                        //     crossAxisAlignment: CrossAxisAlignment.end,
                                                        //     mainAxisAlignment: MainAxisAlignment.end,
                                                        //     children: [
                                                        //       cancelStatus=="0" ? 
                                                        //       new Container(
                                                        //         //width:MediaQuery.of(context).size.width/5 ,
                                                        //         //height: 20,
                                                                
                                                        //         child: Column(
                                                        //           mainAxisAlignment: MainAxisAlignment.center,
                                                                  
                                                                  
                                                        //           children: [
                                                        //             currentStatus=="1" ? 
                                                        //             new Text("Placed",overflow: TextOverflow.ellipsis,maxLines: 1,style:TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 15),)
                                                                      
                                                        //             :currentStatus=="2" ?
                                                        //             new Text("Shipped",overflow: TextOverflow.ellipsis,maxLines: 1,style:TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 15),)
                                                                    
                                                        //             : new Text("Delivered",overflow: TextOverflow.ellipsis,maxLines: 1,style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
                                                        //           ],
                                                        //         )
                                                                      
                                                                    
                                                        //               // child:Center(
                                                        //               //   child:Text("Active",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                                                        //               // )
                                                        //       )
                                                                    
                                                        //       : new Text("Cancelled",overflow: TextOverflow.ellipsis,maxLines: 1,style:TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 15),),
                                                        //     ],
                                                        //   ),
                                                        // ),

                                                        // Order placed status end

                                                        // SizedBox(
                                                        //   height: 5,
                                                        // ),

                                                        // Row(
                                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        //   children: [
                                                        //     Text("price: ",style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                        //     Text(showMyOrdersList[index]['status'].toString()+"/-",style: TextStyle(color:Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                        //   ],
                                                        // ),

                                                        // Row(
                                                        
                                                        //  // crossAxisAlignment: CrossAxisAlignment.start,
                                                        //   mainAxisAlignment: MainAxisAlignment.start,
                                                        //   children: [
                                                        //     currentStatus=="1" ? new Container(
                                                        //       width:200 ,
                                                        //       height: 30,
                                                        //      color: Colors.green,
                                                        //       child:Center(
                                                        //         child:Text("Order Placed",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                                                        //       )
                                                        //     ):currentStatus=="2" ? new Container(
                                                        //       width:200 ,
                                                        //       height: 30,
                                                        //      color: Colors.green,
                                                        //       child:Center(
                                                        //         child:Text("Order Shipped",style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),),
                                                        //       )
                                                        //     ): new Container(
                                                        //       width:200 ,
                                                        //       height: 30,
                                                        //       color: Colors.orange,
                                                        //       child:Center(
                                                        //         child:Text("Order Delivered",style:TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 16),),
                                                        //       )
                                                        //     )
                                                            
                                                        //   ],
                                                        // ),

                                                        
                                                        

                                                        // Row(
                                                        //   crossAxisAlignment: CrossAxisAlignment.start,
                                                        //   mainAxisAlignment: MainAxisAlignment.start,
                                                        //   children: [
                                                        //     cancelStatus=="0" ? 
                                                        //     new Container(
                                                        //       width:200 ,
                                                        //       height: 30,
                                                        //       color: Colors.green,
                                                        //       child: Column(
                                                        //         mainAxisAlignment: MainAxisAlignment.start,
                                                                
                                                                
                                                        //         children: [
                                                        //           currentStatus=="1" ? new Container(
                                                        //             width:200 ,
                                                        //             height: 30,
                                                        //             color: Colors.green,
                                                        //             child:Center(
                                                        //               child:Text("Order Placed",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                                                        //             )
                                                        //           ):currentStatus=="2" ? new Container(
                                                        //             width:200 ,
                                                        //             height: 30,
                                                        //             color: Colors.green,
                                                        //             child:Center(
                                                        //               child:Text("Order Shipped",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                                                        //             )
                                                        //           ): new Container(
                                                        //             width:200 ,
                                                        //             height: 30,
                                                        //             color: Colors.green,
                                                        //             child:Center(
                                                        //               child:Text("Order Delivered",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                                                        //             )
                                                        //           )

                                                        //         ],
                                                        //       )
                                                                    
                                                                  
                                                        //             // child:Center(
                                                        //             //   child:Text("Active",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                                                        //             // )
                                                        //     )
                                                                  
                                                        //     : new Container(
                                                        //       width:200 ,
                                                        //       height: 30,
                                                        //       color: Colors.orange,
                                                        //       child:Center(
                                                        //         child:Text("Cancelled",style:TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 18),),
                                                        //       )
                                                        //     )
                                                                  
                                                        //   ],
                                                        // ),

                                                      



                                                        // Text("gold milk",style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"),),
                                                        // Text("Quantity : 1",style: TextStyle(color:Colors.grey,fontSize: 16,fontWeight: FontWeight.bold,fontFamily: "Roboto"),),
                                                        // Icon(Icons.favorite,color: Colors.red,)
                                                      ],
                                                    ),
                                      
                                                  ]
                                                )    
                                              )
                                            ),
                                            
                                          ],
                                        ),
                  
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   children: [

                                        //     SizedBox(
                                        //       height: 30,
                                        //       child: ElevatedButton(
                                        //         child: Icon(Icons.cancel),
                                        //         style: ElevatedButton.styleFrom(
                                        //             primary: themColor,
                                        //             onPrimary: Colors.white,
                                        //             shadowColor: Colors.white60,
                                        //             shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                        //             elevation: 10,
                                        //         ),
                                        //         //label: Text('Cancel', style: TextStyle(color: Colors.white),),
                                        //         onPressed: cancelStatus=="0" ? () async{
                                                  
                                        //           MyOrdersModified.orderno=showMyOrdersList[index]['reference_number'].toString();
                                                

                                        //           //print(MyOrders.orderno);
                                        //           Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>MyOrderCancel()));
                                        //           // WishList.itemId=showWishList[index]['itemid'].toString();
                                        //           // print(ItemList.itemlistId);
                                        //           // var response=await addToCartProcess();
                                        //         //  bool res=response.response;
                                        //           // if(res==true){
                                        //           //   scaffoldKey.currentState.showSnackBar(SnackBar(content:Text(" Added to Cart Successfully"))); 
                                        //           // }
                                        //         }: null
                                        //       ),
                                        //     ),

                                        //     SizedBox(
                                        //       height: 30,
                                        //       child: ElevatedButton(
                                        //         child: Icon(Icons.arrow_forward),
                                        //         style: ElevatedButton.styleFrom(
                                        //             primary: Colors.black54,
                                        //             onPrimary: Colors.white,
                                        //             shadowColor: Colors.white60,
                                        //             shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                        //             elevation: 10,
                                        //         ),
                                        //         //label: Text('Cancel', style: TextStyle(color: Colors.white),),
                                        //         onPressed: (){

                                        //           MyOrdersModified.orderno=showMyOrdersList[index]['reference_number'].toString();
                                        //           print("order No");
                                        //           print( MyOrdersModified.orderno);
                                        //           Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> MyOrdersDetails()));
                                        //         },
                                        //       ),
                                        //     ),
                  
                                        //   ],
                                        // )
                                            
                                      ]  
                                    ),
                                  ) 
                                ),
                              ),
                            ),
                          ]  
                        ),

                        // children:[
                        //   ListView.builder(
                        //     shrinkWrap: true,
                        //     physics: ClampingScrollPhysics(),
                        //     itemCount: showMyOrdersList[index]['details']['delivery'].length,
                        //     itemBuilder: (context,index1){

                            
                        //       return ListTile(
                        //         title: 
                        //         Padding(
                        //           padding: EdgeInsets.only(left: 10,right: 40),
                        //           child: Container(
                        //             decoration: BoxDecoration(
                        //               borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                        //               color: Colors.white,
                        //               boxShadow: [
                        //                 BoxShadow(color: Colors.black54, spreadRadius: 3),
                        //               ],
                        //             ),
                        //             child: Column(
                        //               children: [
                        //                 Container(
                        //                   decoration: BoxDecoration(
                        //                     borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(5),bottomLeft: Radius.circular(5),bottomRight: Radius.circular(5)),
                        //                     color: Colors.grey
                        //                   ),
                        //                   child: Column(
                        //                     children: [

                        //                       Row(
                        //                         mainAxisAlignment: MainAxisAlignment.start,
                        //                         children: [
                        //                           Expanded(
                        //                             child: SingleChildScrollView(
                        //                               scrollDirection: Axis.horizontal,
                        //                               child: Padding(
                        //                                 padding: EdgeInsets.only(left: 15,top: 2),
                        //                                 child: Text(showMyOrdersList[index]['details']['delivery'][index1]['itemname'].toString(),style: TextStyle(color:Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                        //                               )
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                                        
                        //                       Row(
                        //                         mainAxisAlignment: MainAxisAlignment.start,
                        //                         children: [
                        //                           Padding(
                        //                             padding: EdgeInsets.only(left: 15),
                        //                             child: Text("Brand: ",style: TextStyle(color:Colors.white,fontSize: 17.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                        //                           ),
                        //                           Expanded(
                        //                             child: SingleChildScrollView(
                        //                               scrollDirection: Axis.horizontal,
                        //                               child: Text(showMyOrdersList[index]['details']['delivery'][index1]['brndname'].toString(),style: TextStyle(color:Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                       Row(
                        //                         mainAxisAlignment: MainAxisAlignment.start,
                        //                         children: [
                        //                           Padding(
                        //                             padding: EdgeInsets.only(left: 15),
                        //                             child: Text("Total Nos: ",style: TextStyle(color:Colors.white,fontSize: 17.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                        //                           ),
                        //                           Text(showMyOrdersList[index]['details']['delivery'][index1]['quantity'].toString()+"Nos",style: TextStyle(color:Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                        //                         ],
                        //                       ),
                        //                       Row(
                        //                         mainAxisAlignment: MainAxisAlignment.start,
                        //                         children: [
                        //                           Padding(
                        //                             padding: EdgeInsets.only(left: 15),
                        //                             child: Text("Mobile: ",style: TextStyle(color:Colors.white,fontSize: 17.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                        //                           ),
                        //                           Text(showMyOrdersList[index]['details']['delivery'][index1]['vmobile'].toString(),style: TextStyle(color:Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                        //                         ],
                        //                       ),
                        //                       Container(
                        //                         width: MediaQuery.of(context).size.width/1,
                        //                         child: Row(
                        //                           mainAxisAlignment: MainAxisAlignment.start,
                        //                           children: [
                        //                             Padding(
                        //                               padding: EdgeInsets.only(left: 15,bottom: 5),
                        //                               child: Text("Address: ",style: TextStyle(color:Colors.white,fontSize: 17.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                        //                             ),
                        //                             Expanded(
                        //                               child: SingleChildScrollView(
                        //                                 scrollDirection: Axis.horizontal,
                        //                                 child: Text(showMyOrdersList[index]['details']['delivery'][index1]['vaddress'].toString(),style: TextStyle(color:Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                        //                               ),
                        //                             ),
                        //                           ],
                        //                         ),
                        //                       ),

                        //                     ],
                        //                   ),
                        //                 )
                                  
                                        
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       );
                        //     }
                          
                        //   )

                        // ]

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

  Widget shimmerEffect(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,

      child: Shimmer.fromColors(
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context,index){
            return ListTile(
              // leading: Icon(Icons.image,size: 50,),
              title: Column(
                children: [ 

                  // Container(
                  //   width: MediaQuery.of(context).size.width,
                  //   // height: MediaQuery.of(context).size.height/9,
                  //   height: 30,
                  //   decoration: BoxDecoration(
                  //     color: Colors.black,
                  //     borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                  //   ),
                  // ),

                  Padding(
                    padding: EdgeInsets.only(top: 10,left: 5,right: 5),

                    child: Container(
                      height: MediaQuery.of(context).size.height/4,
                      width: double.infinity,
                      color: Colors.black12,
                      // alignment: Alignment.bottomCenter,
                        
                      child: Column(
                        children: [

                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 5,top: 20),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.black87,
                                ),
                              ),

                              SizedBox(
                                width: 5,
                              ),

                              Column(
                                children: [

                                  Container(
                                    width: 100,
                                    height: 15,
                                    color: Colors.black87,
                                  ),

                                  SizedBox(
                                    height: 2,
                                  ),

                                  Container(
                                    width: 100,
                                    height: 5,
                                    color: Colors.black87,
                                  ),

                                  SizedBox(
                                    height: 2,
                                  ),

                                  Container(
                                    width: 100,
                                    height: 10,
                                    color: Colors.black87,
                                  ),

                                  SizedBox(
                                    height: 2,
                                  ),

                                  Container(
                                    width: 100,
                                    height: 10,
                                    color: Colors.black87,
                                  ),

                                  SizedBox(
                                    height: 2,
                                  ),

                                  Container(
                                    width: 100,
                                    height: 10,
                                    color: Colors.black87,
                                  ),

                                  SizedBox(
                                    height: 2,
                                  ),

                                  Container(
                                    width: 100,
                                    height: 10,
                                    color: Colors.black87,
                                  ),

                                  SizedBox(
                                    height: 2,
                                  ),

                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      width: 100,
                                      height: 10,
                                      color: Colors.black87,
                                    ),
                                  ),

                                ]  
                              ),

                            ],

                          ),

                          SizedBox(
                            height: 10,
                          ),
                      
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Container(
                                  width: 50,
                                  height: 30,
                                  color: Colors.black87,
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Container(
                                  width: 200,
                                  height: 30,
                                  color: Colors.black87,
                                ),
                              )
                            ],
                          ),
                        ]  
                      ),
                    ),
        
                  ),
                ]  
              )
          
            );
            
          }
        ),
        baseColor: Colors.grey, 
        highlightColor: Colors.white,
      ),
      
    );
  }
}