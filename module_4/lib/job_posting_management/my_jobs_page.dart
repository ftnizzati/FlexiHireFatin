import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';
import 'job_application.dart';
import 'dummy_job_applications.dart';

class MyJobsPage extends StatefulWidget {
  const MyJobsPage({super.key});

  @override
  State<MyJobsPage> createState() => _MyJobsPageState();
}

class _MyJobsPageState extends State<MyJobsPage> {
  int _selectedNavIndex = 1;

  @override
  Widget build(BuildContext context) {
    final currentJobs = dummyJobApplications
        .where((app) => app.status == JobStatus.accepted)
        .toList();

    final applications = dummyJobApplications
        .where((app) => app.status != JobStatus.accepted)
        .toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 251),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1E3C),
        title: const Text(
          'My Jobs',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle('Current Jobs'),
          currentJobs.isEmpty
              ? const Center(
                  child: Text(
                    'No active jobs',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : Column(
                  children: currentJobs
                      .map((app) => _jobCard(app))
                      .toList(),
                ),

          const SizedBox(height: 20),

          _sectionTitle('Applications'),
          applications.isEmpty
              ? const Center(
                  child: Text(
                    'No applications yet',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : Column(
                  children: applications
                      .map((app) => _jobCard(app))
                      .toList(),
                ),
        ],
      ),

      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedNavIndex,
        onTap: (index) {
          setState(() {
            _selectedNavIndex = index;
          });
          _navigateToPage(index);
        },
      ),
    );
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        break; // Discovery
      case 1:
        Navigator.of(context).pushReplacementNamed('/my_jobs');
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed('/message');
        break;
      case 3:
        Navigator.of(context).pushReplacementNamed('/profile');
        break;
      case 4:
        break; // Not applicable
    }
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _jobCard(JobApplication app) {
    Color statusColor;
    String statusText;

    switch (app.status) {
      case JobStatus.accepted:
        statusColor = Colors.greenAccent;
        statusText = 'Accepted';
        break;
      case JobStatus.pending:
        statusColor = Colors.orangeAccent;
        statusText = 'Pending';
        break;
      case JobStatus.rejected:
        statusColor = Colors.redAccent;
        statusText = 'Rejected';
        break;
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              app.job.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              app.job.description,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 6),
            Text(
              '${app.job.company} • ${app.job.location} • ${app.job.payRate}',
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 12),
            Chip(
              label: Text(statusText),
              backgroundColor: statusColor,
            ),
          ],
        ),
      ),
    );
  }
}
