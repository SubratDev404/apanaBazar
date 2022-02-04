import 'dart:convert';
import 'dart:io';

import 'package:apanabazar/CurvedBottomNavigationBar/CurvedButtonNavigationBar.dart';
import 'package:apanabazar/Drawer.dart';
import 'package:apanabazar/Model/AddToCartModel.dart';
import 'package:apanabazar/Model/AddToWishListModel.dart';
import 'package:apanabazar/Model/ItemDetailsModel.dart';
import 'package:apanabazar/Screens/Home/Home.dart';
import 'package:apanabazar/Screens/ItemList/ItemList.dart';
import 'package:apanabazar/Screens/NoItemsPage/NoItemInWishList/NoItemInWishList.dart';
import 'package:apanabazar/Screens/Search/Search.dart';
import 'package:apanabazar/Screens/WelComeScreen/WelcomeScreen.dart';
import 'package:apanabazar/constants/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';




class ItemDetailsModified extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    /// screen Orientation start///////////
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    /// screen Orientation end///////////
    return MaterialApp(

      builder: (context, child) {
        return MediaQuery(
          child: child,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      debugShowCheckedModeBanner: false,
      home: ItemDetailsModifiedScreen(),
    );
  }
}

class ItemDetailsModifiedScreen extends StatefulWidget {
  

  @override
  _ItemDetailsModifiedScreenState createState() => _ItemDetailsModifiedScreenState();
}

class _ItemDetailsModifiedScreenState extends State<ItemDetailsModifiedScreen> {
  
  String itemName,itemImage,productType,productStatus,itemUnit,itemDiscount,networkImage,
  itemTypeName,itemManufacturer,itemVendorname,itemDescription,itemFetures,itemVarientId;
  String itemCartId,itemWishListId;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  String itemMrp,itemSalePrice;

  List showItemDetailsList = [];
  List imageList=[];
  bool isLoading = true;

  int _current = 0; // carousel dot indicator intialize

