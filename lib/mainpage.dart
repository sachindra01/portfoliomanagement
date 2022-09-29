import 'package:flutter/material.dart';
import 'package:portfolio_management/dashboard.dart';
import 'package:portfolio_management/home.dart';

class MyNavigationBar extends StatefulWidget {  
  const MyNavigationBar ({Key? key}) : super(key: key);  
  
  @override  
  // ignore: library_private_types_in_public_api
  _MyNavigationBarState createState() => _MyNavigationBarState();  
}  
  
class _MyNavigationBarState extends State<MyNavigationBar > {  
  int _selectedIndex = 0;  
  static const List<Widget> _widgetOptions = <Widget>[  
   DashBoard(),
    Home()
  ];  
  
  void _onItemTapped(int index) {  
    setState(() {  
      _selectedIndex = index;  
    });  
  }  
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(  
        centerTitle: true,
        title: const Text('Portfolio Management'),  
          backgroundColor: Colors.blueGrey
      ),  
      body: Center(  
        child: _widgetOptions.elementAt(_selectedIndex),  
      ),  
      bottomNavigationBar: BottomNavigationBar(  
        items: const <BottomNavigationBarItem>[  
          BottomNavigationBarItem(  
            icon: Icon(Icons.dashboard),  
            label: 'DashBoard',  
            backgroundColor: Colors.blueGrey  
          ),  
          BottomNavigationBarItem(  
            icon: Icon(Icons.list),  
            label: 'Portfolio',  
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