import 'job_model.dart';

enum JobStatus {
  pending,
  accepted,
  rejected,
}

class JobApplication {
  final Job job;
  final JobStatus status;

  JobApplication({
    required this.job,
    required this.status,
  });
}
