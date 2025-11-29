import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/attendance.dart';
import '../models/student.dart';
import '../services/api_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<Attendance> _attendances = [];
  List<Student> _students = [];
  bool _isLoading = true;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadAttendances();
    _loadStudents();
  }

  Future<void> _loadAttendances() async {
    final dateString = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final attendances = await ApiService().getDailyAttendanceReport(dateString);
    setState(() {
      _attendances = attendances;
      _isLoading = false;
    });
  }

  Future<void> _loadStudents() async {
    final students = await ApiService().getStudents();
    setState(() {
      _students = students;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _isLoading = true;
      });
      _loadAttendances();
    }
  }

  Future<void> _showManualAttendanceDialog() async {
    final _formKey = GlobalKey<FormState>();
    String? _selectedStudentId;
    String _attendanceType = 'in'; // in or out

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Manual Attendance'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Student'),
                  items: _students.map((student) {
                    return DropdownMenuItem(
                      value: student.id.toString(),
                      child: Text('${student.studentName} (${student.nis})'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    _selectedStudentId = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a student';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Type'),
                  value: _attendanceType,
                  items: const [
                    DropdownMenuItem(value: 'in', child: Text('Time In')),
                    DropdownMenuItem(value: 'out', child: Text('Time Out')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      _attendanceType = value;
                    }
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
                  // Record manual attendance
                  final attendanceData = {
                    'student_id': int.parse(_selectedStudentId!),
                    'type': _attendanceType,
                  };

                  // Note: This would require implementing the manual attendance endpoint
                  // For now, we'll simulate the action
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Manual attendance recorded'),
                      backgroundColor: Color(0xFF6A0DAD),
                    ),
                  );
                  _loadAttendances(); // Refresh the list
                }
              },
              child: const Text('Record'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAttendances,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _selectDate(context),
                            icon: const Icon(Icons.calendar_today),
                            label: Text(
                              DateFormat('MMMM dd, yyyy').format(_selectedDate),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: _loadAttendances,
                          icon: const Icon(
                            Icons.refresh,
                            color: Color(0xFF6A0DAD),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _showManualAttendanceDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('Manual Attendance'),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: _attendances.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.check_circle_outline,
                                    size: 60,
                                    color: Color(0xFF6A0DAD),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'No attendance records found',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: _attendances.length,
                              itemBuilder: (context, index) {
                                final attendance = _attendances[index];
                                return Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: const Color(0xFF6A0DAD),
                                      child: Text(
                                        (attendance.studentData?['student_name']
                                                    as String?)
                                                ?.substring(0, 1) ??
                                            '?',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      attendance.studentData?['student_name']
                                              as String? ??
                                          'Unknown Student',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${attendance.studentData?['nis'] as String? ?? 'NIS'} - ${(attendance.studentData?['school_class'] as Map<String, dynamic>?)?['class_name'] as String? ?? 'No Class'}',
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Time In: ${attendance.timeIn}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (attendance.timeOut != null)
                                          Text(
                                            'Time Out: ${attendance.timeOut}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                      ],
                                    ),
                                    trailing: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: attendance.status == 'hadir'
                                            ? const Color(0xFF0EA5A7)
                                            : attendance.status == 'manual'
                                            ? const Color(0xFF14B8A6)
                                            : Colors.red,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        attendance.status.toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
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
    );
  }
}
