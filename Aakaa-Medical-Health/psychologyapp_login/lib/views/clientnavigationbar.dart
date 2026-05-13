import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psychologyapp_login/views/clientactivity.dart';
import 'package:psychologyapp_login/views/clientmenu.dart';
import 'package:psychologyapp_login/views/clientplan.dart';
import 'package:psychologyapp_login/views/clientprofile.dart';

class ClientNavigationBar extends StatefulWidget {
  final String email;
  const ClientNavigationBar({super.key, required this.email});

  @override
  State<ClientNavigationBar> createState() => _ClientNavigationBarState();
}

class _ClientNavigationBarState extends State<ClientNavigationBar>{
  int selectedindex = 0;
  late final List<Widget> _screens;

  @override
  void initState(){
    super.initState();
    _screens = [
      ClientMenu(email: widget.email),
      ClientActivity(),
      ClientPlan(),
      ClientProfile(email: widget.email, onNavigateToTab: navigateToTab),
    ];
  }

  void onItemTapped(int index){
    setState(() {
      selectedindex = index;
    });
  }

  void navigateToTab(int index){
    setState(() {
      selectedindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Crucial for glassmorphic/floating effect
      body: IndexedStack(
        index: selectedindex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        height: 85,
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF065643).withOpacity(0.12),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: const Color(0xFF065643).withOpacity(0.9),
              child: Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: BottomNavigationBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  type: BottomNavigationBarType.fixed,
                  currentIndex: selectedindex,
                  onTap: onItemTapped,
                  selectedItemColor: const Color(0xFFFFF7F5),
                  unselectedItemColor: const Color(0xFFFFF7F5).withOpacity(0.4),
                  showSelectedLabels: true,
                  showUnselectedLabels: false,
                  selectedFontSize: 12,
                  selectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.grid_view_rounded),
                      label: "Explore",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.analytics_outlined),
                      activeIcon: Icon(Icons.analytics_rounded),
                      label: "Activity",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.assignment_outlined),
                      activeIcon: Icon(Icons.assignment_rounded),
                      label: "Plan",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline_rounded),
                      activeIcon: Icon(Icons.person_rounded),
                      label: "Profile",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
