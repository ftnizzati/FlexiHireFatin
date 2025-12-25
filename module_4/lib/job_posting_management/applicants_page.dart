import 'package:flutter/material.dart';

class ApplicantsPage extends StatelessWidget {
  final String jobId;

  // Remove 'const' because dummyApplicants is non-const
  ApplicantsPage({super.key, required this.jobId});

  // Dummy applicant data for now
  final Map<String, List<Map<String, String>>> dummyApplicants = {
    '1': [
      {'name': 'Alice', 'email': 'alice@example.com'},
      {'name': 'Bob', 'email': 'bob@example.com'},
    ],
    '2': [
      {'name': 'Charlie', 'email': 'charlie@example.com'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final applicants = dummyApplicants[jobId] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Applicants for Job $jobId'),
      ),
      body: applicants.isEmpty
          ? Center(
        child: Text('No applicants yet for this job.'),
      )
          : ListView.builder(
        itemCount: applicants.length,
        itemBuilder: (context, index) {
          final applicant = applicants[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(applicant['name']!),
              subtitle: Text(applicant['email']!),
              trailing: ElevatedButton(
                child: Text('View CV'),
                onPressed: () {
                  // TODO: Navigate to CV page or show details
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
