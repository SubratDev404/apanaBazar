

import 'package:apanabazar/Screens/LoginRegistration/Login.dart';
import 'package:apanabazar/constants/constants.dart';
import 'package:apanabazar/onboarding/NewOnBoarding/mainappbar.dart';
import 'package:apanabazar/onboarding/NewOnBoarding/onboardingcontent.dart';
import 'package:apanabazar/onboarding/utils.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  List<OnboardingContent> _content = Utils.getOnboarding();
  int pageIndex = 0;
  PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
   // BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
   // BackButtonInterceptor.remove(myInterceptor);
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
      appBar: MainAppBar(),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (int page) {
                    setState(() {
                      pageIndex = page;
                    });
                  },
                  children: List.generate(
                    _content.length,
                    (index) => 
                    Container(
                      padding: EdgeInsets.all(40),
                      margin: EdgeInsets.only(left: 40, right: 40, top: 40, bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: themColor.withOpacity(0.3),
                            blurRadius: 20,
                            offset: Offset.zero
                          )
                        ]
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  // child: IconFont(
                                  //   color: AppColors.MAIN_COLOR,
                                  //   iconName: IconFontHelper.LOGO,
                                  //   size: 40
                                  // ),
                                ),
                                Image.asset('assets/images/${_content[index].img}.gif'),
                                SizedBox(height: 20),
                                Text(_content[index].message,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: themColor,
                                    fontSize: 20,fontFamily: 'RaleWay',fontWeight: FontWeight.w800,
                                  )
                                )
                              ],
                            ),
                          ),
                          Visibility(
                            visible: index == _content.length - 1,
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.keyboard_arrow_right),
                              label: Text('Next', style: TextStyle(color: Colors.white, fontSize: 20,fontFamily: 'RaleWay',fontWeight: FontWeight.w800,),),
                              style: ElevatedButton.styleFrom(
                                primary: themColor,
                                onPrimary: Colors.white,
                                shadowColor: Colors.white60,
                                shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                elevation: 10,
                              ),
                              onPressed: () {
                               // Navigator.of(context,rootNavigator: false).push(MaterialPageRoute(builder: (context)=>CurvedBottomNavigationBar()));
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                                
                              }
                            ),
                            //child: Text("next"),
                            // child: ThemeButton(
                            //   onClick: () {
                            //     Utils.mainAppNav.currentState!.pushNamed('/mainpage');
                            //   },
                            //   label: 'Entrar Ahora!',
                            //   color: AppColors.DARK_GREEN,
                            //   highlight: AppColors.DARKER_GREEN,
                            // ),
                          )
                        ],
                      )
                    )
                  ),
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                _content.length,
                (index) => 
                  GestureDetector(
                    onTap: () {
                      _controller.animateTo(
                        MediaQuery.of(context).size.width * index,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut
                      );
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: themColor,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          width: 6,
                          color: pageIndex == index ? themColor : Theme.of(context).canvasColor
                        )
                      ),
                    ),
                  )
                )
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Icon(Icons.home_outlined,size: 40,),
                style: ElevatedButton.styleFrom(
                  primary: themColor,
                  onPrimary: Colors.white,
                  shadowColor: Colors.white60,
                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                  elevation: 10,
                ),
                onPressed: () {
                 // Navigator.of(context,rootNavigator: false).push(MaterialPageRoute(builder: (context)=>CurvedBottomNavigationBar()));
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                  
                }
              ),
              // ThemeButton(
              //   onClick: () {
              //     Utils.mainAppNav.currentState!.pushNamed('/mainpage');
              //   },
              //   label: 'Saltar Onboarding'
              // )
            ],
          ),
        )
      )
    );
  }
}