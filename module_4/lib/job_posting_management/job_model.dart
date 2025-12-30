import 'job_application.dart';

class Job {
  final String id;
  final String title;
  final String company;
  final String location;
  final double payRate;
  final String description;

  List<JobApplication> applicants;
  List<JobApplication> hires;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.payRate,
    required this.description,
    List<JobApplication>? applicants,
    List<JobApplication>? hires,
  })  : applicants = applicants ?? [],
        hires = hires ?? [];
}
