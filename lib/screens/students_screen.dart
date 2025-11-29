import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/school_class.dart';
import '../services/api_service.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({Key? key}) : super(key: key);

  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<Student> _students = [];
  List<SchoolClass> _classes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
    _loadClasses();
  }

  Future<void> _loadStudents() async {
    final students = await ApiService().getStudents();
    setState(() {
      _students = students;
      _isLoading = false;
    });
  }

  Future<void> _loadClasses() async {
    final classes = await ApiService().getClasses();
    setState(() {
      _classes = classes;
    });
  }

  Future<void> _showAddStudentDialog() async {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _nisController = TextEditingController();
    String? _selectedClassId;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Student'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Student Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter student name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nisController,
                  decoration: const InputDecoration(labelText: 'NIS'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter NIS';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Class'),
                  items: _classes.map((schoolClass) {
                    return DropdownMenuItem(
                      value: schoolClass.id.toString(),
                      child: Text(schoolClass.className),
                    );
                  }).toList(),
                  onChanged: (value) {
                    _selectedClassId = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a class';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Create student
                  final studentData = {
                    'class_id': int.parse(_selectedClassId!),
                    'student_name': _nameController.text,
                    'nis': _nisController.text,
                    'photo': 'default.jpg', // Placeholder
                    'face_embedding': '[]', // Placeholder
                  };

                  final newStudent = await ApiService().createStudent(
                    studentData,
                  );

                  if (newStudent != null) {
                    Navigator.of(context).pop();
                    _loadStudents(); // Refresh the list
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Student added successfully'),
                        backgroundColor: Color(0xFF6A0DAD),
                      ),
                    );
                  } else {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to add student'),
                        backgroundColor: Color(0xFF6A0DAD),
                      ),
                    );
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDeleteStudent(int studentId, String studentName) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete $studentName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      final success = await ApiService().deleteStudent(studentId);
      if (success) {
        _loadStudents(); // Refresh the list
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Student deleted successfully'),
            backgroundColor: Color(0xFF6A0DAD),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete student'),
            backgroundColor: Color(0xFF6A0DAD),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Students')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStudents,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _showAddStudentDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Student'),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: _students.isEmpty
                          ? const Center(
                              child: Text(
                                'No students found',
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _students.length,
                              itemBuilder: (context, index) {
                                final student = _students[index];
                                return Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: const Color(0xFF6A0DAD),
                                      child: Text(
                                        student.studentName.substring(0, 1),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      student.studentName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${student.nis} - ${student.schoolClass?.className ?? 'No Class'}',
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () =>
                                              _confirmDeleteStudent(
                                                student.id,
                                                student.studentName,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadStudents,
        backgroundColor: const Color(0xFF6A0DAD),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
