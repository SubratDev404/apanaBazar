import 'dart:convert';
import 'dart:io';


import 'package:apanabazar/CurvedBottomNavigationBar/CurvedButtonNavigationBar.dart';
import 'package:apanabazar/Model/AddToCartModel.dart';
import 'package:apanabazar/Model/AddToWishListModel.dart';
import 'package:apanabazar/Model/ItemDetailsModel.dart';
import 'package:apanabazar/Screens/Cart/Cart.dart';
import 'package:apanabazar/Screens/Home/Home.dart';
import 'package:apanabazar/Screens/ItemList/ItemList.dart';
import 'package:apanabazar/Screens/LoginRegistration/Login.dart';
import 'package:apanabazar/Screens/MyOrders/MyOrdersModified.dart';
import 'package:apanabazar/Screens/Profile/Profile.dart';
import 'package:apanabazar/Screens/Search/Search.dart';
import 'package:apanabazar/Screens/WelComeScreen/WelcomeScreen.dart';
import 'package:apanabazar/Screens/WishList/WishList.dart';
import 'package:apanabazar/constants/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ItemDetails extends StatelessWidget {
  
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
      home: ItemDetailsScreen(),
    );
  }
}

class ItemDetailsScreen extends StatefulWidget {
  

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  
  String itemName,itemImage,productType,productStatus,itemUnit,itemDiscount,networkImage,
  itemTypeName,itemManufacturer,itemVendorname,itemDescription,itemFetures;
  int itemDetailsId;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  int itemMrp,itemSalePrice;

  List showItemDetailsList = [];
  List imageList=[];
  bool isLoading = false;

  Future<ItemDetailsModel> fetchItemDetails() async {
    setState(() {
      isLoading = true;
    });
   // var url = "https://randomuser.me/api/?results=50";
    var itemDetails_url= "https://api.apanabazar.com/api/inventory/"+Home.itemId.toString();
    var response = await http.get(
      Uri.parse(itemDetails_url),
      headers: <String, String>{
          // 'Accept': 'application/json',
          //'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': WelcomeScreen.userToken.toString()
      },
      // body: {
      //   // "token": WelcomeScreen.userToken.toString(),
      //   // "userid": WelcomeScreen.userUserid.toString()
      // }
    );
    // print(response.body);
    if(response.statusCode == 200){

      var additionalImagess = json.decode(response.body)['data']['additionalImage'];

      print('additionalImagess image');
      print(additionalImagess);
      
      setState(() {
        imageList = additionalImagess;
        isLoading = false;
      });

      print("imageList "+imageList.toString());

      setState(() {
        itemDetailsId= json.decode(response.body)['data']['id'];
        itemName = json.decode(response.body)['data']['itemname'];
        itemImage = json.decode(response.body)['data']['image'];
        itemUnit = json.decode(response.body)['data']['unitname'];
        itemMrp = json.decode(response.body)['data']['mrp'];
        itemDiscount = json.decode(response.body)['data']['discount'];
        itemSalePrice = json.decode(response.body)['data']['saleprice'];
        itemTypeName = json.decode(response.body)['data']['typename'];
        itemManufacturer = json.decode(response.body)['data']['manufacturer'];
        itemVendorname = json.decode(response.body)['data']['vendorname'];
        itemDescription = json.decode(response.body)['data']['description'];
        itemFetures = json.decode(response.body)['data']['fetures'];
        productType=json.decode(response.body)['data']['variantdetails']['variantdetails'][0]['variantname'];
        productStatus=json.decode(response.body)['data']['variantdetails']['variantdetails'][0]['variantvalue'];

        networkImage="https://admin.apanabazar.com/assets/thumbnails/${itemImage}256X256.jpg";
      });
      
       
      print('item Details body');
     
      print(itemUnit);
      // setState(() {
      //   showItemDetailsList = items;
      //   isLoading = false;
      // });
      
      if(showItemDetailsList.length==0){

       // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

      }

      return ItemDetailsModel.fromJson(json.decode(response.body));
     

    }else{
      imageList=[];
      showItemDetailsList = [];
      isLoading = false;
      
    }
  }


