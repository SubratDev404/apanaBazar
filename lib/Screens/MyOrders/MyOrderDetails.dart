import 'dart:convert';
import 'dart:io';
import 'package:apanabazar/Drawer.dart';
import 'package:apanabazar/Screens/MyOrders/MyOrdersModified.dart';
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


class MyOrdersDetails extends StatelessWidget {
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
      home: MyOrdersDetailsScreen(),
    );
  }
}

class MyOrdersDetailsScreen extends StatefulWidget {
  

  @override
  _MyOrdersDetailsScreenState createState() => _MyOrdersDetailsScreenState();
}

class _MyOrdersDetailsScreenState extends State<MyOrdersDetailsScreen> {

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  List showMyOrdersListDetails = [];
  bool isLoading = true;

  fetchMyOrdersListDetails() async {
    
   // var url = "https://randomuser.me/api/?results=50";
    var showMyOrdersListDetails_url= "https://api.apanabazar.com/api/order_details/"+MyOrdersModified.orderno.toString();
    var response = await http.post(
      Uri.parse(showMyOrdersListDetails_url),
      headers: <String, String>{
          // 'Accept': 'application/json',
          //'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer '+WelcomeScreen.userToken
      },
      body: {
        // "token": WelcomeScreen.userToken.toString(),
        // "userid": WelcomeScreen.userUserid.toString()
      }
    );
    // print(response.body);
    if(response.statusCode == 200){
      var items = json.decode(response.body);
      
      print('my orders Details body');
      print(items);
      
      setState(() {
        showMyOrdersListDetails = items;
        isLoading = false;
      });
      
      if(showMyOrdersListDetails.length==0){

        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

      }

    }else{
      showMyOrdersListDetails = [];
      isLoading = false;
    }
  }

  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //BackButtonInterceptor.add(myInterceptor);
    this.fetchMyOrdersListDetails();
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


  String orderstatus,message;
  String currentStatus;

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: themColor,
        elevation: 0.0,
        title: Center(child: Text('My Orders Details',style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontWeight: FontWeight.w800,fontSize: 20),),),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
          onPressed: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>ItemList()));
            Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>MyOrdersModified()));
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
              padding: EdgeInsets.only(top: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                  color: Colors.white,
                ),

                child: isLoading

                //? new Center( child: new CircularProgressIndicator(),) :
                  
               
                ? shimmerEffect() :


                Padding(
                  padding: EdgeInsets.only(top: 10,bottom: 2),
                  child: ListView.builder(
                    itemCount: showMyOrdersListDetails.length,
                    itemBuilder: (context,index){


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
                              padding: EdgeInsets.only(top: 0),
                              child: Container(
                                height: MediaQuery.of(context).size.height/6,
                                child: Card(
                                  shadowColor: Colors.black38,
                                  shape:RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0)
                                  ),
                                  elevation: 2,
                                  margin:EdgeInsets.only(left: 5,right: 5) ,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5,top: 0,right: 5),
                                    child: Column(
                                      children:[
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                      
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.grey,
                                              ),
                                              
                                              width: MediaQuery.of(context).size.width/6,
                                              height: MediaQuery.of(context).size.height/8,
                                              child: Padding(
                                                padding: EdgeInsets.only(right: 5,left: 5),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(15.0),
                                                      
                                                  child: Image.network(showMyOrdersListDetails[index]['itemimage']),
                                                  // child: Image.asset("assets/images/cart_icon.png",color: themColor,
                                                  //   height: 80,
                                                  //   width: 60,
                                                  //   // fit: BoxFit.cover,
                                                  //   // alignment: Alignment.centerLeft,
                                                  // )
                                                ),
                                              ),
                                            ),
                                      
                                            
                                            Padding(
                                              padding: EdgeInsets.only(top: 0,left: 5),
                                              child:Container(
                                                width: MediaQuery.of(context).size.width/1.6,
                                                
                                                height: 100,
                                                color: Colors.white,
                                                child: Column(
                                                  
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                      
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [

                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [

                                                            Flexible(
                                                              child: Text(showMyOrdersListDetails[index]['itemname'].toString(),maxLines: 1,style: TextStyle(color:Colors.black,fontSize: 16.0,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
                                                            )
                                                            
                                                          ],
                                                        ),

                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            
                                                            Row(
                                                              children: [
                                                                Text("₹"+showMyOrdersListDetails[index]['mrp'].toString(),overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(decorationColor: Colors.black,decorationStyle: TextDecorationStyle.solid,decoration:TextDecoration.lineThrough,color:Colors.black26,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                                SizedBox(width: 5,),
                                                                Text("₹"+showMyOrdersListDetails[index]['saleprice'].toString(),overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.black87,fontSize: 18.0,fontWeight: FontWeight.w700,fontFamily: "Roboto")),
                                                              ],
                                                            ),

                                                            Row(
                                                              children: [

                                                                showMyOrdersListDetails[index]['discount'].toString() == "0" || showMyOrdersListDetails[index]['discount'].toString() == "00" ? 

                                                                Container():

                                                                Align(
                                                                  alignment: Alignment.bottomRight,
                                                                  child: Container(
                                                                    width: 40,
                                                                    height: 40,
                                                                    decoration: BoxDecoration(
                                                                      image: DecorationImage(
                                                                        image: AssetImage("assets/images/discount_sticker.png",), fit: BoxFit.fitHeight,
                                                                      )
                                                                    ),
                                                                    child: Align(
                                                                      alignment: Alignment.center,
                                                                      child: Padding(
                                                                        padding: EdgeInsets.only(top: 8),
                                                                        child: Column(
                                                                          children: [

                                                                            Flexible(
                                                                              child: Text(showMyOrdersListDetails[index]['discount'].toString()+"%",style: TextStyle(color:Colors.white,fontSize: 8.0,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
                                                                            ),
                                                                            
                                                                            Flexible(
                                                                              child: Text("OFF",style: TextStyle(color:Colors.white,fontSize: 6.0,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
                                                                            ),
                                                                      
                                                                          ],
                                                                          
                                                                        )
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),

                                                              ],
                                                            )
                                                            

                                                            
                                                          ],
                                                        ),

                                                      
                                                        
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                           // Text("Total Items Ordered: ",overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.black45,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "Roboto")),
                                                            Text(showMyOrdersListDetails[index]['noofitems'].toString()+" Nos",overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.black54,fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                          ],
                                                        ),
                                                        

                                                        

                                                       
                                                     
                                                        // Row(
                                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        //   children: [
                                                        //     Text("Discount: ",overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.blueGrey,fontSize: 17.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                        //     Text(showMyOrdersListDetails[index]['discount'].toString()+"%",overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.blueGrey,fontSize: 17.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                        //   ],
                                                        // ),

                                                      ],
                                                    ),
                                      
                                                  ]
                                                )    
                                              )
                                            ),
                                            
                                          ],
                                        ),
                  
                                      
                                            
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

                                   
                                    

                                  ]  
                                ),

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