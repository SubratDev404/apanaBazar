import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:apanabazar/Drawer.dart';
import 'package:apanabazar/Model/DynamicListModel1.dart';
import 'package:apanabazar/Model/DynamicListModel2.dart';
import 'package:apanabazar/Model/DynamicListModel3.dart';
import 'package:apanabazar/Model/SliderImageModel.dart';
import 'package:apanabazar/Screens/Cart/Cart.dart';
import 'package:apanabazar/Screens/ItemDetails/ItemDetailsModified.dart';
import 'package:apanabazar/Screens/Profile/Profile.dart';
import 'package:apanabazar/Screens/Search/Search.dart';
import 'package:apanabazar/Screens/SubCategory/SubCategory.dart';
import 'package:apanabazar/Screens/WelComeScreen/WelcomeScreen.dart';
import 'package:apanabazar/Screens/WishList/WishList.dart';
import 'package:apanabazar/constants/constants.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:carousel_pro/carousel_pro.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
//import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



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
//         "categoryid": "1"
//       })

//       // body: {
//       //   "categoryid": "7"
//       // }
//     );

//     if (response.statusCode == 200) {
//       var body = json.decode(response.body);
//       bool res=SubcategoryModel.fromJson(body).response;
       
//     //  print("res /////////////////////"+ res.toString());
//     //  print(body);
//       if(res==false){

        
//         Text("no data");

//         Fluttertoast.showToast(
//           msg: "No Items Found",
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.CENTER,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//           fontSize: 16.0
//         );
//       }
//       return SubcategoryModel.fromJson(body);
//     }
//   }
// }

class Home extends StatelessWidget {

