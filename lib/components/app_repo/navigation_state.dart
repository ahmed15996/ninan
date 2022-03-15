
import 'package:flutter/material.dart';
import 'package:ninan/screens/account/account_screen.dart';
import 'package:ninan/screens/cart/cart_screen.dart';
import 'package:ninan/screens/favourite/favourite_screen.dart';
import 'package:ninan/screens/home/home_screen.dart';
import 'package:ninan/screens/offers/offers_screen.dart';
import 'package:ninan/screens/orders/orders_screen.dart';


class NavigationState extends ChangeNotifier {

    int _navigationIndex = 0 ;


  void upadateNavigationIndex(int value ){
    _navigationIndex = value;
    notifyListeners();
  }

  int get navigationIndex => _navigationIndex;


    List<Widget> _screens = [
    HomeScreen(),
    OrdersScreen(),
      OffersScreen(),
    FavouriteScreen(),

    AccountScreen()
  
  ];
  
  Widget get  selectedContent => _screens[_navigationIndex];

}