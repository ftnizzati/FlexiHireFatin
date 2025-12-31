import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'job_model.dart';

class CreateJobPage extends StatefulWidget {
  final Job? existingJob;

  const CreateJobPage({super.key, this.existingJob});

  @override
  State<CreateJobPage> createState() => _CreateJobPageState();
}

class _CreateJobPageState extends State<CreateJobPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _payRateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool get isEdit => widget.existingJob != null;

  @override
  void initState() {
    super.initState();

    final job = widget.existingJob;
    if (job != null) {
      _titleController.text = job.title;
      _companyController.text = job.company;
      _locationController.text = job.location;
      _payRateController.text = job.payRate.toString();
      _descriptionController.text = job.description;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _payRateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFB),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Text(
          isEdit ? 'Edit Job' : 'Create Job',
          style: const TextStyle(color: Color.fromARGB(255, 21, 36, 69)),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 21, 36, 69)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_titleController, 'Job Title'),
              const SizedBox(height: 16),
              _buildTextField(_companyController, 'Company'),
              const SizedBox(height: 16),
              _buildTextField(_locationController, 'Location'),
              const SizedBox(height: 16),

              TextFormField(
                controller: _payRateController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Pay Rate',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter pay rate';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
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
                  onPressed: _saveJob,
                  child: Text(
                    isEdit ? 'Save Changes' : 'Create Job',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveJob() {
    if (!_formKey.currentState!.validate()) return;

    final double parsedPayRate = double.tryParse(_payRateController.text) ?? 0.0;

    final Job jobToReturn = Job(

      id: widget.existingJob?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      company: _companyController.text,
      location: _locationController.text,
      payRate: parsedPayRate,
      description: _descriptionController.text,

      applicants: widget.existingJob?.applicants ?? [],
    );

    Navigator.pop(context, jobToReturn);
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter $label';
        return null;
      },
    );
  }
}