  static int categoryId;
  static String itemId;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light); // 1

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
       
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      debugShowCheckedModeBanner: false,
      
      home: Scaffold(
        body: DoubleBackToCloseApp(
          child: HomeScreen(),
          snackBar: const SnackBar(
            content: Text('Tap back again to close the app'),
            backgroundColor: Colors.red,
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DateTime lastPressed; // double tap to back


  bool _visible=false; // for hiding widget

  int _current = 0; // carousel dot indicator intialize

  //// Greeting Message started
  var timeNow;
  String greetingMessageStatus;

  String greetingMessage(){
  
    var timeNow = DateTime.now().hour;

    if (timeNow <= 12) {
      return 'Good Morning';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      return 'Good Afternoon';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  void upDateGreetingMessageAccordingToTime(){
    setState(() {
      greetingMessageStatus = greetingMessage();
    });
  }

  ///////////////// Greeting Message

  final HttpService httpp = HttpService();  // HttpServices intialization 

  String token,userid,popularListName,tredingListName,collectionListName;
  int cartWishListCount=0;
  int cartBadgeCount=0;

  List categoryList; 
  List sliderList;
  List popularList;
  List tredingList;
  List collectionList;
  bool isLoading = false;

  Future fetchData() async {
    
    setState(() {
      isLoading = true;
    });
  
    var url= "https://api.apanabazar.com/api/category";
    var response = await http.get(Uri.parse(url),
    headers:<String, String>
      {
        // 'Accept': 'application/json',
        //'Authorization': "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMjQ5ZDNmMzkxZDk4NDAxM2NmNjFhY2RhZWFmMjJiNWFjZGJhNjUwMTFjMGJmMTJiYzk3YjQ2MGVhNjJjNDQwMzEyNjMzMjUyOGRhZWI1YWQiLCJpYXQiOjE2MzE5NDM0MjAsIm5iZiI6MTYzMTk0MzQyMCwiZXhwIjoxNjYzNDc5NDIwLCJzdWIiOiI3MSIsInNjb3BlcyI6W119.g9IiPtB7ruBuNGOU7QjLhvV7LQYc5mbVIYlah3TMtN-NnbAYlpJOkxYyx2riWOnzk5PsYt5NPg_mjgGNmxCUTyFnvZ7egRNmFfiT2hJUKzd-u0IhALiknrSpGHiRfJ2AU-BOG833HBiV9KVqROpSgqKfcfY53ngUOBKmt7K7sblST1GCKgSsuTd7WM4E9awzwFE_OnekwDW04WgjsxgI-BOMq50BMX-9jSz1bg4_7YcaIq0drsZME7sv8anYANQCkAmOTBZou-ZOpoQ7KU5mXfCFC6GX8ErBZzAxtvA78o-dMt1SA2sIU7Vqv7HjURhAe2Txj4rwjsvwN8nLRizZ-eHl1BQSI9_jnIItC9ucqWcVFjB0_lKIkqYywcR741F3HIta4ZM3PmJiDVkl36RTBcvI-TLsjp8P6NIcdojYe22xbP9Vb9cP_rsBIbrb_sOFx1IzPPMdUk0zpiqWFNTPYg3S1pGrXhgTV-yngQg_EZ745tHguL0DaygB3LRMlldzX6NHKZ_6lOlH9qmclp_u44dCXIKIbF2onYwHu1aZGwCRWHbi4w8QZLtie08om8544pAnLCQv5w4AQJSHZlVd9prLwHEhcCsuxq1BTWlTJ3jZXwRk-sRMwJOE7rTNfHwiLYF3EcLepXdYEb1tUL6bSrynAssA9PJUfXKjt_GW3-o",
        'Authorization': "Bearer "+WelcomeScreen.userToken,
      },
    
    );
    // print(response.body);
    if(response.statusCode == 200){
      var categoryItems = json.decode(response.body)['data'];
      print("CateGory body//////////////////////////////////////////////////////////////////////////////////////////");
      print(categoryItems.toString());

      
      setState(() {
        categoryList = categoryItems;
        isLoading = false;
      });
    }else{
      categoryList = [];
      isLoading = false;
    }
  }

  Future<SliderImageModel> fetchSliderImage() async {
    setState(() {
      sliderList=[];
      isLoading = true;
    });
  
    var url= "https://admin.apanabazar.com/Api/view_slider";
    var response = await http.get(Uri.parse(url),
      headers:<String, String>
      {
        // 'Accept': 'application/json',
        'Authorization': 'Bearer '+WelcomeScreen.userToken,
      },
    
    );
    // print(response.body);
    if(response.statusCode == 200){
      var sliderImagess = json.decode(response.body)['data'][0]['images'];

      print('slider image');
      print(sliderImagess);
      
      setState(() {
        sliderList = sliderImagess;
        isLoading = false;
      });

      print('slider image2');
      print(sliderImagess);
      print(sliderList.toString());

      return SliderImageModel.fromJson(json.decode(response.body));
    }else{
      sliderList = [];
      isLoading = false;
    }
  }

  Future<DynamicListModel1> fetchPopular() async {
    setState(() {
      isLoading = true;
    });
  
    var url= "https://admin.apanabazar.com/Api/report_popular";
    var response = await http.get(Uri.parse(url),
      // headers:<String, String>
      // {
      //   // 'Accept': 'application/json',
      //   'Authorization': 'Bearer '+ WelcomeScreen.userToken,
      // },
    
    );
    // print(response.body);
    if(response.statusCode == 200){
      //var popular= json.decode(response.body)['data'];
      // var todayTrendImage = json.decode(response.body)['data'][0]['itemdetails'][0]['image'];
      var popular = json.decode(response.body)['data'][0]['itemdetails'];
      popularListName = json.decode(response.body)['data'][0]['trendname'];



        print("todayTrendValue");
        print(popular);
        
      
      setState(() {
        popularList = popular;
        isLoading = false;
      });

      print("todayTrendValue2");
      print(popularList);
      
      return DynamicListModel1.fromJson(json.decode(response.body));
     
    }else{
      popularList = [];
      isLoading = false;
    }
  }

  Future<DynamicListModel2> fetchTrending() async {
    setState(() {
      isLoading = true;
    });
  
    var url= "https://admin.apanabazar.com/Api/report_trending";
    var response = await http.get(Uri.parse(url),
      // headers:<String, String>
      // {
      //   // 'Accept': 'application/json',
      //   'Authorization': 'Bearer '+ WelcomeScreen.userToken,
      // },
    
    );
    // print(response.body);
    if(response.statusCode == 200){
      //var trending = json.decode(response.body)['data'];
      var trending = json.decode(response.body)['data'][0]['itemdetails'];
      tredingListName = json.decode(response.body)['data'][0]['trendname'];



      // var todayTrendValue = json.decode(response.body)['data'][0]['itemdetails'][0]['varientdetails']['variantdetails'][0]['variantvalue'];
      
      setState(() {
        tredingList = trending;
        isLoading = false;
      });

     return DynamicListModel2.fromJson(json.decode(response.body));
    }else{
      tredingList = [];
      isLoading = false;
    }
  }

  Future<DynamicListModel3> fetchCollection() async {
    setState(() {
      isLoading = true;
    });
  
    var url= "https://admin.apanabazar.com/Api/report_collection";
    var response = await http.get(Uri.parse(url),
      // headers:<String, String>
      // {
      //   // 'Accept': 'application/json',
      //   'Authorization': 'Bearer '+ WelcomeScreen.userToken,
      // },
    
    );
    // print(response.body);
    if(response.statusCode == 200){
      //var collections = json.decode(response.body)['data'];
      var collections = json.decode(response.body)['data'][0]['itemdetails'];
      collectionListName = json.decode(response.body)['data'][0]['trendname'];
      // var todayTrendValue = json.decode(response.body)['data'][0]['itemdetails'][0]['varientdetails']['variantdetails'][0]['variantvalue'];
      
      setState(() {
        collectionList = collections;
        isLoading = false;
      });

      return DynamicListModel3.fromJson(json.decode(response.body));

     
    }else{
      collectionList = [];
      isLoading = false;
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



  
//   Widget imageCarousel= new Container(
//     // decoration: BoxDecoration(
//     //   borderRadius: BorderRadius.only(topLeft: Radius.circular(90),topRight: Radius.circular(90))
//     // ),
//     height: 200,
//     child:  Carousel(
//       boxFit: BoxFit.cover,
//       items: <Widget>[
//             for (var i = 0; i < image.length; i++)
//               Container(
//                   margin: const EdgeInsets.only(top: 20.0, left: 20.0),
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: NetworkImage(image[i]),
//                       fit: BoxFit.fitHeight,
//                     ),
//                     // border:
//                     //     Border.all(color: Theme.of(context).accentColor),
//                     borderRadius: BorderRadius.circular(32.0),
//                   ),
// ;                ),                                     
//           ],
//       // images: [
//       //   AssetImage("assets/images/banner1.jpg"),
//       //   AssetImage("assets/images/banner2.jpg"),
//       //   AssetImage("assets/images/banner3.jpg"),
//       //   AssetImage("assets/images/banner4.jpg"),
//       //   AssetImage("assets/images/banner5.jpg"),
//       //   AssetImage("assets/images/banner6.png")
//       // ],
//       autoplay: true,
//       animationCurve: Curves.fastOutSlowIn,
//       animationDuration: Duration(milliseconds: 1000),
//       dotSize: 4.0,
//       indicatorBgPadding: 6.0,
//     ),
//   )

  Widget allCategoriesViewAll(){
    return Container(
      height: 30,
      width: double.infinity,
      padding: EdgeInsets.only(left: 10,right: 10,top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         
          Text("All Categories", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black87,fontFamily: 'RaleWay'),),
          // GestureDetector(
          //   onTap: () {
             
          //    // Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Categories()));
          //   },
          //   child: Text(
          //     "View All",
          //     style: TextStyle(
          //         fontWeight: FontWeight.bold,
          //         fontSize: 18.0,
          //         color: themColor),
          //   ),
          // ),
        ],
      ),
    );
  }

//     //Geo Address variables declaration Start
//   Future<LocationData> _getUserLocation;
//   LatLng _userLocation;
//   String _resultAddress;
//  //Geo Address variables declaration End

//  // Get User Location Start

//   Future<LocationData> getUserLocation() async {

//     Location location = new Location();  // Location Intialized
//     bool _serviceEnabled;
//     PermissionStatus _permissionGranted; //Permission declaraton

//     _serviceEnabled = await location.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await location.requestService();
//       if (!_serviceEnabled) {
//         return null;
//       }
//     }

//     _permissionGranted = await location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return null;
//       }
//     }

//     final result = await location.getLocation();
//     _userLocation = LatLng(result.latitude, result.longitude);

//     if (_userLocation != null) {
//       getSetAddress(
//         Coordinates(_userLocation.latitude, _userLocation.longitude)
//       );
//     }
//     return result;
//   }

//   getSetAddress(Coordinates coordinates) async {
//     final addresses =
//         await Geocoder.local.findAddressesFromCoordinates(coordinates);
//     setState(() {
//       _resultAddress = addresses.first.addressLine;

     
//     });
//   }
//   // Get User Location End
   
  @override
  void initState() {

    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

  
    //sliderList.length=0;
    // TODO: implement initState
    print("Token  testing"+WelcomeScreen.userToken.toString());
    categoryList=[];
    sliderList=[]; 
    popularList=[];
    tredingList=[];
    collectionList=[];

    // categoryList.add("");
    // sliderList.add("");
    // popularList.add("");
    // tredingList.add("");
    // collectionList.add("");
    
    fetchData();
  
    fetchSliderImage();

    Future.delayed(const Duration(seconds: 5), () { //asynchronous delay
      if (this.mounted) { //checks if widget is still active and not disposed
        setState(() { //tells the widget builder to rebuild again because ui has updated
          _visible=true; //update the variable declare this under your class so its accessible for both your widget build and initState which is located under widget build{}
        });
      }
    });
    
    
    super.initState();
    //BackButtonInterceptor.add(myInterceptor);
    timeNow = DateTime.now().hour;

    popularListName="";
    tredingListName="";
    collectionListName="";
    greetingMessage();
    
    fetchPopular();
    fetchTrending();
    fetchCollection();
    upDateGreetingMessageAccordingToTime();
   //  _getUserLocation = getUserLocation();
    fetchCartList();
    fetchWishList();
    // SharedPreferences.getInstance().then((SharedPreferences sp) {
    //   sp.getString("token");
    //   print("Init /////////////////////////"+sp.getString("token"));
    //   setState(() {});
    // });

    // SplashScreen.token=Login.token;
    // SplashScreen.userid=Login.userid.toString();
    //getLoginPrefs();
    //  print("checking init");
    //     print(SplashScreen.token);
    //     print(userid);
   // this.fetchData();
  }

  @override
  void dispose() {
    //BackButtonInterceptor.remove(myInterceptor);
    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top,SystemUiOverlay.bottom]);
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


  getLoginPrefs()async{
    SharedPreferences loginPrefs = await SharedPreferences.getInstance();
     setState(() {
        token=loginPrefs.getString("token");
        userid=loginPrefs.getString("userid");

        // print("checking one time");
        // print(token);
        // print(userid);
        // SplashScreen.token=token;
        // SplashScreen.userid=userid;
       // fetchUser();
     });

    //  print("checking out one time");
    //     print(token);
    //     print(userid);
       // getData();
        //fetchUser();
  }
  // getData(){
  //   fetchUser();
  // }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset : false,
      
      // appBar: AppBar(
        
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     children: [
      //       Text('Apana Bazar',style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontWeight: FontWeight.w800,fontSize: 25),),
      //     ]  
      //   ),
      //   backgroundColor: themColor,
      //   bottomOpacity: 0,
      //   elevation: 0.0,
      //   // leading: IconButton(
      //   //   icon: Icon(Icons.search,color: Colors.white,size: 30,),
      //   //   onPressed: (){
      //   //     //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
      //   //     Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> Search()));
      //   //   },
      //   // ),

      //   // actions: <Widget>[
      //   //   Row(
      //   //     mainAxisAlignment: MainAxisAlignment.end,
      //   //     children: [
      //   //       Container(
      //   //         child: Stack(
      //   //           children: <Widget>[
      //   //             Container(
      //   //               width: 80,
      //   //               height: 80,
      //   //               child: Stack(
      //   //                 children: <Widget>[
      //   //                   Icon(Icons.notifications,color: Colors.white)
      //   //                 ]
      //   //               )
      //   //             ),

      //   //             // Container(
      //   //             //   width: 80,
      //   //             //   height: 80,
      //   //             //   child: Stack(
      //   //             //     children: <Widget>[
      //   //             //       Icon(Icons.notifications,color: Colors.white)
      //   //             //     ]
      //   //             //   )
      //   //             // ),

      //   //             Container(
      //   //               width: 80,
      //   //               height: 80,
      //   //               child: Stack(
      //   //                 children: <Widget>[
      //   //                   Icon(Icons.notifications,color: Colors.yellow)
      //   //                 ]
      //   //               )
      //   //             )
      //   //           ]
      //   //         ),
      //   //       ),

      //   //        Container(
      //   //               width: 80,
      //   //               height: 80,
      //   //               child: Stack(
      //   //                 children: <Widget>[
      //   //                   Icon(Icons.notifications,color: Colors.yellow)
      //   //                 ]
      //   //               )
      //   //             ),

      //   //              Container(
      //   //               width: 80,
      //   //               height: 80,
      //   //               child: Stack(
      //   //                 children: <Widget>[
      //   //                   Icon(Icons.notifications,color: Colors.yellow)
      //   //                 ]
      //   //               )
      //   //             )
      //   //     ]
      //   //   )
      //   // ],
        

      // ),

      endDrawer: Container(
        width: MediaQuery.of(context).size.width*0.7,
        child: MyDrawer()
      ),

      body:
        NotificationListener<OverscrollIndicatorNotification>(  // disallow scrolling shadow
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return null;
          },
        
        
        
          child: CustomScrollView(
            slivers : <Widget>[

              // const SliverToBoxAdapter(
              //   child: SizedBox(
              //     height: 20,
              //     child: Center(
              //       child: Text('Scroll to see the SliverAppBar in effect.'),
              //     ),
              //   ),
              // ),
              SliverAppBar(
                snap: true,
                pinned: true,
                floating: true,
                iconTheme: IconThemeData(color: Colors.black), // for changing drawer icon color
                // bottom: PreferredSize(                       // Add this code
                //     preferredSize: Size.fromHeight(60.0),      // Add this code
                //     child: Text('Apana Bazar',style: TextStyle(fontSize: 30,fontWeight: FontWeight.w900,color: Colors.white,fontFamily: 'RaleWay')),                           // Add this code
                // ),  
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title:     
                //////////// Search Bar Start
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> Search()));
                          } ,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10,right: 10),
                            child: Container(
                              
                              height: 25,
                              width: MediaQuery.of(context).size.width/2.47,
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
                                    Icon(Icons.search,color: Colors.black45, size: 16,),
                                    Text("Search Here..", style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.black38,fontFamily: 'RaleWay'),),
                                  ],
                                ),
                              ),
                        
                            ),
                          ),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children:[
                          
                          Padding(
                            padding: EdgeInsets.only(right:0,top: 0),
                            child: InkWell(
                              onTap: (){
                                Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> WishList()));
                              },
                              child: Container(
                                width: 30,
                                height: 20,
                                child: Stack(
                                  children: <Widget>[
                                    Icon(Icons.favorite,color: Colors.brown,size: 20),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.amber),
                                        child: Center(
                                          child: Text(cartWishListCount.toString(),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black54,fontFamily: 'RaleWay')),
                                        ),
                                      )
                                    )
                                  ]
                                )
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 0,top: 0),
                            child: InkWell(
                              onTap: (){
                                Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> Cart()));
                              } ,
                              child: Container(
                                width: 30,
                                height: 20,
                                child: Stack(
                                  children: <Widget>[
                                    Icon(Icons.shopping_cart,color: Colors.brown,size: 20),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.amber),
                                        child: Center(
                                          child: Text(cartBadgeCount.toString(),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black54,fontFamily: 'RaleWay')),
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

                      
                    ]  
                  ),
                  ///////////// Search Bar end,
                  background: Image.asset(
                  "assets/images/home.jpg",
                    fit: BoxFit.cover,
                  ) //Images.network
                ), //FlexibleSpaceBar
                expandedHeight: 200,
                backgroundColor: themColor,
                // leading: IconButton(
                //   icon: Icon(Icons.menu),
                //   tooltip: 'Menu',
                //   onPressed: () {},
                // ), //IconButton
                // actions: <Widget>[
                //   IconButton(
                //     icon: Icon(Icons.comment),
                //     tooltip: 'Comment Icon',
                //     onPressed: () {},
                //   ), //IconButton
                //   IconButton(
                //     icon: Icon(Icons.settings),
                //     tooltip: 'Setting Icon',
                //     onPressed: () {},
                //   ), //IconButton
                // ], //<Widget>[]
              ),

              

              SliverFillRemaining(
                hasScrollBody: false,
              
                  
                child: Container(
                  child: Column(
                    children: [
                      // Expanded(
                        SingleChildScrollView(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                          // height: MediaQuery.of(context).size.height,
                            color: Colors.white,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 10,right: 10),
                                          child: Text("Hi , "+WelcomeScreen.userName+" "+"!!"+"   "+greetingMessageStatus ?? " ",style: TextStyle(color: Colors.black,fontSize: 18,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold))
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                      
                                SizedBox(
                                  height: 10,
                                ),
                                
                                ////// Carousel Slider Start ///////////
                                CarouselSlider(
                                  options: CarouselOptions(
                                    viewportFraction: 0.99,
                                    initialPage: 0,
                                    enableInfiniteScroll: true,
                                    scrollDirection: Axis.horizontal,
                                    //aspectRatio: 1.0,
                                    //viewportFraction: 0.6,
                                    autoPlayAnimationDuration: const Duration(milliseconds: 5),
                                    autoPlay: true,
                                    enlargeCenterPage: false,
                                    height: MediaQuery.of(context).size.height * 0.20,
                                    onPageChanged: (index, reason) {  // dot indicator ui
                                      setState(() {
                                        _current = index;
                                      });
                                    }
                                  ),
                                  items: sliderList
                                      .map(
                                        (item) => Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: 300,
                                          child: Image.network(
                                            item,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                                // Positioned(  // dot indicatot position below Carousel Slider
                                //   top: 50,
                                //   right: 10,
                                //   child: 
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: sliderList.map((url) {
                                      int index = sliderList.indexOf(url);
                                      return Container(
                                        width: 15.0,
                                        height: 10.0,
                                        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _current == index
                                            ? themColor
                                            : Color.fromRGBO(0, 0, 0, 0.4),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                //),
                                ////// Carousel Slider End ///////////
                                
                                allCategoriesViewAll(),
                                SizedBox(
                                  height: 5,
                                ),
                                
                                 ////////// All categories start
                                Row(
                                  children: [
                                    Container(
                                      child: SizedBox(
                                        height: MediaQuery.of(context).size.height/5,
                                        width: MediaQuery.of(context).size.width-25,
                                        child: ListView.builder(
                                        // shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: categoryList.length,
                                          itemBuilder: (BuildContext context, int index) => Padding(padding: EdgeInsets.only(left: 10),
                                            child: InkWell(
                                              onTap: (){
                                                // print("Cateegor   id");
                                                // print(categoryList[index]['id'].toString());
                                                Home.categoryId=categoryList[index]['id'];
                                                debugPrint(Home.categoryId.toString());
                                                Navigator.of(context,rootNavigator: true).push(MaterialPageRoute( builder: (context)=>SubCategory()));
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 2,right: 5),
                                                child: Card(
                                                  color: Colors.white,
                                                  elevation: 0,
                                                  shape: CircleBorder(),
                                                // shadowColor: themColor,
                                                  // shape: RoundedRectangleBorder(
                                                  //   borderRadius: BorderRadius.circular(60)
                                                  // ),
                                                  child: Container(
                                                    height: 0,
                                                    width: MediaQuery.of(context).size.width/5,
                                                    // decoration: BoxDecoration(
                                                    //   borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(0),bottomLeft: Radius.circular(0),bottomRight: Radius.circular(0)),
                                                    //   color: themColor,
                                                    // ),
                                                    child:Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(top: 4),
                                                          child: Container(
                                                            width: MediaQuery.of(context).size.width/3,
                                                            height: MediaQuery.of(context).size.height/9.9,
                                                            decoration: BoxDecoration(
                                                              color: themColor,
                                                              borderRadius: BorderRadius.circular(80),
                                                            ),
                                                            child: Card(
                                                              elevation: 5,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(80)
                                                              ),
                                                              child: Container(
                                                                height: MediaQuery.of(context).size.height/9.99,
                                                                //height: 120,
                                                                width: MediaQuery.of(context).size.width/5,
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [

                                                                    Image.network(categoryList[index]['image'],width: 35,height: 40)
                                                                   // Image.network(categoryList[index]['image'],width: MediaQuery.of(context).size.width/9.999,height: MediaQuery.of(context).size.height/9.999,)
                                                                    // ClipOval(
                                                                    //   child: Image.network(categoryList[index]['image'],width: 100,height: 50,)
                                                                    // )
                                                                    //Image.asset('assets/images/vegitable_icon.png',width: 30,height: 30,),
                                                                    //Icon(Icons.food_bank),
                                                                    //Text("food1")
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),


                                                        Text(categoryList[index]['name'] ?? "",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black54,fontSize: 16,fontFamily: 'RobotoMono',fontWeight: FontWeight.w800),)
                                                        
                                                        // SingleChildScrollView(
                                                        //   scrollDirection: Axis.horizontal,
                                                        //   child: Expanded(child: Text(categoryList[index]['name'] ?? "",style: TextStyle(color: Colors.black54,fontSize: 16,fontFamily: 'RobotoMono',fontWeight: FontWeight.w800),))
                                                        // ),
                                                        
                                                      ],
                                                    ),
                                                  ),   
                                                  // Center(child: Text(users[index]['categoryname'])),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                    ),
                                    
                                    categoryList.length>4 ?  Center(
                                      child: Container(color: Colors.transparent, child: Icon(Icons.keyboard_arrow_right,color: Colors.black54)))
                                      : Center(
                                      child: Container(color: Colors.transparent, child: Text("")))
                                  ]  
                                
                                ),
                                ////////// All categories end
                                
                                ///////////// DynamicList1 start
                                Padding(
                                  padding: EdgeInsets.only(left: 10,top: 10),
                                  child: Container(
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(popularListName ?? "", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black87,fontFamily: 'RaleWay'),),
                                      ],
                                    ),
                                  ),
                                ),
                                      
                                Row(
                                  children: [
                                    Container(
                                      child: SizedBox(
                                        height: 180,
                                        width: MediaQuery.of(context).size.width-25,
                                        child: ListView.builder(
                                          //shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: popularList.length,
                                          itemBuilder: (BuildContext context, int index) => Padding(padding: EdgeInsets.only(left: 10),
                                            child: InkWell(
                                              onTap: (){
                                            
                                                Home.itemId = popularList[index]['itemid'].toString();
                                                print("Cateegor   id");
                                                print(categoryList[index]['id'].toString());
                                                // Home.categoryId=categoryList[index]['id'];
                                                // debugPrint(Home.categoryId.toString());
                                                Navigator.of(context,rootNavigator: true).push(MaterialPageRoute( builder: (context)=>ItemDetailsModified()));
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 2,right: 5),
                                                child: Card(
                                                  color: Colors.white,
                                                  elevation: 0,
                                                  shape: CircleBorder(),
                                                // shadowColor: themColor,
                                                  // shape: RoundedRectangleBorder(
                                                  //   borderRadius: BorderRadius.circular(60)
                                                  // ),
                                                  child: Container(
                                                    height: 0,
                                                    width: 110,
                                                    // decoration: BoxDecoration(
                                                    //   borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(0),bottomLeft: Radius.circular(0),bottomRight: Radius.circular(0)),
                                                    //   color: themColor,
                                                    // ),
                                                    child:Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(top: 4),
                                                          child: Container(
                                                            width: 110,
                                                            height: 120,
                                                            decoration: BoxDecoration(
                                                              color: Colors.white60,
                                                              borderRadius: BorderRadius.circular(0), //for outer
                                                            ),
                                                            child: Card(
                                                              elevation: 5,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(0) // for card
                                                              ),
                                                              child: Container(
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [

                                                                    Image.network("https://admin.apanabazar.com/assets/thumbnails/${popularList[index]['image']}256X256.jpg",width: 100,height: 100,)
                                                                    // ClipOval(
                                                                    //   child: Image.network("https://admin.apanabazar.com/assets/thumbnails/${popularList[index]['image']}256X256.jpg",width: 100,height: 100,)
                                                                    // )
                                                                    //Image.asset('assets/images/vegitable_icon.png',width: 30,height: 30,),
                                                                    //Icon(Icons.food_bank),
                                                                    //Text("food1")
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),

                                                        
                                                        Expanded(
                                                          child: SingleChildScrollView(
                                                            scrollDirection: Axis.horizontal,
                                                            child: Text(popularList.length>0 ? popularList[index]['varientdetails']['variantdetails'][0]['variantvalue'].toString() : "",overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black54,fontSize: 14,fontFamily: 'RobotoMono',fontWeight: FontWeight.w800),)
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: SingleChildScrollView(
                                                            scrollDirection: Axis.horizontal,
                                                            child: Text("₹"+popularList[index]['saleprice'].toString() ?? "",style: TextStyle(color: Colors.black54,fontSize: 16,fontFamily: 'RobotoMono',fontWeight: FontWeight.w600),)
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),   
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    popularList.length>3 ?  
                                    Center(
                                      child: Container(color: Colors.transparent, child: Icon(Icons.keyboard_arrow_right,color: Colors.black54)))
                                    : Center(
                                      child: Container(color: Colors.transparent, child: Text("")))
                                  ]  
                                ),
                              
                                ///////////// DynamicList1 end
                                
                                ///////////// DynamicList2 start
                                Padding(
                                  padding: EdgeInsets.only(left: 10,top: 10),
                                  child: Container(
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(tredingListName.toString() ?? "", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black87,fontFamily: 'RaleWay'),),
                                      ],
                                    ),
                                  ),
                                ),
                                      
                                Row(
                                  children: [
                                    Container(
                                      child: SizedBox(
                                        height: 180,
                                        width: MediaQuery.of(context).size.width-25,
                                        child: ListView.builder(
                                        // shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: tredingList.length,
                                          itemBuilder: (BuildContext context, int index) => Padding(padding: EdgeInsets.only(left: 10),
                                            child: InkWell(
                                              onTap: (){
                                            
                                                Home.itemId =tredingList[index]['itemid'].toString();
                                                // print("Cateegor   id");
                                                // print(categoryList[index]['id'].toString());
                                                // Home.categoryId=categoryList[index]['id'];
                                                // debugPrint(Home.categoryId.toString());
                                                Navigator.of(context,rootNavigator: true).push(MaterialPageRoute( builder: (context)=>ItemDetailsModified()));
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 2,right: 5),
                                                child: Card(
                                                  color: Colors.white,
                                                  elevation: 0,
                                                  shape: CircleBorder(),
                                                // shadowColor: themColor,
                                                  // shape: RoundedRectangleBorder(
                                                  //   borderRadius: BorderRadius.circular(60)
                                                  // ),
                                                  child: Container(
                                                    height: 0,
                                                    width: 110,
                                                    // decoration: BoxDecoration(
                                                    //   borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(0),bottomLeft: Radius.circular(0),bottomRight: Radius.circular(0)),
                                                    //   color: themColor,
                                                    // ),
                                                    child:Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(top: 4),
                                                          child: Container(
                                                            width: 110,
                                                            height: 120,
                                                            decoration: BoxDecoration(
                                                              color: Colors.white60,
                                                              borderRadius: BorderRadius.circular(0), //for outer
                                                            ),
                                                            child: Card(
                                                              elevation: 5,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(0) // for card
                                                              ),
                                                              child: Container(
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Image.network("https://admin.apanabazar.com/assets/thumbnails/${tredingList[index]['image']}256X256.jpg",width: 100,height: 100,)
                                                                    
                                                                    // ClipOval(
                                                                    //   child: Image.network("https://admin.apanabazar.com/assets/thumbnails/${tredingList[index]['image']}256X256.jpg",width: 100,height: 100,)
                                                                    // )
                                                                    //Image.asset('assets/images/vegitable_icon.png',width: 30,height: 30,),
                                                                    //Icon(Icons.food_bank),
                                                                    //Text("food1")
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                        Expanded(
                                                          child: SingleChildScrollView(
                                                            scrollDirection: Axis.horizontal,
                                                            child: Text(tredingList.length>0 ? tredingList[index]['varientdetails']['variantdetails'][0]['variantvalue'].toString() : "",style: TextStyle(color: Colors.black54,fontSize: 14,fontFamily: 'RobotoMono',fontWeight: FontWeight.w800),)
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: SingleChildScrollView(
                                                            scrollDirection: Axis.horizontal,
                                                            child: Text("₹"+tredingList[index]['saleprice'].toString() ?? "",style: TextStyle(color: Colors.black54,fontSize: 16,fontFamily: 'RobotoMono',fontWeight: FontWeight.w600),)
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),   
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    tredingList.length>3 ?  
                                    Center(
                                      child: Container(color: Colors.transparent, child: Icon(Icons.keyboard_arrow_right,color: Colors.black54)))
                                    : Center(
                                      child: Container(color: Colors.transparent, child: Text("")))
                                  ]  
                                ),
                                /////////////DynamicList2 end
                              
                                ///////////// DynamicList3 start
                                Padding(
                                  padding: EdgeInsets.only(left: 10,top: 10),
                                  child: Container(
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(collectionListName.toString() ?? "", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black87, fontFamily: 'RaleWay'),),
                                      ],
                                    ),
                                  ),
                                ),
                                      
                                Row(
                                  children: [
                                    Container(
                                      child: SizedBox(
                                        height: 180,
                                        width: MediaQuery.of(context).size.width-25,
                                        child: ListView.builder(
                                        // shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: collectionList.length,
                                          itemBuilder: (BuildContext context, int index) => Padding(padding: EdgeInsets.only(left: 10),
                                            child: InkWell(
                                              onTap: (){
                                            
                                                Home.itemId =collectionList[index]['itemid'].toString();
                                                // print("Cateegor   id");
                                                // print(categoryList[index]['id'].toString());
                                                // Home.categoryId=categoryList[index]['id'];
                                                // debugPrint(Home.categoryId.toString());
                                                Navigator.of(context,rootNavigator: true).push(MaterialPageRoute( builder: (context)=>ItemDetailsModified()));
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 2,right: 5),
                                                child: Card(
                                                  color: Colors.white,
                                                  elevation: 0,
                                                  shape: CircleBorder(),
                                                // shadowColor: themColor,
                                                  // shape: RoundedRectangleBorder(
                                                  //   borderRadius: BorderRadius.circular(60)
                                                  // ),
                                                  child: Container(
                                                    height: 0,
                                                    width: 110,
                                                    // decoration: BoxDecoration(
                                                    //   borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(0),bottomLeft: Radius.circular(0),bottomRight: Radius.circular(0)),
                                                    //   color: themColor,
                                                    // ),
                                                    child:Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(top: 4),
                                                          child: Container(
                                                            width: 110,
                                                            height: 120,
                                                            decoration: BoxDecoration(
                                                              color: Colors.white60,
                                                              borderRadius: BorderRadius.circular(0),//for outer
                                                            ),
                                                            child: Card(
                                                              elevation: 5,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(0)  // for card
                                                              ),
                                                              child: Container(
                                                                
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [

                                                                    Image.network("https://admin.apanabazar.com/assets/thumbnails/${collectionList[index]['image']}256X256.jpg",width: 100,height: 100,)
                                                                    // ClipOval(
                                                                    //   child: Image.network("https://admin.apanabazar.com/assets/thumbnails/${collectionList[index]['image']}256X256.jpg",width: 100,height: 100,)
                                                                    // )
                                                                    //Image.asset('assets/images/vegitable_icon.png',width: 30,height: 30,),
                                                                    //Icon(Icons.food_bank),
                                                                    //Text("food1")
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                        Expanded(
                                                          child: SingleChildScrollView(
                                                            scrollDirection: Axis.horizontal,
                                                            child: Text(collectionList.length>0 ? collectionList[index]['varientdetails']['variantdetails'][0]['variantvalue'].toString() : "",style: TextStyle(color: Colors.black54,fontSize: 14,fontFamily: 'RobotoMono',fontWeight: FontWeight.w800),)
                                                          ),
                                                        ),
                                            
                                                        Expanded(
                                                          child: SingleChildScrollView(
                                                            scrollDirection: Axis.horizontal,
                                                            child: Text("₹"+collectionList[index]['saleprice'].toString() ?? "",style: TextStyle(color: Colors.black54,fontSize: 16,fontFamily: 'RobotoMono',fontWeight: FontWeight.w600),)
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),   
                                                      
                                                      // Center(child: Text(users[index]['categoryname'])),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    collectionList.length>=3 ?  
                                    Center(
                                      child: Container(color: Colors.transparent, child: Icon(Icons.keyboard_arrow_right,color: Colors.black54)))
                                    : Center(
                                      child: Container(color: Colors.transparent, child: Text("")))
                                  ]  
                                ),
                                ///////////// DynamicList3 end
                                
                                
                                      
                              ]  
                            ),
                          ),
                        ),
                    //  )
                    ],
                  ),
                ),
              )  
              
            ]

            
          
          ),

        ),
    );
      
      
    
  }

  
}