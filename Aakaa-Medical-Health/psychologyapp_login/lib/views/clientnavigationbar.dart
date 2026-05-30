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
      const ClientActivity(),
      const ClientPlan(),
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
      body: Stack(
        children: [
          Positioned.fill(
            child: IndexedStack(
              index: selectedindex,
              children: _screens,
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: Container(
              height: 88,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF065643).withValues(alpha: 0.12),
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
                    color: const Color(0xFF065643).withValues(alpha: 0.9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(
                          0,
                          Icons.grid_view_rounded,
                          Icons.grid_view_rounded,
                          "Explore",
                        ),
                        _buildNavItem(
                          1,
                          Icons.analytics_outlined,
                          Icons.analytics_rounded,
                          "Activity",
                        ),
                        _buildNavItem(
                          2,
                          Icons.assignment_outlined,
                          Icons.assignment_rounded,
                          "Plan",
                        ),
                        _buildNavItem(
                          3,
                          Icons.person_outline_rounded,
                          Icons.person_rounded,
                          "Profile",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData unselectedIcon,
    IconData selectedIcon,
    String label,
  ) {
    final bool isSelected = selectedindex == index;
    final Color color = isSelected
        ? const Color(0xFFFFF7F5)
        : const Color(0xFFFFF7F5).withValues(alpha: 0.4);

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onItemTapped(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : unselectedIcon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
