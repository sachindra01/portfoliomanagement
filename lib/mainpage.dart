import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio_management/controller/stock_controller.dart';
import 'package:portfolio_management/views/dashboard.dart';
import 'package:portfolio_management/views/stock_view.dart';

class MyNavigationBar extends StatefulWidget {  
  const MyNavigationBar ({Key? key}) : super(key: key);  
  
  @override  
  // ignore: library_private_types_in_public_api
  _MyNavigationBarState createState() => _MyNavigationBarState();  
}  
  
class _MyNavigationBarState extends State<MyNavigationBar > {  
   final StockManageController stockManageController = Get.put(StockManageController());
  int _selectedIndex = 0;  
  static const List<Widget> _widgetOptions = <Widget>[  
  StockManage(),
  DashBoard(),
  ];  
  
  void _onItemTapped(int index) {  
    setState(() {  
      _selectedIndex = index;  
    if(index==1){
      stockManageController.isLoading.value==false;
      
    }
    });  
  }  
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      body: Center(  
        child: _widgetOptions.elementAt(_selectedIndex),  
      ),  
      bottomNavigationBar: BottomNavigationBar(  
        items: const <BottomNavigationBarItem>[  
          BottomNavigationBarItem(  
            icon: Icon(Icons.list),  
            label: 'Portlolio',  
            backgroundColor: Colors.blueGrey  
          ),  
          BottomNavigationBarItem(  
            icon: Icon(Icons.dashboard),  
            label: 'Dashboard',  
            backgroundColor: Colors.blueGrey
          ),  
        ],  
        type: BottomNavigationBarType.shifting,  
        currentIndex: _selectedIndex,  
        selectedItemColor: Colors.black,  
        iconSize: 40,  
        onTap: _onItemTapped,  
        elevation: 5  
      ),  
    );  
  }  
}  