  Future<AddToWishListModel> addToWishListProcess() async {
    const addToCart_url='https://api.apanabazar.com/api/wishlist';
    final http.Response response = await http.post(
        Uri.parse(addToCart_url),
        headers: <String, String>{
          // 'Accept': 'application/json',
          //'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer '+WelcomeScreen.userToken
        },

         body: json.encode({
          'itemId': itemDetailsId.toString(),
          'isNotified': '0',
        }),
        // body: {
        //   'email': email,
        //   'password': password,
        // }
    );
      //var responsebody=jsonDecode(jsonDecode(response.body));
      //if(responsebody['status']==)
    if (response.statusCode == 200) {
     

      // final responseBody=json.decode(response.body);
      // SignIn.token=responseBody['auth_token'];
      // return responseBody;

      
      // print('login body');
      // print(response.body);
       return AddToWishListModel.fromJson(json.decode(response.body));
    } else {
     // print("error enter ed");

     // throw Exception('Failed to create album.');
    }
  }

  Future<AddToCartModel> addToCartProcess() async {
    const addToCart_url='https://api.apanabazar.com/api/cart';
    final http.Response response = await http.post(
      Uri.parse(addToCart_url),
      headers: <String, String>{
        // 'Accept': 'application/json',
        //'Content-type': 'application/json',
        'Authorization': 'Bearer '+WelcomeScreen.userToken,
        'Accept': 'application/json'
      },

      body: json.encode({
        'inventoryId': itemDetailsId.toString(),
        'itemCount': "1",
      }),
       
    );
      //var responsebody=jsonDecode(jsonDecode(response.body));
      //if(responsebody['status']==)
    if (response.statusCode == 200) {
  
      // final responseBody=json.decode(response.body);
      // SignIn.token=responseBody['auth_token'];
      // return responseBody;

      
      // print('login body');
     //  print(response.body);
       return AddToCartModel.fromJson(json.decode(response.body));
    } else {
    //  print("error enter ed");

     // throw Exception('Failed to create album.');
    }
  }

  
  @override
  void initState() {
    // TODO: implement initState
    networkImage="";
    itemName="";
    itemImage="";
    productType="";
    productStatus="";
    itemUnit="";
    itemMrp=0;
    itemDiscount="";
    itemSalePrice=0;
    itemTypeName="";
    itemManufacturer="";
    itemVendorname="";
    itemDescription="";
    itemFetures="";
    super.initState();
    //BackButtonInterceptor.add(myInterceptor);
    fetchItemDetails();
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
        title: Center(child: Text('Item Details',style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontWeight: FontWeight.w800,fontSize: 20),),),
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
                    Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> MyOrdersModified()));
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



      body: Container(
        color: themColor,
        child: Stack(
          children: [

            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        child: Icon(Icons.favorite,color: Colors.white),
                        // icon: Icon(Icons.favorite,color: Colors.white,),
                        // label: Text('', style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          primary: themColor,
                          onPrimary: Colors.white,
                          shadowColor: Colors.white54,
                          shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                          elevation: 10,
                        ),

                        onPressed: () async{
                          // print("id");
                          ItemList.addToCartListId=itemDetailsId.toString();
                          // print(ItemList.itemlistId);
                          var response=await addToWishListProcess();
                          bool res=response.response;
                          if(res==true){
                            scaffoldKey.currentState.showSnackBar(SnackBar(content:Text("Added to WishList Successfully"))); 
                          }
                        }
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width/1.05,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.shopping_cart),
                    label: Text('Add To Cart', style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      primary: themColor,
                      onPrimary: Colors.white,
                      shadowColor: Colors.white54,
                      shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                      elevation: 10,
                    ),
                    onPressed: () async{
                    //  print("id");
                     // ItemList.itemlistId=snapshot.data[index]['id'].toString();
                    //  print(ItemList.itemlistId);
                      var response=await addToCartProcess();
                      bool res=response.response;
                      if(res==true){
                        scaffoldKey.currentState.showSnackBar(SnackBar(content:Text("Added to Cart Successfully"))); 
                      }
                    }
                  ),
                ),
              ),

            ),

            Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 50),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(0)),
                  color: Colors.white,
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      
                      
                      children: [

                    ///////////// Carousel Start
                        // CarouselSlider(
                        //   autoPlay: true,
                        //   pauseAutoPlayOnTouch: Duration(seconds: 5),
                        //   height: MediaQuery.of(context).size.height * 0.20,
                        //   items: <Widget>[
                        //     for (var i = 0; i < imageList.length; i++)
                        //       Container(
                        //       // height:200,
                        //           margin: const EdgeInsets.only(top: 20.0, left: 0.0),
                        //           decoration: BoxDecoration(
                        //             image: DecorationImage(
                        //               //image: NetworkImage(imageList[i]),
                        //               image: NetworkImage("https://admin.apanabazar.com/assets/images/ItemImage/${imageList[i]}"),
                        //               // child: Image.network("https://admin.apanabazar.com/assets/thumbnails/${popularList[index]['image']}256X256.jpg",width: 100,height: 100,)
                        //               //fit: BoxFit.fitHeight,
                        //               fit: BoxFit.cover,
                        //             ),
                        //             // border:
                        //             //     Border.all(color: Theme.of(context).accentColor),
                        //             borderRadius: BorderRadius.circular(0.0),
                        //           ),
                        //         ),                                     
                        //   ],
                        // ),
        //////// CarouselSlider end//////////
                        Image.network(networkImage,width: MediaQuery.of(context).size.width/2,height: MediaQuery.of(context).size.height/5),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20,top: 5),
                              child: Text(itemName.toString(),style: TextStyle(color:Colors.black54,fontSize: 20.0,fontWeight: FontWeight.w600,fontFamily: "Roboto"))
                            )
                          ),
                        ),
                      ]
                    ),
                  )
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 250,bottom:50),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                  color: Colors.white60,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top:300,bottom: 50),
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                    color: Colors.white,
                  ),

                  child: Column(
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 2,
                                color: Colors.black54,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text("Exploring Details".toString(),style: TextStyle(color:Colors.black54,fontSize: 20.0,fontWeight: FontWeight.w600,fontFamily: "Roboto")),
                              SizedBox(
                                width: 2,
                              ),
                              Container(
                                width: 50,
                                height: 2,
                                color: Colors.black54,
                              )
                            ],
                          ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Product Type:".toString(),style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay")),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: EdgeInsets.only(left: 0,top: 0),
                                child: Text(productType.toString(),style: TextStyle(color:Colors.black45,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                              )
                            ),
                          
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("About:".toString(),style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay")),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: EdgeInsets.only(left: 0,top: 0),
                                child: Text(productStatus.toString(),style: TextStyle(color:Colors.black45,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                              )
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Unit:".toString(),style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay")),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: EdgeInsets.only(left: 0,top: 0),
                                child: Text(itemUnit.toString(),style: TextStyle(color:Colors.black54,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                              )
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Maximum Sale Price:".toString(),style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay")),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: EdgeInsets.only(left: 0,top: 0),
                                child: Text(itemMrp.toString()+"/-",style: TextStyle(color:Colors.black87,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                              )
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Discount:".toString(),style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay")),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: EdgeInsets.only(left: 0,top: 0),
                                child: Text(itemDiscount.toString(),style: TextStyle(color:Colors.black87,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                              )
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Sale Price:".toString(),style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay")),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: EdgeInsets.only(left: 0,top: 0),
                                child: Text(itemSalePrice.toString()+"/-",style: TextStyle(color:Colors.black87,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                              )
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Type:".toString(),style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay")),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: EdgeInsets.only(left: 0,top: 0),
                                child: Text(itemTypeName.toString(),style: TextStyle(color:Colors.black54,fontSize: 16.0,fontWeight: FontWeight.w800,fontFamily: "RaleWay"))
                              )
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("ManuFacture:".toString(),style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay")),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: EdgeInsets.only(left: 0,top: 0),
                                child: Text(itemManufacturer.toString(),style: TextStyle(color:Colors.black45,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                              )
                            ),
                          ],
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Vendor:".toString(),style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay")),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: EdgeInsets.only(left: 0,top: 0),
                                child: Text(itemVendorname.toString(),style: TextStyle(color:Colors.black45,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                              )
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Description:".toString(),style: TextStyle(color:Colors.black54,fontSize: 20.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay")),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: EdgeInsets.only(left: 0,top: 0),
                                child: Text(itemDescription.toString(),style: TextStyle(color:Colors.black45,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                              )
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Fetures:".toString(),style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay")),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: EdgeInsets.only(left: 0,top: 0),
                                child: Text(itemFetures.toString(),style: TextStyle(color:Colors.black45,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                              )
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
            
          ],
          
        ),
      ),

      
    );
  }
}