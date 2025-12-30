import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';
import '../user_role.dart';
import 'job_application.dart';
import 'dummy_my_jobs.dart';
import 'my_job_application.dart';
import '../navigation_helper.dart';

class MyJobsPage extends StatefulWidget {
  const MyJobsPage({super.key});

  @override
  State<MyJobsPage> createState() => _MyJobsPageState();
}

class _MyJobsPageState extends State<MyJobsPage> {
  int _selectedNavIndex = 1;

  @override
  Widget build(BuildContext context) {
    final currentJobs =
        myJobsDummy.where((j) => j.status == JobStatus.hired).toList();

    final applications =
        myJobsDummy.where((j) => j.status == JobStatus.applied).toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 251),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1E3C),
        title: const Text('My Jobs', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle('Current Jobs'),
          currentJobs.isEmpty
              ? _emptyText('No active jobs')
              : Column(
                  children: currentJobs.map(_jobCard).toList(),
                ),
          const SizedBox(height: 20),
          _sectionTitle('Applications'),
          applications.isEmpty
              ? _emptyText('No applications yet')
              : Column(
                  children: applications.map(_jobCard).toList(),
                ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedNavIndex,
        role: currentUserRole,
        onTap: (index) {
          setState(() => _selectedNavIndex = index);
          NavigationHelper.navigate(context, index, currentUserRole);
        },
        onMiddleButtonPressed: () {
          NavigationHelper.handleFab(context);
        },
      ),
    );
  }

  Widget _jobCard(MyJobApplication app) {
    final statusMap = {
      JobStatus.applied: ('Applied', Colors.orange),
      JobStatus.hired: ('Hired', Colors.green),
      JobStatus.rejected: ('Rejected', Colors.red),
    };

    final status = statusMap[app.status]!;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  app.jobTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: status.$2.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status.$1,
                  style: TextStyle(
                    color: status.$2,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            app.description,
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Text(
            '${app.company} • ${app.location} • RM ${app.payRate}/hr',
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }


  Widget _sectionTitle(String text) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      );

  Widget _emptyText(String text) =>
      Center(child: Text(text, style: const TextStyle(color: Colors.grey)));
}
