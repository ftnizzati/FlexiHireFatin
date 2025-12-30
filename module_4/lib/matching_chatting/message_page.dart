import 'package:flutter/material.dart';
import 'package:module_4/user_role.dart';
import '../components/bottom_nav_bar.dart';
import '../navigation_helper.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  int _navIndexForMessage(UserRole role) {
    return role == UserRole.employee ? 2 : 3;
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = _navIndexForMessage(currentUserRole);


    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 251),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1E3C),
        elevation: 0,
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Your Messages',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Chat with employers and colleagues',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: selectedIndex,
        role: currentUserRole,
        onTap: (index) => NavigationHelper.navigateBottomTab(context, index, currentUserRole),
        onMiddleButtonPressed: () => NavigationHelper.onMiddlePressed(context, currentUserRole),
      ),
    );
  }
}
