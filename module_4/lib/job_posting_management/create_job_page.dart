import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'job_model.dart';

class CreateJobPage extends StatefulWidget {
  const CreateJobPage({super.key});

  @override
  State<CreateJobPage> createState() => _CreateJobPageState();
}

class _CreateJobPageState extends State<CreateJobPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _payRateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 251),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1E3C),
        title: const Text(
          'Create Job',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Job Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _companyController,
              decoration: const InputDecoration(
                labelText: 'Company',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _payRateController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
              decoration: const InputDecoration(
                labelText: 'Pay Rate',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Job Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F1E3C),
                ),
                onPressed: () {
                  if (_titleController.text.isEmpty ||
                      _companyController.text.isEmpty ||
                      _locationController.text.isEmpty ||
                      _payRateController.text.isEmpty) {
                    return;
                  }
                  
                  final double parsedPayRate = double.tryParse(_payRateController.text) ?? 0.0;
                  final Job newJob = Job(
                    id: DateTime.now().millisecondsSinceEpoch.toString(), // unique ID
                    title: _titleController.text,
                    company: _companyController.text,
                    location: _locationController.text,
                    payRate: parsedPayRate,
                    description: _descriptionController.text,
                  );

                  Navigator.pop(context, newJob);
                },
                child: const Text(
                  'Create Job',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
