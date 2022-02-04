import 'dart:convert';
import 'dart:io';
import 'package:apanabazar/Bloc/UpdateAddressBloc.dart';
import 'package:apanabazar/Drawer.dart';
import 'package:apanabazar/Model/UpdateAddressModel.dart';
import 'package:apanabazar/Screens/Address/AddressList/AddressList.dart';
import 'package:apanabazar/Screens/WelComeScreen/WelcomeScreen.dart';
import 'package:apanabazar/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdateAddress extends StatelessWidget {

  static int radioButtonid=1;
  static String fulladdress,additionalinfo,pincode;
  static int userid;
  
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
      home: CreateAddressScreen(),
      
    );
  }
}

class CreateAddressScreen extends StatefulWidget {
  

  @override
  _CreateAddressScreenState createState() => _CreateAddressScreenState();
}

class ReciveAddressList {
  String name;
  int index;
  ReciveAddressList({this.name, this.index});
}

class _CreateAddressScreenState extends State<CreateAddressScreen> {

  TextEditingController fullAddressController; 
  TextEditingController additionalAddressController;
  TextEditingController pincodeController; 

  Future<UpdateAddressModel> updateAddressProcess() async {
    var createAddress_url='https://api.apanabazar.com/api/updateaddress/'+AddressList.addressListItemId.toString();
    final http.Response response = await http.post(
        Uri.parse(createAddress_url),
        headers: <String, String>{
          // 'Accept': 'application/json',
         // 'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer'+' '+WelcomeScreen.userToken,
        },

        body: json.encode({
          'pinCode': pincodeController.text.toString(),
          'fullAddress': fullAddressController.text.toString(),
          'additionalInfo': additionalAddressController.text.toString(),
          'addressType' : UpdateAddress.radioButtonid.toString()

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
      return UpdateAddressModel.fromJson(json.decode(response.body));
    } else {
   // print("error enter ed");

     // throw Exception('Failed to create album.');
    }
  }

  

  // Default Radio Button Item
  String radioItem = 'Home';
   
  // Group Value for Radio Button.
  int id = 1;
  
  List<ReciveAddressList> fList = [
    ReciveAddressList(
      index: 1,
      name: "Home",
    ),
    ReciveAddressList(
      index: 2,
      name: "Office",
    ),
    
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //BackButtonInterceptor.add(myInterceptor);
    UpdateAddress.radioButtonid=1;

    print("ppppppppppppppppppppppp"+ AddressList.pincode.toString());

    fullAddressController = new TextEditingController(text: AddressList.fullAddress.toString());
    additionalAddressController = new TextEditingController(text: AddressList.landMarkAddress.toString());
    pincodeController = new TextEditingController(text: AddressList.pincode.toString());


    
  }

  @override
  void dispose() {
    //BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
    fullAddressController.dispose();
    additionalAddressController.dispose();
    pincodeController.dispose();
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
    
    final bloc = Bloc();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: themColor,
        elevation: 0.0,
        title: Center(child: Text('Update Address',style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontWeight: FontWeight.w800,fontSize: 20),),),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
          onPressed: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>ItemList()));
            Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>AddressList()));
          },
        ),
      ),
      
      
      endDrawer: Container(
        width: MediaQuery.of(context).size.width*0.7,
        child: MyDrawer()
      ),

      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: themColor
          ),

          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                color: Colors.white
              ),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
    
                    // SizedBox(
                    //   height: 30
                    // ),
    
                    Expanded(
                      child: SingleChildScrollView(
                       // reverse: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
    
                            SizedBox(
                              height: 30.0,
                            ),

                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text("Full Address: ",style: TextStyle(color:Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                            ),
                            
                            Padding(
                              padding: EdgeInsets.only(left: 10,right: 10),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                                  color: Colors.black54
                                ),
                              ),
                            ),
    
                            Padding(
                              padding: EdgeInsets.only(left: 0,right: 0),
                              child: StreamBuilder<String>(
                                stream: bloc.fullAddress,
                                builder: (context, snapshot) => Container(
                                  height: 180,
                                  //color: Color(0xffeeeeee),
                                  color: Colors.white,
                                  padding: EdgeInsets.all(10.0),
                                  child: new ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: 180.0,
                                    ),
                                    child: new Scrollbar(
                                      child: new SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        reverse: true,
                                        child: SizedBox(
                                          height: 160.0,
                                          child: new TextField(
                                           // initialValue: AddressList.fullAddress.toString(),
                                            maxLength: 500,
                                            maxLengthEnforced: true,
                                            maxLines: 100,
                                            onChanged: bloc.fullAddressChanged,
                                            controller: fullAddressController,
                                            decoration: new InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: "Enter Your Full Address",
                                              labelText: "Full Address",
                                              errorText: snapshot.error,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              ),
                            ),

                            SizedBox(
                              height: 10.0,
                            ),

                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text("LandMark Address: ",style: TextStyle(color:Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                            ),
                           
                            Padding(
                              padding: EdgeInsets.only(left: 10,right: 10),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                                  color: Colors.black54
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(left: 0,right: 0),
                              child: StreamBuilder<String>(
                                stream: bloc.additionalAddress,
                                builder: (context, snapshot) =>  Container(
                                  height: 140,
                                  //color: Color(0xffeeeeee),
                                  color: Colors.white,
                                  padding: EdgeInsets.all(10.0),
                                  child: new ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: 120.0,
                                    ),
                                    child: new Scrollbar(
                                      child: new SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        reverse: true,
                                        child: SizedBox(
                                          height: 120.0,
                                          child: new TextField(
                                           // initialValue: AddressList.landMarkAddress.toString(),
                                            maxLines: 80,
                                            onChanged: bloc.additionalAddressChanged,
                                            controller: additionalAddressController,
                                            decoration: new InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: "Enter Your LandMark Address",
                                              labelText: "LandMark Address",
                                              errorText: snapshot.error,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text("Pincode: ",style: TextStyle(color:Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                            ),
                            
                            Padding(
                              padding: EdgeInsets.only(left: 10,right: 10),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                                  color: Colors.black54
                                ),
                              ),
                            ),
                            
                            SizedBox(
                              height: 10,
                            ),

                            Padding(
                              padding: EdgeInsets.only(left: 10,right: 10),
                              child: StreamBuilder<String>(
                                stream: bloc.pincode,
                                builder: (context, snapshot) => TextField(
                                 // initialValue: AddressList.pincode.toString(),
                                  maxLength: 6,
                                  maxLengthEnforced: true,
                                  //onChanged: bloc.emailChanged,
                                  onChanged: bloc.pincodeChanged,
                                  controller: pincodeController,
                                  keyboardType: TextInputType.number,
                                  //controller: emailOrMobileController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Enter Pincode",
                                    labelText: "Pincode",
                                    errorText: snapshot.error
                                  ),
                                ),
                              ),
                            ),
    
                            SizedBox(
                              height: 10.0,
                            ),

                            Padding(
                              padding : EdgeInsets.only(left: 20,right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Delivery Address: ', style: TextStyle(fontSize: 18,color: Colors.black54, fontFamily: 'RaleWay',fontWeight: FontWeight.w800)),
                                  Text('$radioItem', style: TextStyle(fontSize: 19,color: Colors.black54, fontFamily: 'RaleWay',fontWeight: FontWeight.bold)),
                                  //Text(CreateAddress.radioButtonid.toString(), style: TextStyle(fontSize: 19))

                                ],
                              ),
                              //child: Text('Receving Address: $radioItem', style: TextStyle(fontSize: 23))
                            ),
                  
                            //Expanded(
                            Container(
                              height: 120.0,
                              child: Column(
                                children: 
                                  fList.map((data) => RadioListTile(
                                    title: Text("${data.name}",style: TextStyle(fontSize: 18,color: Colors.black54, fontFamily: 'RaleWay',fontWeight: FontWeight.w800)),
                                    groupValue: id,
                                    value: data.index,
                                    onChanged: (val) {
                                      setState(() {
                                        radioItem = data.name ;
                                        id = data.index;
                                        UpdateAddress.radioButtonid=id;
                                       // print("checking"+CreateAddress.radioButtonid.toString());
                                      });
                                    },
                                  )).toList(),
                              ),
                            ),
                           // ),

                            Padding(
                              padding: EdgeInsets.only(left: 10,right: 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width/1.05,

                                child: ElevatedButton.icon(
                              
                                  style: ElevatedButton.styleFrom(
                                    primary: themColor,
                                    onPrimary: Colors.white,
                                    shadowColor: Colors.black54,
                                    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                    elevation: 10,
                                  ),
                                  icon: Icon(Icons.location_city),
                                  label: Text('Update Address', style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                  onPressed: 
                                     //snapshot.hasData
                                       //? 
                                       () async{
                                            
                                        try{
                                  
                                          var response= await updateAddressProcess();
                                         
                                  
                                          bool res=response.response;
                                          var message=response.message;
                                          // UpdateAddress.fulladdress=response.data..toString();
                                          // UpdateAddress.additionalinfo=response.data.additionalinfo.toString();
                                          // UpdateAddress.pincode=response.data.pincode.toString();
                                          // UpdateAddress.userid=response.data.id;
                                          
                                          
                                          // print("Create Address");
                                        
                                         
                                          // print(response.message);
                                          // print(CreateAddress.fulladdress.toString());
                                          // print(CreateAddress.additionalinfo.toString());
                                          // print(CreateAddress.userid.toString());
                                          // print(CreateAddress.radioButtonid.toString());
                                  
                                          if(res==true){
                                  
                                            Fluttertoast.showToast(
                                              msg: message,
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.green,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                            );
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> AddressList()));
                                          }
                                  
                                          else if(res==false){
                                            Fluttertoast.showToast(
                                              msg: "Updation of Address Failed",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.green,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                            );
                                          }
                                          else{
                                  
                                          }
                                        }
                                        catch(err){
                                          Fluttertoast.showToast(
                                            msg: "Check Credentials",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                          );
                                  
                                        }
                                      },
                                     // : null,
                                
                                ),
                              ),
                            ),
    
                            // Center(
                            //   child: ButtonTheme(
                            //     minWidth: MediaQuery.of(context).size.width/2,
                            //     height: 40.0,
                            //     child: StreamBuilder<bool>(
                            //      stream: bloc.submitCheck,
                            //       builder: (context, snapshot) => RaisedButton(
                                   
                                
                            //         color: themColor,
                            //   //       // onPressed: snapshot.hasData
                            //   //       //     ? () => changeThePage(context)
                            //   //       //     : null,
                            //   //           //  onPressed: snapshot.hasData
                            //   //           // ? () => bloc.submit()
                            //   //           // : null,
                                      
                            //         onPressed: 
                            //         //snapshot.hasData
                            //          //? 
                            //          () async{
                                          
                            //           try{
                                
                            //             var response= await createAddressProcess();
                                       
                                
                            //             bool res=response.response;
                            //             var message=response.message;
                            //             CreateAddress.fulladdress=response.data.fulladdress.toString();
                            //             CreateAddress.additionalinfo=response.data.additionalinfo.toString();
                            //             CreateAddress.pincode=response.data.pincode.toString();
                            //             CreateAddress.userid=response.data.id;
                                        
                                        
                            //             // print("Create Address");
                                      
                                       
                            //             // print(response.message);
                            //             // print(CreateAddress.fulladdress.toString());
                            //             // print(CreateAddress.additionalinfo.toString());
                            //             // print(CreateAddress.userid.toString());
                            //             // print(CreateAddress.radioButtonid.toString());
                                
                            //             if(res==true){
                                
                            //               Fluttertoast.showToast(
                            //                 msg: message,
                            //                 toastLength: Toast.LENGTH_SHORT,
                            //                 gravity: ToastGravity.CENTER,
                            //                 timeInSecForIosWeb: 1,
                            //                 backgroundColor: Colors.green,
                            //                 textColor: Colors.white,
                            //                 fontSize: 16.0
                            //               );
                            //               Navigator.push(context, MaterialPageRoute(builder: (context)=> AddressList()));
                            //             }
                                
                            //             else if(res==false){
                            //               Fluttertoast.showToast(
                            //                 msg: "Creation of Address Failed",
                            //                 toastLength: Toast.LENGTH_SHORT,
                            //                 gravity: ToastGravity.CENTER,
                            //                 timeInSecForIosWeb: 1,
                            //                 backgroundColor: Colors.green,
                            //                 textColor: Colors.white,
                            //                 fontSize: 16.0
                            //               );
                            //             }
                            //             else{
                                
                            //             }
                            //           }
                            //           catch(err){
                            //             Fluttertoast.showToast(
                            //               msg: "Check Credentials",
                            //               toastLength: Toast.LENGTH_SHORT,
                            //               gravity: ToastGravity.CENTER,
                            //               timeInSecForIosWeb: 1,
                            //               backgroundColor: Colors.red,
                            //               textColor: Colors.white,
                            //               fontSize: 16.0
                            //             );
                                
                            //           }
                            //         },
                            //        // : null,
                            //          child: Text("Save Address", style: TextStyle( fontSize: 17,fontWeight: FontWeight.bold,color: Colors.white),),
                            //        ),
                            //     ),
                            //   ),
                            // ),
    
                          ],
                        ),
                      )
                    )
                  ],
                )
            ),
          )
        ],
      ),
      
    );
  }
}