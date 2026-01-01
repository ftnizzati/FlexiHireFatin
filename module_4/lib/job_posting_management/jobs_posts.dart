import 'package:flutter/material.dart';
import 'package:module_4/user_role.dart';
import '../components/bottom_nav_bar.dart';
import 'job_model.dart';
import 'create_job_page.dart';
import 'applicants_page.dart';
import '../job_posting_management/hires_page.dart';
import 'dummy_jobs.dart'; 
import '../navigation_helper.dart';
import 'job_details_page.dart';
import 'micro_shift.dart';

class JobPostingPage extends StatefulWidget {
  const JobPostingPage({super.key});

  @override
  State<JobPostingPage> createState() => _JobPostingPageState();
}

class _JobPostingPageState extends State<JobPostingPage> {
  int _selectedNavIndex = 0; // Start at Jobs tab
  final List<Job> recruiterJobs = List.from(dummyJobs);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 251),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1E3C),
        elevation: 0,
        title: const Text(
          'My Job Postings',
          style: TextStyle(
            color: Colors.white, 
            fontSize: 20,
            fontWeight: FontWeight.w600,
          
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0F1E3C),
        onPressed: () async {
          final Job? newJob = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateJobPage()),
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
        role: currentUserRole,
        onTap: (index) {
          setState(() {
            _selectedNavIndex = index;
          });
          NavigationHelper.navigate(context, index, currentUserRole);
        },
        onMiddleButtonPressed: () {
          NavigationHelper.handleFab(context);
        },
      ),
    );
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
        return JobCard(
          job: job,

          // NEW: open full details page
          onOpenDetails: () async {
            final result = await Navigator.push<JobDetailsResult>(
              context,
              MaterialPageRoute(
                builder: (_) => JobDetailsPage(job: job),
              ),
            );

            if (result == null) return;

            setState(() {
              if (result.action == JobDetailsAction.updated && result.updatedJob != null) {
                recruiterJobs[index] = result.updatedJob!;
              } else if (result.action == JobDetailsAction.deleted) {
                recruiterJobs.removeAt(index);
              }
            });
          },

          // keep these buttons if you still want quick access
          onApplicants: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ApplicantsPage(job: job)),
            );
          },
          onHires: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HiresPage(job: job)),
            );
          },
          onDelete: () {
            setState(() {
              recruiterJobs.removeAt(index);
            });
          },
        );
      },
    );
  }
}

// ===============================
// JOB CARD WIDGET
// ===============================
class JobCard extends StatelessWidget {
  final Job job;
  final VoidCallback onOpenDetails;
  final VoidCallback onApplicants;
  final VoidCallback onHires;
  final VoidCallback onDelete;

  const JobCard({
    required this.job,
    required this.onOpenDetails,
    required this.onApplicants,
    required this.onHires,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onOpenDetails,
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(job.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(job.description, style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 6),
              Text('${job.location} • RM ${job.payRate}/hr',
                style: const TextStyle(color: Colors.black54)),

            if (job.microShifts.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Micro-shifts',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: job.microShifts.map((shift) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F4F7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      shift.toDisplay(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 12),
            Row(

                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F1E3C)),
                    onPressed: onApplicants,
                    child: const Text('Applicants', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: onHires,
                    child: const Text('Hires', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 8),
                  IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
