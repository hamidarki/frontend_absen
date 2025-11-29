import 'package:flutter/material.dart';
import '../models/school_class.dart';
import '../services/api_service.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({Key? key}) : super(key: key);

  @override
  _ClassesScreenState createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  List<SchoolClass> _classes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    final classes = await ApiService().getClasses();
    setState(() {
      _classes = classes;
      _isLoading = false;
    });
  }

  Future<void> _showAddClassDialog() async {
    final _formKey = GlobalKey<FormState>();
    final _classNameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Class'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _classNameController,
              decoration: const InputDecoration(labelText: 'Class Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter class name';
                }
                return null;
              },
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
                  final newClass = await ApiService().createClass(
                    _classNameController.text,
                  );

                  if (newClass != null) {
                    Navigator.of(context).pop();
                    _loadClasses(); // Refresh the list
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Class added successfully'),
                        backgroundColor: Color(0xFF6A0DAD),
                      ),
                    );
                  } else {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to add class'),
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

  Future<void> _showEditClassDialog(SchoolClass schoolClass) async {
    final _formKey = GlobalKey<FormState>();
    final _classNameController = TextEditingController(
      text: schoolClass.className,
    );

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Class'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _classNameController,
              decoration: const InputDecoration(labelText: 'Class Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter class name';
                }
                return null;
              },
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
                  final updatedClass = await ApiService().updateClass(
                    schoolClass.id,
                    _classNameController.text,
                  );

                  if (updatedClass != null) {
                    Navigator.of(context).pop();
                    _loadClasses(); // Refresh the list
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Class updated successfully'),
                        backgroundColor: Color(0xFF6A0DAD),
                      ),
                    );
                  } else {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to update class'),
                        backgroundColor: Color(0xFF6A0DAD),
                      ),
                    );
                  }
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDeleteClass(int classId, String className) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete $className?'),
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
      final success = await ApiService().deleteClass(classId);
      if (success) {
        _loadClasses(); // Refresh the list
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Class deleted successfully'),
            backgroundColor: Color(0xFF6A0DAD),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete class'),
            backgroundColor: Color(0xFF6A0DAD),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Classes')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadClasses,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _showAddClassDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Class'),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: _classes.isEmpty
                          ? const Center(
                              child: Text(
                                'No classes found',
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _classes.length,
                              itemBuilder: (context, index) {
                                final schoolClass = _classes[index];
                                return Card(
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.class_,
                                      size: 40,
                                      color: Color(0xFF6A0DAD),
                                    ),
                                    title: Text(
                                      schoolClass.className,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Created: ${DateTime.parse(schoolClass.createdAt).toString().split(' ')[0]}',
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Color(0xFF9370DB),
                                          ),
                                          onPressed: () =>
                                              _showEditClassDialog(schoolClass),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () => _confirmDeleteClass(
                                            schoolClass.id,
                                            schoolClass.className,
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
        onPressed: _loadClasses,
        backgroundColor: const Color(0xFF6A0DAD),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
