import 'dart:convert';
import 'dart:io';
import 'package:apanabazar/CurvedBottomNavigationBar/CurvedButtonNavigationBar.dart';
import 'package:apanabazar/Drawer.dart';
import 'package:apanabazar/Model/SubCategoryModel.dart';
import 'package:apanabazar/Screens/Cart/Cart.dart';
import 'package:apanabazar/Screens/Home/Home.dart';
import 'package:apanabazar/Screens/LoginRegistration/Login.dart';
import 'package:apanabazar/Screens/MyOrders/MyOrders.dart';
import 'package:apanabazar/Screens/MyOrders/MyOrdersModified.dart';
import 'package:apanabazar/Screens/NoItemsPage/NoItemInCart/NoItemInCart.dart';
import 'package:apanabazar/Screens/NoItemsPage/NoItemInWishList/NoItemInWishList.dart';
import 'package:apanabazar/Screens/NoItemsPage/NoItemsInItemList/NoItemInItemList.dart';
import 'package:apanabazar/Screens/NoItemsPage/NoItemsInSubCategory/NoItemInSubCategory.dart';
import 'package:apanabazar/Screens/ProductList/ProductList.dart';
import 'package:apanabazar/Screens/Profile/Profile.dart';
import 'package:apanabazar/Screens/Search/Search.dart';
import 'package:apanabazar/Screens/WelComeScreen/WelcomeScreen.dart';
import 'package:apanabazar/Screens/WishList/WishList.dart';
import 'package:apanabazar/constants/constants.dart';
import 'package:apanabazar/onboarding/NewOnBoarding/mainappbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';


// class HttpService {
//   final String url = "https://api.apanabazar.com/api/subcategory";

//   Future<SubcategoryModel> getPost() async {
//     var response = await http.post(Uri.parse(url),

//       headers:<String, String>
//       {
//         //'Accept': 'application/json',
//        // 'Authorization': 'Bearer'+''+Login.token,
//       //  'Content-type': 'application/json',
//         'Accept': 'application/json',
//         'Authorization': 'Bearer'+' '+WelcomeScreen.userToken,
//       },

//       body: json.encode({
//         "categoryid": Home.categoryId.toString()
//       })

//       // body: {
//       //   "categoryid": "33"
//       // }
//     );

//     if (response.statusCode == 200) {
//       var body = json.decode(response.body);
//       bool res=SubcategoryModel.fromJson(body).response;

//       print("res /////////////////////"+ res.toString());
//       print(body);
//       if(res==false){
//         print("sub category"+res.toString());
//        // checking();
//         //Text("no data");

       

//         Fluttertoast.showToast(
//           msg: "No Items Found",
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.CENTER,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//           fontSize: 16.0
//         );
//        }
      
//       return SubcategoryModel.fromJson(body);
//     }

    
//   }
// }



class SubCategory extends StatelessWidget {

  static int subCategoryId;
  

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
      home: SubCategoryScreen(),
    );
  }
}

class SubCategoryScreen extends StatefulWidget {

