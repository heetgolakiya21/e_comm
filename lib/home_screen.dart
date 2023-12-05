import 'package:e_comm/all_product_screen.dart';
import 'package:e_comm/cart_screen.dart';
import 'package:e_comm/seller_product_screen.dart';
import 'package:e_comm/themes.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    AllProductsPage(),
    SellerPage(),
    CartPage(),
  ];

  bool visible = true;

  void hideNavBar() {
    setState(() {
      visible = false;
    });
  }

  void showNavBar() {
    setState(() {
      visible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: AllProductsPage(showNevigation: showNavBar, hideNevigation: hideNavBar),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 700),
        height: visible ? kBottomNavigationBarHeight : 0,
        curve: Curves.fastLinearToSlowEaseIn,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: Colors.white,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: MyColors.grey,
            backgroundColor: Colors.white,
            color: MyColors.grey,
            tabs: [
              const GButton(
                icon: Icons.home_outlined,
                text: "Home",
              ),
              const GButton(
                icon: Icons.inventory_2_outlined,
                text: "Seller",
              ),
              GButton(
                icon: Icons.shopping_cart_outlined,
                text: "Cart",
                backgroundColor: MyColors.blue,
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
