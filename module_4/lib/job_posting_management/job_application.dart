import 'applicant.dart';

enum JobStatus { applied, hired, rejected }

class JobApplication {
  final Applicant applicant;
  JobStatus status;

  JobApplication({
    required this.applicant,
    this.status = JobStatus.applied,
  });
}
