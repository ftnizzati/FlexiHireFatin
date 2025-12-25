import 'job_model.dart';
import 'job_application.dart';

final List<JobApplication> dummyJobApplications = [
  JobApplication(
    job: Job(
      id: '1',
      title: 'Cafe Assistant',
      company: 'Kopi Penang',
      location: 'George Town',
      payRate: 8.0,
      description: 'Assist cafe operations',
    ),
    status: JobStatus.accepted,
  ),
  JobApplication(
    job: Job(
      id: '2',
      title: 'Retail Helper',
      company: 'Mini Mart',
      location: 'Bayan Lepas',
      payRate: 7.5,
      description: 'Help store operations',
    ),
    status: JobStatus.pending,
  ),
  JobApplication(
    job: Job(
      id: '3',
      title: 'Warehouse Packer',
      company: 'LogiPro',
      location: 'Bukit Mertajam',
      payRate: 9.0,
      description: 'Packing and sorting goods',
    ),
    status: JobStatus.rejected,
  ),
];