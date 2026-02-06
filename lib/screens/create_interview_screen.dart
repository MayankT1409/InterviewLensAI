import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/interview_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';

class CreateInterviewScreen extends StatefulWidget {
  const CreateInterviewScreen({Key? key}) : super(key: key);

  @override
  State<CreateInterviewScreen> createState() => _CreateInterviewScreenState();
}

class _CreateInterviewScreenState extends State<CreateInterviewScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedDifficulty = 'Medium';
  bool _isLoading = false;

  final _authService = AuthService();
  final _firestoreService = FirestoreService();

  final List<String> _difficulties = ['Easy', 'Medium', 'Hard', 'Expert'];

  void _createInterview() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final user = _authService.currentUser;
        if (user == null) throw Exception('User not logged in');

        final interviewId = const Uuid().v4();
        final interview = InterviewModel(
          id: interviewId,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          difficulty: _selectedDifficulty,
          createdBy: user.uid,
          createdAt: DateTime.now(),
        );

        await _firestoreService.createInterview(interview);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Interview created successfully!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Interview'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                labelText: 'Job Title',
                hintText: 'e.g. Senior Flutter Developer',
                controller: _titleController,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                labelText: 'Description',
                hintText: 'Describe the role and requirements...',
                controller: _descriptionController,
                maxLines: 5,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedDifficulty,
                decoration: InputDecoration(
                  labelText: 'Difficulty Level',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _difficulties.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedDifficulty = newValue!;
                  });
                },
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Create Session',
                onPressed: _createInterview,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
