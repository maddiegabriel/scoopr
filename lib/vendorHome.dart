import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoopr/tabs/VendorMap.dart';
import 'package:scoopr/tabs/VendorProfile.dart';

class VendorHomePage extends StatefulWidget {
  @override
  _VendorHomePageState createState() => _VendorHomePageState();
}
class _VendorHomePageState extends State<VendorHomePage> with TickerProviderStateMixin{
  TabController tabController;
  int selectedIndex = 0;
  void onItemClicked(int index){
    setState((){
      selectedIndex = index;
      tabController.index = selectedIndex;
    });
  }

  @override
  void initState(){
    super.initState();
    // CAN ADD PROFILE TAB HERE
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose(){
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: tabController,
          children: <Widget>[
            VendorMapTab(),
            VendorProfileTab()
          ]
        ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(label: 'Map', icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: 'Profile', icon: Icon(Icons.person))
        ],
        currentIndex: selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.indigoAccent,
        type: BottomNavigationBarType.fixed,
        onTap: onItemClicked
      ),
    );
  }
}