  Future<ItemDetailsModel> fetchItemDetails() async {
    // setState(() {
    //   isLoading = true;
    // });
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

      var res=json.decode(response.body);

      
      print("WishList response>>>>>>"+res.toString());
      if(res==false){
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInWishList()));
      }

      var additionalImagess = json.decode(response.body)['data']['additionalImage'] ?? [];

      
      print('additionalImagess image');
      print(additionalImagess);
      
      setState(() {
        imageList = additionalImagess ;
        isLoading = false;
      });

      print("imageList "+imageList.toString());

      setState(() {
        itemCartId = json.decode(response.body)['data']['id'];
        itemWishListId = json.decode(response.body)['data']['variantid'];
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
        itemVarientId=json.decode(response.body)['data']['variantdetails']['variantdetails'][0]['id'];
       // print("id///////////"+itemDetailsId.toString());

        networkImage="https://admin.apanabazar.com/assets/thumbnails/${itemImage}256X256.jpg";

        print("itemWishListId "+itemWishListId.toString());
        print("itemCartId "+itemCartId.toString());
      });
      
       
      print('item Details body');
     
      print(itemUnit.toString());
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
          'itemId': itemWishListId.toString(),
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
        'inventoryId': itemCartId.toString(),
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
    itemMrp="";
    //itemMrp=0;
    itemDiscount="";
    itemSalePrice="";
    //itemSalePrice=0;
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

      endDrawer: Container(
        width: MediaQuery.of(context).size.width*0.7,
        child: MyDrawer()
      ),
      
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return null;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Container(
            color: themColor,
            child: Stack(
              children: [
        
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(0)),
                    color: Colors.white,
                  ),

                  child: isLoading
                    //? new Center(child: new CircularProgressIndicator(),) :

                  
                  ? shimmerEffect() :

                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [

                          Padding(
                            padding: const EdgeInsets.only(top: 1,right: 10),
                            child: Align(
                              alignment: Alignment.topCenter,

                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child:Row(
                                  children: [

                                    //////////// Search Bar Start
                                    InkWell(
                                      onTap: (){
                                        Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> Search()));
                                      } ,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10,right: 10),
                                        child: Container(
                                          
                                          height: 35,
                                          width: MediaQuery.of(context).size.width-100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                                            boxShadow: [
                                              BoxShadow(color: Colors.black54, spreadRadius: 2),
                                            ],
                                          
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left:10),
                                            child: Row(
                                              children: [
                                                Icon(Icons.search,color: Colors.black45, size: 20,),
                                                Text("Search here...", style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.black38,fontFamily: 'RaleWay'),),
                                              ],
                                            ),
                                          ),
                                    
                                        ),
                                      ),
                                    ),
                                    ///////////// Search Bar end,
                                
                                    // Container(
                                    //   width: MediaQuery.of(context).size.width-100,
                                    //   child: Row(
                                    //     mainAxisAlignment: MainAxisAlignment.start,
                                    //     children: [
                                    //       IconButton(
                                    //             icon: Icon(Icons.search,color: Colors.white,size: 30,),
                                    //             onPressed: (){
                                    //               //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
                                    //               Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> Search()));
                                    //             },
                                    //       ),
                                    //     ]
                                    //   ) 
                                    // ),   

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
                                        ItemList.addToCartListId=itemWishListId.toString();
                                        // print(ItemList.itemlistId);
                                        var response=await addToWishListProcess();
                                        bool res=response.response;
                                        var message=response.message;
                                        if(res==true){
                                          scaffoldKey.currentState.showSnackBar(SnackBar(content:Text(message))); 
                                        }

                                        if(res==false){
                                          scaffoldKey.currentState.showSnackBar(SnackBar(content:Text(message))); 
                                        }
                                      }
                                    ),

                                    
                              
                                  ]  
                                ),
                              ),
          
                 
                            ),
                           
                          ),
                          
                          ///////////// Carousel Start
                          imageList.length==0 ? 
                          Container(
                            height: MediaQuery.of(context).size.height/2.5,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/no_image.png",), fit: BoxFit.fitHeight,
                              )
                            ),
                            //child: Center(child: Text("No Image Available...",style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.w700,fontFamily: "Roboto")),),
                          ) :
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: CarouselSlider(
                              options: CarouselOptions(
                                viewportFraction: 0.9,
                                aspectRatio: 2.0,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                scrollDirection: Axis.horizontal,
                               // initialPage: 2,
                                //viewportFraction: 0.6,
                                autoPlayAnimationDuration: const Duration(milliseconds: 5),
                                autoPlay: false,
                                enlargeCenterPage: true,
                                //height: MediaQuery.of(context).size.height * 0.50,
                                height: MediaQuery.of(context).size.height/2.5,
                                onPageChanged: (index, reason) {  // dot indicator ui
                                  setState(() {
                                    _current = index;
                                  });
                                }
                              ),
                              items: imageList
                                  .map(
                                    (item) => Container(
                                      margin: EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          topRight: Radius.circular(5),
                                          bottomLeft: Radius.circular(5),
                                          bottomRight: Radius.circular(5)
                                        )
                                      ),
                                      height: 400,
                                      child: Image.network(
                                        "https://admin.apanabazar.com/assets/images/ItemImage/${item}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),




                          // Padding(
                          //   padding: EdgeInsets.only(top: 1),
                          //   child: Positioned(  // dot indicatot position below Carousel Slider
                          //     top: 50,
                          //     right: 10,
                           //   child: 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: imageList.map((url) {
                                  int index = imageList.indexOf(url);
                                  return Container(
                                    width: 15.0,
                                    height: 10.0,
                                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _current == index
                                        ? themColor
                                        : Color.fromRGBO(0, 0, 0, 0.6),
                                    ),
                                  );
                                }).toList(),
                              ),
                            //),
                         // ),
                           ///////////// Carousel end
                        
                          
                        ///////////// Carousel Start
                          // CarouselSlider(
                          //   autoPlay: false,
                          //   pauseAutoPlayOnTouch: Duration(seconds: 5),
                          //   height: MediaQuery.of(context).size.height * 0.40,
                          //   items: <Widget>[
                          //     for (var i = 0; i < imageList.length; i++)
                          //       Container(
                          //       // height:200,
                          //           margin: const EdgeInsets.only(top: 20.0, left: 20.0,),
                          //           decoration: BoxDecoration(
                          //             image: DecorationImage(
                          //               //image: NetworkImage(imageList[i]),
                          //               image:https://admin.apanabazar.com/assets/images/ItemImage/${imageList[i]} NetworkImage(""),
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
                          
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height/4,

                              child: ListWheelScrollView(
                                itemExtent: 80,
                                //offAxisFraction: -0.9,
                                diameterRatio: 1.5,
                               // squeeze: 0.8,
                                children: [

                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 20,
                                    color: Colors.grey[200],
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10,right: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [

                                              itemDiscount.toString() == "0" || itemDiscount.toString() == "00" ? 
                                              Text("") :
                                              Text(itemMrp.toString(),style: TextStyle(decorationColor: Colors.black54,decorationStyle: TextDecorationStyle.solid,decoration:TextDecoration.lineThrough,color:Colors.black26,fontSize: 30.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay")),

                                              SizedBox(width: 7),
                                             // Image.asset("assets/images/indian_money.png",width: 20,height: 30,),
                                              Text("₹"+itemSalePrice.toString(),style: TextStyle(color:Colors.black87,fontSize: 30.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay")),
                                              SizedBox(width: 7),

                                              itemDiscount.toString() == "0" || itemDiscount.toString() == "00" ? 
                                              Text(""):
                                              Text(itemDiscount.toString(),style: TextStyle(color:Colors.green,fontSize: 20.0,fontWeight: FontWeight.w800,fontFamily: "RaleWay")),

                                              SizedBox(width: 1),

                                              itemDiscount.toString() == "0" || itemDiscount.toString() == "00" ? 
                                              Text("") :
                                              Text("%",style: TextStyle(color:Colors.green,fontSize: 20.0,fontWeight: FontWeight.w700,fontFamily: "RaleWay")),

                                              itemDiscount.toString() == "0" || itemDiscount.toString() == "00" ? 
                                              Text("") :
                                              Text("OFF",style: TextStyle(color:Colors.green,fontSize: 20.0,fontWeight: FontWeight.w700,fontFamily: "RaleWay")),
                                              // SingleChildScrollView(
                                              //   scrollDirection: Axis.horizontal,
                                              //   child: Padding(
                                              //     padding: EdgeInsets.only(left: 0,top: 0),
                                              //     child: Text(productType.toString(),style: TextStyle(color:Colors.black45,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                                              //   )
                                              // ),
                                            
                                            ],
                                          ),

                                          itemTypeName.toString()=="Veg" ?

                                          Text(itemTypeName.toString(),style: TextStyle(color:Colors.green,fontSize: 30.0,fontWeight: FontWeight.w900,fontFamily: "RaleWay"))
                                          : Text(itemTypeName.toString(),style: TextStyle(color:Colors.red,fontSize: 30.0,fontWeight: FontWeight.w900,fontFamily: "RaleWay"))


                                        ]  
                                      ),
                                    ),
                                  ),

                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 10,
                                    color: Colors.grey[200],
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10,right: 10),
                                      child: Row(
                                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width/2.5,
                                            height: 20,
                                            child: Text("Product Type:".toString(),style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                                          ),
                                          
                                          Flexible(
                                            child: Text(productType.toString(),overflow: TextOverflow.visible,maxLines: 1,style: TextStyle(color:Colors.black45,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                                          )
                                            
                                        
                                        ],
                                      ),
                                    ),
                                  ),

                                   Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 20,
                                    color: Colors.grey[200],
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10,right: 10),
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width/2.5,
                                            height: 20,
                                            child: Text("About Product:".toString(),style: TextStyle(color:Colors.black38,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                                          ),
                                          Flexible(
                                            child: Text(productStatus.toString(),overflow: TextOverflow.visible,maxLines: 1,style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.w900,fontFamily: "RaleWay"))
                                          )
                                            
                                        ],
                                      ),
                                    ),
                                  ),

                                   Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 20,
                                    color: Colors.grey[200],
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10,right: 10),
                                      child: Row(
                                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width/2.5,
                                            height: 20,
                                            child: Text("Unit:".toString(),style: TextStyle(color:Colors.black38,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                                          ),
                                          
                                          Flexible(
                                            child: Text(itemUnit.toString(),overflow: TextOverflow.visible,maxLines: 1,style: TextStyle(color:Colors.black54,fontSize: 14.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                                          )
                                            
                                        ],
                                      ),
                                    ),
                                  ),

                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 20,
                                    color: Colors.grey[200],
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10,right: 10),
                                      child: Row(
                                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width/2.5,
                                            height: 20,
                                            child: Text("ManuFacture:".toString(),style: TextStyle(color:Colors.black45,fontSize: 18.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                                          ),
                                          Flexible(
                                            child: Text(itemManufacturer.toString(),overflow: TextOverflow.visible,maxLines: 1,style: TextStyle(color:Colors.black87,fontSize: 18.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                                          )
                                            
                                        ],
                                      ),
                                    ),
                                  ),
                            
                            
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 20,
                                      color: Colors.grey[200],
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10,right: 10),
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context).size.width/2.5,
                                              height: 20,
                                              child: Text("Vendor:".toString(),style: TextStyle(color:Colors.black45,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                                            ),
                                            Flexible(
                                              child: Text(itemVendorname.toString(),overflow: TextOverflow.visible,maxLines: 1,style: TextStyle(color:Colors.black38,fontSize: 17.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                                            )
                                            
                                          ],
                                        ),
                                      ),
                                    ),

                                    
                            
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 20,
                                      color: Colors.grey[200],
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10,right: 10),
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context).size.width/2.5,
                                              height: 20,
                                              child: Text("Description:".toString(),style: TextStyle(color:Colors.black45,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                                              ),

                                            Flexible(
                                              child: Text(itemDescription.toString(),overflow: TextOverflow.visible,maxLines: 4,style: TextStyle(color:Colors.black45,fontSize: 14.0,fontWeight: FontWeight.w800,fontFamily: "RaleWay"))
                                            )
                                           
                                            // Expanded(
                                            //   child: SingleChildScrollView(
                                            //     scrollDirection: Axis.horizontal,
                                            //     child: Padding(
                                            //       padding: EdgeInsets.only(left: 100,top: 0),
                                            //       child: Text(itemDescription.toString(),overflow: TextOverflow.visible,style: TextStyle(color:Colors.black38,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                                            //     )
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),

                                   
                            
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 20,
                                      color: Colors.grey[200],
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10,right: 10),
                                        child: Row(
                                         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 20,
                                              width: MediaQuery.of(context).size.width/2.5,
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text("Fetures:".toString(),style: TextStyle(color:Colors.black45,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                                              )
                                            ),

                                            Flexible(
                                              child: Text(itemFetures.toString(),overflow: TextOverflow.visible,maxLines: 4,style: TextStyle(color:Colors.black45,fontSize: 14.0,fontWeight: FontWeight.w800,fontFamily: "RaleWay"))
                                            ),
                                            
                                            
                                          //   Expanded(
                                          //     child: SingleChildScrollView(
                                          //       scrollDirection: Axis.horizontal,
                                          //       child: Padding(
                                          //         padding: EdgeInsets.only(left: 100,top: 0),
                                          //         child: Text(itemFetures.toString(),overflow: TextOverflow.visible,style: TextStyle(color:Colors.black45,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                                          //       )
                                          //     ),
                                          //  ),
                                          ],
                                        ),
                                      ),
                                    ),

                                ],
                              ),
                              
                              // child: SingleChildScrollView(
                              //   child: Column(
                              //     children: [
                            
                              

                              //       Container(
                              //         width: MediaQuery.of(context).size.width,
                              //         child: Padding(
                              //           padding: const EdgeInsets.only(left: 10,right: 10),
                              //           child: Row(
                              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //             children: [
                              //               Row(
                              //                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                 children: [
                              //                   Text(itemMrp.toString(),style: TextStyle(color:Colors.black26,fontSize: 30.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay")),
                              //                   SizedBox(width: 7),
                              //                   Image.asset("assets/images/indian_money.png",width: 20,height: 30,),
                              //                   Text(itemSalePrice.toString(),style: TextStyle(color:Colors.black87,fontSize: 30.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay")),
                              //                   SizedBox(width: 7),
                              //                   Text(itemDiscount.toString(),style: TextStyle(color:Colors.green,fontSize: 20.0,fontWeight: FontWeight.w800,fontFamily: "RaleWay")),
                              //                   SizedBox(width: 1),
                              //                   Text("%",style: TextStyle(color:Colors.green,fontSize: 20.0,fontWeight: FontWeight.w700,fontFamily: "RaleWay")),
                              //                   Text("OFF",style: TextStyle(color:Colors.green,fontSize: 20.0,fontWeight: FontWeight.w700,fontFamily: "RaleWay")),
                              //                   // SingleChildScrollView(
                              //                   //   scrollDirection: Axis.horizontal,
                              //                   //   child: Padding(
                              //                   //     padding: EdgeInsets.only(left: 0,top: 0),
                              //                   //     child: Text(productType.toString(),style: TextStyle(color:Colors.black45,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                              //                   //   )
                              //                   // ),
                                              
                              //                 ],
                              //               ),

                              //               itemTypeName.toString()=="Veg" ?

                              //               Text(itemTypeName.toString(),style: TextStyle(color:Colors.green,fontSize: 30.0,fontWeight: FontWeight.w900,fontFamily: "RaleWay"))
                              //               : Text(itemTypeName.toString(),style: TextStyle(color:Colors.red,fontSize: 30.0,fontWeight: FontWeight.w900,fontFamily: "RaleWay"))


                              //             ]  
                              //           ),
                              //         ),
                              //       ),
                            
                              //       Container(
                              //         width: MediaQuery.of(context).size.width,
                              //         child: Padding(
                              //           padding: const EdgeInsets.only(left: 10,right: 10),
                              //           child: Row(
                              //             //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //             children: [
                              //               Container(
                              //                 width: MediaQuery.of(context).size.width/2.5,
                              //                 height: 20,
                              //                 child: Text("Product Type:".toString(),style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                              //               ),
                                            
                              //               Flexible(
                              //                 child: Text(productType.toString(),overflow: TextOverflow.visible,style: TextStyle(color:Colors.black45,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                              //               )
                                              
                                          
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                            
                              //       Container(
                              //         width: MediaQuery.of(context).size.width,
                              //         child: Padding(
                              //           padding: const EdgeInsets.only(left: 10,right: 10),
                              //           child: Row(
                              //            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //             children: [
                              //               Container(
                              //                 width: MediaQuery.of(context).size.width/2.5,
                              //                 height: 20,
                              //                 child: Text("About Product:".toString(),style: TextStyle(color:Colors.black38,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                              //               ),
                              //               Flexible(
                              //                 child: Text(productStatus.toString(),overflow: TextOverflow.visible,style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.w900,fontFamily: "RaleWay"))
                              //               )
                                             
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                            
                              //       Container(
                              //         width: MediaQuery.of(context).size.width,
                              //         child: Padding(
                              //           padding: const EdgeInsets.only(left: 10,right: 10),
                              //           child: Row(
                              //             //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //             children: [
                              //               Container(
                              //                 width: MediaQuery.of(context).size.width/2.5,
                              //                 height: 20,
                              //                 child: Text("Unit:".toString(),style: TextStyle(color:Colors.black38,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                              //               ),
                                            
                              //               Flexible(
                              //                 child: Text(itemUnit.toString(),overflow: TextOverflow.visible,style: TextStyle(color:Colors.black54,fontSize: 14.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                              //               )
                                              
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                            
                                  
                            
                              //       Container(
                              //         width: MediaQuery.of(context).size.width,
                              //         child: Padding(
                              //           padding: const EdgeInsets.only(left: 10,right: 10),
                              //           child: Row(
                              //             //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //             children: [
                              //               Container(
                              //                 width: MediaQuery.of(context).size.width/2.5,
                              //                 height: 20,
                              //                 child: Text("ManuFacture:".toString(),style: TextStyle(color:Colors.black45,fontSize: 18.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                              //               ),
                              //               Flexible(
                              //                 child: Text(itemManufacturer.toString(),overflow: TextOverflow.visible,style: TextStyle(color:Colors.black87,fontSize: 18.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                              //               )
                                              
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                            
                            
                              //       Container(
                              //         width: MediaQuery.of(context).size.width,
                              //         child: Padding(
                              //           padding: const EdgeInsets.only(left: 10,right: 10),
                              //           child: Row(
                              //             //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //             children: [
                              //               Container(
                              //                 width: MediaQuery.of(context).size.width/2.5,
                              //                 height: 20,
                              //                 child: Text("Vendor:".toString(),style: TextStyle(color:Colors.black45,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                              //               ),
                              //               Flexible(
                              //                 child: Text(itemVendorname.toString(),overflow: TextOverflow.visible,style: TextStyle(color:Colors.black38,fontSize: 17.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                              //               )
                                            
                              //             ],
                              //           ),
                              //         ),
                              //       ),

                              //       SizedBox(
                              //         height: 5,
                              //       ),
                            
                              //       Container(
                              //         width: MediaQuery.of(context).size.width,
                              //         child: Padding(
                              //           padding: const EdgeInsets.only(left: 10,right: 10),
                              //           child: Row(
                              //             //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //             children: [
                              //               Container(
                              //                 width: MediaQuery.of(context).size.width/2.5,
                              //                 height: 20,
                              //                 child: Text("Description:".toString(),style: TextStyle(color:Colors.black45,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                              //                 ),

                              //               Flexible(
                              //                 child: Text(itemDescription.toString(),overflow: TextOverflow.visible,style: TextStyle(color:Colors.black45,fontSize: 14.0,fontWeight: FontWeight.w800,fontFamily: "RaleWay"))
                              //               )
                                           
                              //               // Expanded(
                              //               //   child: SingleChildScrollView(
                              //               //     scrollDirection: Axis.horizontal,
                              //               //     child: Padding(
                              //               //       padding: EdgeInsets.only(left: 100,top: 0),
                              //               //       child: Text(itemDescription.toString(),overflow: TextOverflow.visible,style: TextStyle(color:Colors.black38,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                              //               //     )
                              //               //   ),
                              //               // ),
                              //             ],
                              //           ),
                              //         ),
                              //       ),

                              //       SizedBox(
                              //         height: 5,
                              //       ),
                            
                              //       Container(
                              //         width: MediaQuery.of(context).size.width,
                              //         child: Padding(
                              //           padding: const EdgeInsets.only(left: 10,right: 10),
                              //           child: Row(
                              //            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //             children: [
                              //               Container(
                              //                 height: 20,
                              //                 width: MediaQuery.of(context).size.width/2.5,
                              //                 child: Align(
                              //                   alignment: Alignment.topLeft,
                              //                   child: Text("Fetures:".toString(),style: TextStyle(color:Colors.black45,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                              //                 )
                              //               ),

                              //               Flexible(
                              //                 child: Text(itemFetures.toString(),overflow: TextOverflow.visible,style: TextStyle(color:Colors.black45,fontSize: 14.0,fontWeight: FontWeight.w800,fontFamily: "RaleWay"))
                              //               ),
                                            
                                            
                              //             //   Expanded(
                              //             //     child: SingleChildScrollView(
                              //             //       scrollDirection: Axis.horizontal,
                              //             //       child: Padding(
                              //             //         padding: EdgeInsets.only(left: 100,top: 0),
                              //             //         child: Text(itemFetures.toString(),overflow: TextOverflow.visible,style: TextStyle(color:Colors.black45,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
                              //             //       )
                              //             //     ),
                              //             //  ),
                              //             ],
                              //           ),
                              //         ),
                              //       ),


                            
                              //     ],
                              //   ),
                              // ),
                          
                          
                            ),
                          ),
                          
                          SizedBox(
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
                          
                        ]  
                      ),
                    ),
                  ),
                ),
                
              ],
              
            ),
          ),
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
          itemCount: 1,
          itemBuilder: (context,index){
            return ListTile(
              // leading: Icon(Icons.image,size: 50,),
              title: Column(
                children: [ 

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Container(
                        width: 50,
                        height: 15,
                        color: Colors.black87,
                      ),

                    

                      Container(
                        width: 100,
                        height: 5,
                        color: Colors.black87,
                      ),


                    ],

                  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      // height: MediaQuery.of(context).size.height/9,
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 5,
                  ),


                  Padding(
                    padding: EdgeInsets.only(top: 10,left: 5,right: 5),

                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      color: Colors.black12,
                      // alignment: Alignment.bottomCenter,
                        
                        child: Column(
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
                              height: 10,
                            ),

                            Center(
                              child: Container(
                                width: 200,
                                height: 30,
                                color: Colors.black87,
                              ),
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