  @override
  _SubCategoryScreenState createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {

  int cartWishListCount=0;
  int cartBadgeCount=0;

   bool isLoading=true;
  List showSubCategoryList; 


  //final HttpService httpservice = HttpService();

  Future<SubCategoryModel> getSubCategory() async {
   final String subCategoryUrl = "https://api.apanabazar.com/api/subcategory";
    //print(userid); print(token);print(userToken);
    final http.Response response = await http.post(
      Uri.parse(subCategoryUrl),
       headers:<String, String>
      {
        //'Accept': 'application/json',
       // 'Authorization': 'Bearer'+''+Login.token,
      //  'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer'+' '+WelcomeScreen.userToken,
      },

      body: json.encode({
        "categoryid": Home.categoryId.toString()
      })
      
    );

    if (response.statusCode == 200) {
     //  print("category body....."+response.body);
     //fList<BrandModel> list = BrandModel.parseBrands(response.body);
        print(' subcategory body+++++++++++++++++++++++++++++++++++');
        print(response.body);
        // print(response.body.length);
        bool res=json.decode(response.body)['response'];
        var items=json.decode(response.body)['data'] ?? []; // if no json array come, default array will pass to model

        setState(() {
          showSubCategoryList=items;
          isLoading=false;
        });

        if(res==false){
          Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInSubCategoryList()));
        }

        json.decode(response.body);

        // final jsonList=json.decode(response.body) as List;
        // print("jsonlist >>>>"+jsonList.toString());
        
      return SubCategoryModel.fromJson(json.decode(response.body));
    } 
    else {
      throw Exception('Failed to load album');
    }
  }

  fetchCartList() async {
    var cartList_url= "https://api.apanabazar.com/api/cart";
    var response = await http.get(
      Uri.parse(cartList_url),
      headers: <String, String>{
          // 'Accept': 'application/json',
          //'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer '+WelcomeScreen.userToken
      },
    );
    // print(response.body);
    if(response.statusCode == 200){
      var nos_of_items_in_Cart = json.decode(response.body)['itemCount'];

      setState(() {
        cartBadgeCount=nos_of_items_in_Cart as int;     
      });
      
    }
    else{}
  }

  fetchWishList() async {
    var showWishList_url= "https://api.apanabazar.com/api/showwishlist";
    var response = await http.get(
      Uri.parse(showWishList_url),
      headers: <String, String>{
          // 'Accept': 'application/json',
          //'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer '+WelcomeScreen.userToken
      },
    );
    if(response.statusCode == 200){
      var nos_of_items_in_WishList = json.decode(response.body)['data'].length;
      setState(() {
        cartWishListCount=nos_of_items_in_WishList as int;
      });
    }else{}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSubCategory();
    //BackButtonInterceptor.add(myInterceptor);
    fetchCartList();
    fetchWishList();
  }

  @override
  void dispose() {
    //BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

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
        title: Center(child: Text('Category',style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontWeight: FontWeight.w800,fontSize: 20),),),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
          onPressed: (){
           // Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
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
                            width: MediaQuery.of(context).size.width-120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(color: Colors.redAccent, spreadRadius: 2),
                              ],
                            
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left:10),
                              child: Row(
                                children: [
                                  Icon(Icons.search,color: Colors.black45, size: 20,),
                                  Text("Search here..", style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.black38,fontFamily: 'RaleWay'),),
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
                      
                        
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 50,
                              color: themColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children:[
                                  Padding(
                                    padding: EdgeInsets.only(right:2),
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.of(context,rootNavigator:false).push(MaterialPageRoute(builder: (context)=> WishList()));
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 80,
                                        child: Stack(
                                          children: <Widget>[
                                            Icon(Icons.favorite,color: Colors.white,size: 40),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                width: 25,
                                                height: 25,
                                                decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.amber),
                                                child: Center(
                                                  child: Text(cartWishListCount.toString()),
                                                ),
                                              )
                                            )
                                          ]
                                        )
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.of(context,rootNavigator:false).push(MaterialPageRoute(builder: (context)=> Cart()));
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 80,
                                        child: Stack(
                                          children: <Widget>[
                                            Icon(Icons.shopping_cart,color: Colors.white,size: 40),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                width: 25,
                                                height: 25,
                                                decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.amber),
                                                child: Center(
                                                  child: Text(cartBadgeCount.toString()),
                                                ),
                                              )
                                            )
                                          ]
                                        )
                                      ),
                                    ),
                                  ),
                                ]
                              ),
                            ),
                          ]
                        ),
                      ),
                    ]  
                  ),
                ),
          
                
              ),
            ),
            

            // Padding(
            //   padding: EdgeInsets.only(top: 50,bottom: 20),
            //   child: Container(
            //     width: MediaQuery.of(context).size.width,
            //     height: MediaQuery.of(context).size.height,
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
            //     ),
            //     child: Align(
            //       alignment: Alignment.topRight,
            //       child: Padding(
            //         padding: EdgeInsets.only(right: 20,bottom: 2),
            //         child: Text('Selling Good Quality Freesh Vegitables is Our Moto...',style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w800,fontSize: 14,fontFamily: 'Open Sans',fontStyle: FontStyle.italic,),) ,
            //       ),
            //     ),
            //   )
            // ),



            // Padding(
            //   padding: EdgeInsets.only(top: 80,bottom: 20),
            //   child: Container(
            //     width: MediaQuery.of(context).size.width,
            //     height: MediaQuery.of(context).size.height,
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
            //     ),
            //     child: Align(
            //       alignment: Alignment.bottomLeft,
            //       child: Padding(
            //         padding: EdgeInsets.only(left: 20,bottom: 2),
            //         child: Text('Customer wants Freesh, We provide fresh vegetables...',style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w800,fontSize: 14,fontFamily: 'Open Sans',fontStyle: FontStyle.italic,),) ,
            //       ),
            //     ),
            //   )
            // ),
            
          
            Padding(
              padding: EdgeInsets.only(top: 50,bottom: 0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),bottomLeft: Radius.circular(0),bottomRight: Radius.circular(0)),
                ),

             
                child: isLoading

               // ? new Center(child: new CircularProgressIndicator()) :
                ? shimmerEffect() :
                    
                  
                GridView.builder(
                  itemCount: showSubCategoryList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 8, mainAxisSpacing: 4),
                  padding: EdgeInsets.all(1),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context,index){
                    return ListTile(
                      title: Padding(
                        padding: EdgeInsets.only(bottom: 1,top: 10),
                        child: InkWell(
                          splashColor: themColor,
                          onTap: (){
                            SubCategory.subCategoryId=showSubCategoryList[index]['id'];
                            print("Sub category ////////////////// id "+SubCategory.subCategoryId.toString());
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
                          },
                          child: Container(
                            
                            
                            child: Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: 10,
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(showSubCategoryList[index]['image']),
                                      fit: BoxFit.cover
                                    )
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    height: 50,
                                    color: Colors.black45,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(showSubCategoryList[index]['name'].toString() ?? "",overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(color:Colors.white,fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                    ),
                                  ),

                                ),
                                
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
      
                                margin: EdgeInsets.all(10),
                            ),
                              
                            
                          ),
                        ),
                      ),

                    );
                  },
                )

               
              )
            )
            
          ]
        )
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
              title: 
              Padding(
                padding: EdgeInsets.only(top: 20,left: 5,right: 5),

                child: Container(
                  height: MediaQuery.of(context).size.height/4,
                  width: double.infinity,
                  color: Colors.black12,
                  // alignment: Alignment.bottomCenter,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(left: 10,top: 20),
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Colors.black87,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(right: 10,top: 20),
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Colors.black87,
                        ),
                      ),

                    ],

                  ),
                      
                ),
      
              ),
                
            
          
            );
            
          }
        ),
        baseColor: Colors.grey, 
        highlightColor: Colors.white,
      ),
      
    );
  }
}