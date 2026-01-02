import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Pages
import 'job_posting_management/discovery_page.dart';
import 'job_posting_management/jobs_posts.dart';
import 'job_posting_management/my_jobs_page.dart';
import 'job_posting_management/create_job_page.dart';
import 'job_posting_management/company_profile_page.dart';
import 'job_posting_management/dummy_company_profile.dart';
import 'matching_chatting/message_page.dart';
import 'authentication_profile/profile_page.dart';
import 'payment_rating/withdraw_earning_page.dart';
import 'payment_rating/employer_transfer_page.dart';
import 'payment_rating/earnings_history_page.dart';
import 'payment_rating/employer_review_page.dart';

// Components / helpers
import 'components/bottom_nav_bar.dart';
import 'navigation_helper.dart';
import 'user_role.dart';

/// This is used across the app (if you already have it in user_role.dart, remove this)
UserRole currentUserRole = UserRole.employee;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RoleSelectionPage(),
      
      routes: {
        // =========================
        // Employee
        // =========================
        '/discovery': (context) => const DiscoveryPage(),
        '/my_jobs': (context) => const MyJobsPage(),

        // =========================
        // Recruiter
        // =========================
        '/jobs': (context) => const JobPostingPage(),
        '/create_job': (context) => const CreateJobPage(),

        // If you still need company profile route
        '/company': (context) =>
            CompanyProfilePage(company: dummyCompanies[0]),

        // =========================
        // Shared
        // =========================
        '/messages': (context) => const MessagePage(),
        '/profile': (context) => const ProfilePage(),

        // =========================
        // Payment/Rating
        // =========================
        '/withdraw_earning': (context) => const WithdrawEarningPage(),
        '/employer_transfer': (context) => const EmployerTransferPage(),
        '/earnings_history': (context) => const EarningsHistoryPage(),
        '/employer_review': (context) => const EmployerReviewPage(),
      },
    );
  }
}

// ==========================
// ROLE SELECTION PAGE
// ==========================
class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  void _goToRole(BuildContext context, UserRole role) {
    currentUserRole = role;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => RootPage(role: role),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 251),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1E3C),
        elevation: 0,
        title: const Text(
          'Job Seeking App',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 21, 36, 69),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => _goToRole(context, UserRole.employee),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 39, 39, 215),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'I am an Employee (Job Seeker)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _goToRole(context, UserRole.recruiter),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 138, 80),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'I am a Recruiter (Hiring Company/HR)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================
// ROOT PAGE (Role-Aware)
// ==========================
class RootPage extends StatefulWidget {
  final UserRole role;
  const RootPage({super.key, required this.role});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Navigate once to the initial page for the role
      NavigationHelper.navigate(context, _selectedNavIndex, widget.role);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedNavIndex,
        role: widget.role,
        onTap: (index) {
          setState(() => _selectedNavIndex = index);

          // If recruiter tapped FAB slot (index 2), don't navigate
          if (widget.role == UserRole.recruiter && index == 2) return;

          NavigationHelper.navigate(context, index, widget.role);
        },
        onMiddleButtonPressed: () {
          // Recruiter FAB action
          NavigationHelper.handleFab(context);
        },
      ),
    );
  }
}
