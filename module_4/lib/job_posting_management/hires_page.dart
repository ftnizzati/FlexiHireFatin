import 'package:flutter/material.dart';
import 'job_model.dart';

class HiresPage extends StatelessWidget {
  final Job job;

  const HiresPage({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    final hires = job.hires;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1E3C),
        title: Text(
          'Hired – ${job.title}',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: hires.isEmpty
          ? const Center(
              child: Text(
                'No candidates hired yet.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: hires.length,
              itemBuilder: (context, index) {
                final hire = hires[index];

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF0F1E3C),
                      child: Text(
                        hire.applicant.name[0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(hire.applicant.name),
                    subtitle: Text(hire.applicant.email),
                  ),
                );
              },
            ),
    );
  }
}
