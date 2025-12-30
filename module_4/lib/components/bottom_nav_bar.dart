import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../user_role.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onTap;
  final UserRole role;
  final VoidCallback? onMiddleButtonPressed;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.role,
    this.onTap,
    this.onMiddleButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    const double radius = 18;

    final destinations = role == UserRole.employee
        ? _employeeDestinations()
        : _recruiterDestinations();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 16,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(radius)),
            child: NavigationBar(
              height: 58,
              backgroundColor: Colors.white,
              elevation: 0,
              selectedIndex: selectedIndex,
              onDestinationSelected: onTap,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: destinations,
            ),
          ),
        ),

        /// Floating Action Button (RECRUITER ONLY)
        if (role == UserRole.recruiter)
          Positioned(
            top: -28,
            left: MediaQuery.of(context).size.width / 2 - 28,
            child: FloatingActionButton(
              heroTag: 'bottom_nav_fab',
              onPressed: onMiddleButtonPressed,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add),
            ),
          ),
      ],
    );
  }

  /// Employee Navbar 
  static List<NavigationDestination> _employeeDestinations() {
    return const [
      NavigationDestination(
        icon: Icon(CupertinoIcons.search),
        selectedIcon: Icon(CupertinoIcons.search),
        label: 'Discovery',
      ),
      NavigationDestination(
        icon: Icon(CupertinoIcons.briefcase),
        selectedIcon: Icon(CupertinoIcons.briefcase_fill),
        label: 'My Jobs',
      ),
      NavigationDestination(
        icon: Icon(CupertinoIcons.chat_bubble_text),
        selectedIcon: Icon(CupertinoIcons.chat_bubble_text_fill),
        label: 'Messages',
      ),
      NavigationDestination(
        icon: Icon(CupertinoIcons.person),
        selectedIcon: Icon(CupertinoIcons.person_fill),
        label: 'Profile',
      ),
    ];
  }

  /// Recruiter Navbar 
  static List<NavigationDestination> _recruiterDestinations() {
    return const [
      NavigationDestination(
        icon: Icon(CupertinoIcons.briefcase),
        selectedIcon: Icon(CupertinoIcons.briefcase_fill),
        label: 'Jobs',
      ),
      NavigationDestination(
        icon: Icon(CupertinoIcons.group),
        selectedIcon: Icon(CupertinoIcons.group_solid),
        label: 'Company',
      ), 
      NavigationDestination(
        icon: SizedBox.shrink(), // FAB space
        label: '',
      ),
      NavigationDestination(
        icon: Icon(CupertinoIcons.chat_bubble_text),
        selectedIcon: Icon(CupertinoIcons.chat_bubble_text_fill),
        label: 'Messages',
      ),
      NavigationDestination(
        icon: Icon(CupertinoIcons.person),
        selectedIcon: Icon(CupertinoIcons.person_fill),
        label: 'Profile',
      ),
    ];
  }
}

