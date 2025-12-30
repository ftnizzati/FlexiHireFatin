import 'job_model.dart';
import 'job_application.dart';
import 'applicant.dart';

List<Job> dummyJobs = [
  Job(
    id: '1',
    title: 'Software Developer',
    company: 'TechNova Sdn Bhd',
    description: 'Develop and maintain mobile and web applications.',
    location: 'Kuala Lumpur',
    payRate: 5000.0,
    applicants: [
      JobApplication(
        applicant: Applicant(
          name: 'Aina Sofea',
          email: 'aina@gmail.com',
        ),
        status: JobStatus.applied,
      ),
      JobApplication(
        applicant: Applicant(
          name: 'Haziq Firdaus',
          email: 'haziq@gmail.com',
        ),
        status: JobStatus.applied,
      ),
    ],
  ),
];
