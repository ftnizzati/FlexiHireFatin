import 'job_application.dart';
import 'my_job_application.dart';

final List<MyJobApplication> myJobsDummy = [
  MyJobApplication(
    jobTitle: 'Cafe Assistant',
    company: 'Kopi Penang',
    location: 'George Town',
    payRate: 8.0,
    description: 'Assist cafe operations',
    status: JobStatus.applied,
  ),
  MyJobApplication(
    jobTitle: 'Retail Helper',
    company: 'Mini Mart',
    location: 'Bayan Lepas',
    payRate: 7.5,
    description: 'Help store operations',
    status: JobStatus.hired,
  ),
  MyJobApplication(
    jobTitle: 'Warehouse Packer',
    company: 'LogiPro',
    location: 'Bukit Mertajam',
    payRate: 9.0,
    description: 'Packing and sorting goods',
    status: JobStatus.rejected,
  ),
];
