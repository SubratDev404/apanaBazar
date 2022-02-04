

import 'package:apanabazar/onboarding/NewOnBoarding/onboardingcontent.dart';
import 'package:flutter/material.dart';



class Utils {

  static GlobalKey<NavigatorState> mainListNav = GlobalKey();
  static GlobalKey<NavigatorState> mainAppNav = GlobalKey();
  
  static List<OnboardingContent> getOnboarding() {
    return [
      OnboardingContent(
        message: 'We Are Providing Best Quality of Grocessaries Of Your Choices',
        img: 'onboarding1'
      ),
      OnboardingContent(
        message: 'We Are Providing Home Delivery',
        img: 'onboarding2'
      ),
      OnboardingContent(
        message: 'Apana Bazar Takes Care Of Its Customers values',
        img: 'onboarding3'
      )
    ];
  }

 
}