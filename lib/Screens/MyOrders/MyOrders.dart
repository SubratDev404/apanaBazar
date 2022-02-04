import 'dart:convert';
import 'dart:io';
import 'package:apanabazar/CurvedBottomNavigationBar/CurvedButtonNavigationBar.dart';
import 'package:apanabazar/Screens/Cart/Cart.dart';
import 'package:apanabazar/Screens/LoginRegistration/Login.dart';
import 'package:apanabazar/Screens/MyOrders/MyOrdersCancel.dart';
import 'package:apanabazar/Screens/NoItemsPage/NoItemMyOrders/NoItemsInMyOrders.dart';
import 'package:apanabazar/Screens/Profile/Profile.dart';
import 'package:apanabazar/Screens/Search/Search.dart';
import 'package:apanabazar/Screens/WelComeScreen/WelcomeScreen.dart';
import 'package:apanabazar/Screens/WishList/WishList.dart';
import 'package:apanabazar/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class MyOrders extends StatelessWidget {
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
      home: MyOrdersScreen(),
    );
  }
}

class MyOrdersScreen extends StatefulWidget {
  

  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  List showMyOrdersList = [];
  bool isLoading = false;

  fetchMyOrdersList() async {
    setState(() {
      isLoading = true;
    });
   // var url = "https://randomuser.me/api/?results=50";
    var showMyOrdersList_url= "https://apanabazar.com/Gateway/order_list";
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
      var res= json.decode(response.body)['status'];
      // print('my orders body');
      // print(items);
      
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

  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //BackButtonInterceptor.add(myInterceptor);
    this.fetchMyOrdersList();
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
      backgroundColor: themColor,
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

      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Hi ! "+WelcomeScreen.userName  ?? "user"),
              accountEmail: Text(WelcomeScreen.userEmail ?? "user@gmail.com"),
              // currentAccountPicture:
              // Image.network('https://hammad-tariq.com/img/profile.png'),
              
              decoration: BoxDecoration(color: themColor),
            ),
            ListTile(
              focusColor: themColor,
              leading: Icon(Icons.home),
              title: Text('Home',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
              onTap: () {

                Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CurvedBottomNavigationBar()));
               
              },
            ),
            ListTile(
              focusColor: themColor,
              leading: Icon(Icons.person),
              title: Text('Profile',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=> Profile()));
               // Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Profile()));
               // Navigator.pop(context);
              },
            ),

            ListTile(
              focusColor: themColor,
              leading: Icon(Icons.search),
              title: Text('Search',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
              onTap: () {
                Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Search()));
              //  Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Profile()));
               // Navigator.pop(context);
              },
            ),
            Divider(
              height: 2.0,
            ),

            ExpansionTile(
              leading: Icon(Icons.category),
              title: Text(
                "My Categories",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold
                ),
              ),

              children: [
                ListTile(
                  focusColor: themColor,
                  leading: Icon(Icons.shopping_bag_rounded,color: themColor,size: 30,),
                  title: Text('My Orders',style: TextStyle(color: themColor,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 18)),
                  onTap: () {
                    Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> MyOrders()));
                  //  Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Profile()));
                  // Navigator.pop(context);
                  },
                ),

                ListTile(
                  focusColor: themColor,
                  leading: Icon(Icons.favorite),
                  title: Text('My WishList',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
                  onTap: (){
                    Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>WishList()));
                  },
                ),

                ListTile(
                  focusColor: themColor,
                  leading: Icon(Icons.shopping_bag),
                  title: Text('My Cart',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
                  onTap: (){
                    Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Cart()));
                  },
                ),
              ],
            ),
           
            Divider(
              height: 2.0,
            ),
            ListTile(
              focusColor: themColor,
              leading: Icon(Icons.logout),
              title: Text('Sign Out',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
              onTap: ()async{
                SharedPreferences loginPrefs = await SharedPreferences.getInstance();
                loginPrefs.clear();
                Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Login()));
              },
            ),

            ListTile(
              focusColor: themColor,
              leading: Icon(Icons.exit_to_app),
              title: Text('Exit',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
              onTap: ()=> exit(0),
            ),
            Divider(
              height: 2.0,
            ),
      
            // ListTile(
            //   focusColor: themColor,
            //   title: Text('Help and Settings',style: TextStyle(color: Colors.blueGrey),),
            // ),

            ExpansionTile(
              leading: Icon(Icons.help),
              title: Text(
                "Help and Settings",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold
                ),
              ),

              children: [

                ListTile(
                  focusColor: themColor,
                  leading: Icon(Icons.person),
                  title: Text('Customer Service',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
                  onTap: (){},
                ),

                ListTile(
                  focusColor: themColor,
                  leading: Icon(Icons.help),
                  title: Text('Guide',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
                  onTap: (){},
                ),

                ListTile(
                  focusColor: themColor,
                  leading: Icon(Icons.live_help),
                  title: Text('Help',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
                  onTap: (){},
                ),
              ]
            )    
          ]  
        ),
      ),



      body: Stack(
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
            padding: EdgeInsets.only(top: 40),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                color: Colors.white,
              ),

              child: Padding(
                padding: EdgeInsets.only(top: 20,bottom: 2),
                child: ListView.builder(
                  itemCount: showMyOrdersList.length,
                  itemBuilder: (context,index){

                    currentStatus=orderstatus=showMyOrdersList[index]['status'];

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
                    orderstatus=showMyOrdersList[index]['iscanceled'];
                    if(orderstatus=="0"){
                      message="Active";
                     // print("item active");
                    }
                    if(orderstatus=="1"){
                      message="Canceled";
                     // print("item canceled");
                    }

                    ////////// current status//////////////
                    

                    // if(currentStatus=="1"){
                    //   message="Active";
                    //   print("item active");
                    // }
                    // if(currentStatus=="2"){
                    //   message="Canceled";
                    //   print("item canceled");
                    // }
                    // if(currentStatus=="3"){
                    //   message="Canceled";
                    //   print("item canceled");
                    // }

                    return ExpansionTile(
                      title: 
              
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Container(
                              height: 150,
                              child: Card(
                                shape:RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)
                                ),
                                elevation: 8,
                                margin:EdgeInsets.only(left: 5,right: 5) ,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10,top: 10,right: 10),
                                  child: Column(
                                    children:[
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                    
                                          Container(
                                            width: MediaQuery.of(context).size.width/6,
                                            height: 60,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(15.0),
                                              child: Image.asset("assets/images/item_icon.png",
                                                height: 60,
                                                // fit: BoxFit.cover,
                                                // alignment: Alignment.centerLeft,
                                              )
                                            ),
                                          ),
                                    
                                          
                                          Padding(
                                            padding: EdgeInsets.only(top: 10,left: 5),
                                            child:Container(
                                              //width: MediaQuery.of(context).size.width/1.4,
                                              
                                              height: 80,
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
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text("Date: ",style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                          Text(showMyOrdersList[index]['od'].toString(),style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
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
                                                      // SizedBox(
                                                      //   height: 10,
                                                      // ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text("price: ",style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                          Text(showMyOrdersList[index]['price'].toString()+"/-",style: TextStyle(color:Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                        ],
                                                      ),

                                                      SizedBox(
                                                        height: 5,
                                                      ),

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

                                                      SizedBox(
                                                        height: 2,
                                                      ),
                                                      

                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          orderstatus=="0" ? 
                                                          new Container(
                                                            width:200 ,
                                                            height: 30,
                                                            color: Colors.green,
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              
                                                              
                                                              children: [
                                                                currentStatus=="1" ? new Container(
                                                                  width:200 ,
                                                                  height: 30,
                                                                  color: Colors.green,
                                                                  child:Center(
                                                                    child:Text("Order Placed",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                                                                  )
                                                                ):currentStatus=="2" ? new Container(
                                                                  width:200 ,
                                                                  height: 30,
                                                                  color: Colors.green,
                                                                  child:Center(
                                                                    child:Text("Order Shipped",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                                                                  )
                                                                ): new Container(
                                                                  width:200 ,
                                                                  height: 30,
                                                                  color: Colors.green,
                                                                  child:Center(
                                                                    child:Text("Order Delivered",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                                                                  )
                                                                )

                                                              ],
                                                            )
                                                                  
                                                                
                                                                  // child:Center(
                                                                  //   child:Text("Active",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                                                                  // )
                                                          )
                                                                
                                                          : new Container(
                                                            width:200 ,
                                                            height: 30,
                                                            color: Colors.orange,
                                                            child:Center(
                                                              child:Text("Cancelled",style:TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 18),),
                                                            )
                                                          )
                                                                
                                                        ],
                                                      ),

                                                    



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
                
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                
                                          ElevatedButton.icon(
                                            icon: Icon(Icons.cancel),
                                            label: Text('Cancel', style: TextStyle(color: Colors.white),),
                                            onPressed: orderstatus=="0" ? () async{
                                              
                                              MyOrders.orderno=showMyOrdersList[index]['reference_number'].toString();

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
                
                                        ],
                                      )
                                          
                                    ]  
                                  ),
                                ) 
                              ),
                            ),
                          ),
                        ]  
                      ),

                      children:[
                        ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: showMyOrdersList[index]['details']['delivery'].length,
                          itemBuilder: (context,index1){

                           
                            return ListTile(
                              title: 
                              Padding(
                                padding: EdgeInsets.only(left: 10,right: 40),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(color: Colors.black54, spreadRadius: 3),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(5),bottomLeft: Radius.circular(5),bottomRight: Radius.circular(5)),
                                          color: Colors.grey
                                        ),
                                        child: Column(
                                          children: [

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(left: 15,top: 2),
                                                      child: Text(showMyOrdersList[index]['details']['delivery'][index1]['itemname'].toString(),style: TextStyle(color:Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                                                    )
                                                  ),
                                                ),
                                              ],
                                            ),
                                      
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left: 15),
                                                  child: Text("Brand: ",style: TextStyle(color:Colors.white,fontSize: 17.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                                                ),
                                                Expanded(
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Text(showMyOrdersList[index]['details']['delivery'][index1]['brndname'].toString(),style: TextStyle(color:Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left: 15),
                                                  child: Text("Total Nos: ",style: TextStyle(color:Colors.white,fontSize: 17.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                                                ),
                                                Text(showMyOrdersList[index]['details']['delivery'][index1]['quantity'].toString()+"Nos",style: TextStyle(color:Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left: 15),
                                                  child: Text("Mobile: ",style: TextStyle(color:Colors.white,fontSize: 17.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                                                ),
                                                Text(showMyOrdersList[index]['details']['delivery'][index1]['vmobile'].toString(),style: TextStyle(color:Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                              ],
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width/1,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 15,bottom: 5),
                                                    child: Text("Address: ",style: TextStyle(color:Colors.white,fontSize: 17.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                                                  ),
                                                  Expanded(
                                                    child: SingleChildScrollView(
                                                      scrollDirection: Axis.horizontal,
                                                      child: Text(showMyOrdersList[index]['details']['delivery'][index1]['vaddress'].toString(),style: TextStyle(color:Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                          ],
                                        ),
                                      )
                                
                                      
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                         
                        )

                      ]

                    );
                  }
                ),
              ),
              
            ),
          )
        ],
        
      ),

      
    );
  }
}