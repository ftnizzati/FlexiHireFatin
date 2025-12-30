import 'package:flutter/material.dart';
import 'job_model.dart';
import 'job_application.dart';

class ApplicantsPage extends StatefulWidget {
  final Job job;

  const ApplicantsPage({
    super.key,
    required this.job,
  });

  @override
  State<ApplicantsPage> createState() => _ApplicantsPageState();
}

class _ApplicantsPageState extends State<ApplicantsPage> {
  @override
  Widget build(BuildContext context) {
    final applicants = widget.job.applicants;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1E3C),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Applicants – ${widget.job.title}',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: applicants.isEmpty
          ? const Center(
              child: Text(
                'No applicants yet.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: applicants.length,
              itemBuilder: (context, index) {
                final application = applicants[index];
                final applicant = application.applicant;

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(applicant.name),
                    subtitle: Text(applicant.email),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text(
                        'Hire',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _hireApplicant(application);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _hireApplicant(JobApplication application) {
    setState(() {
      widget.job.applicants.remove(application);
      application.status = JobStatus.hired;
      widget.job.hires.add(application);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${application.applicant.name} hired successfully'),
      ),
    );
  }
}
