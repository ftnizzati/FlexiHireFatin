import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';
import 'job_model.dart';
import 'create_job_page.dart';
import 'applicants_page.dart';

class JobPostingPage extends StatefulWidget {
  const JobPostingPage({super.key});

  @override
  State<JobPostingPage> createState() => _JobPostingPageState();
}

class _JobPostingPageState extends State<JobPostingPage> {
  int _selectedNavIndex = 4;
  final List<Job> recruiterJobs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 251),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1E3C),
        title: const Text(
          'My Job Postings',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0F1E3C),
        onPressed: () async {
          final Job? newJob = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateJobPage(),
            ),
          );

          if (newJob != null) {
            setState(() {
              recruiterJobs.add(newJob);
            });
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: _recruiterView(),

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
      case 2:
        Navigator.of(context).pushReplacementNamed('/message');
        break;
      case 3:
        Navigator.of(context).pushReplacementNamed('/profile');
        break;
    }
  }

  // ===============================
  // RECRUITER VIEW
  // ===============================
  Widget _recruiterView() {
    if (recruiterJobs.isEmpty) {
      return const Center(
        child: Text(
          'No job postings yet.\nTap + to create a job.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: recruiterJobs.length,
      itemBuilder: (context, index) {
        final job = recruiterJobs[index];

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
                  job.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  job.description,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 6),
                Text(
                  '${job.location} • ${job.payRate}',
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F1E3C),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ApplicantsPage(jobId: job.id),
                          ),
                        );
                      },
                      child: const Text(
                        'Applicants',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          recruiterJobs.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
