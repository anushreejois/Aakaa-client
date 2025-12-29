import 'package:flutter/material.dart';
import 'package:psychologyapp_login/views/clientactivity.dart';
import 'package:psychologyapp_login/views/clientmenu.dart';
import 'package:psychologyapp_login/views/clientplan.dart';
import 'package:psychologyapp_login/views/clientprofile.dart';

class ClientNavigationBar extends StatefulWidget {
  final String loginemail;
  const ClientNavigationBar({super.key, required this.loginemail});

  @override
  State<ClientNavigationBar> createState() => _ClientNavigationBarState();
}

class _ClientNavigationBarState extends State<ClientNavigationBar>{
  int selectedindex = 0;
  late final List<Widget> _screens;

  @override
  void initState(){
    super.initState();
    _screens =
   [
    ClientMenu(email: widget.loginemail),
    ClientActivity(),
    ClientPlan(),
    ClientProfile()
  ];
  }

  void onItemTapped(int index){
    setState(() {
      selectedindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedindex,
        children: _screens,
      ),

      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedindex,
          onTap: onItemTapped,
          backgroundColor: Color(0xFFB3261E),
          selectedItemColor: Color(0xFFFFFFFF),
          unselectedItemColor: Color(0xFFD9D9D9),
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedIconTheme: IconThemeData(size: 35, opacity: 1.0),
          unselectedIconTheme: IconThemeData(size: 30, opacity: 0.7),
          selectedFontSize: 14,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          
          items:[
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined
            ), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.add_chart
            ), label: "Activity"),
            BottomNavigationBarItem(icon: Icon(Icons.add_card
            ), label: "My Plan"),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline
            ), label: "Profile")
          ]
        ),
      ),
    );
  }
}