import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/school_class.dart';
import '../models/student.dart';
import '../models/attendance.dart';
import '../models/dashboard_stats.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';
  
  // Auth endpoints
  Future<User?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data['user']);
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<bool> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }

  // Dashboard endpoint
  Future<DashboardStats?> getDashboardStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dashboard'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return DashboardStats.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Dashboard stats error: $e');
      return null;
    }
  }

  // Classes endpoints
  Future<List<SchoolClass>> getClasses() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/classes'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => SchoolClass.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Get classes error: $e');
      return [];
    }
  }

  Future<SchoolClass?> createClass(String className) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/classes'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'class_name': className}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return SchoolClass.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Create class error: $e');
      return null;
    }
  }

  Future<SchoolClass?> updateClass(int id, String className) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/classes/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'class_name': className}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return SchoolClass.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Update class error: $e');
      return null;
    }
  }

  Future<bool> deleteClass(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/classes/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 204;
    } catch (e) {
      print('Delete class error: $e');
      return false;
    }
  }

  // Students endpoints
  Future<List<Student>> getStudents() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/students'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Student.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Get students error: $e');
      return [];
    }
  }

  Future<Student?> createStudent(Map<String, dynamic> studentData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/students'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(studentData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Student.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Create student error: $e');
      return null;
    }
  }

  Future<Student?> updateStudent(int id, Map<String, dynamic> studentData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/students/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(studentData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Student.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Update student error: $e');
      return null;
    }
  }

  Future<bool> deleteStudent(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/students/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 204;
    } catch (e) {
      print('Delete student error: $e');
      return false;
    }
  }

  // Attendances endpoints
  Future<List<Attendance>> getAttendances() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/attendances'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Attendance.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Get attendances error: $e');
      return [];
    }
  }

  Future<Attendance?> createAttendance(Map<String, dynamic> attendanceData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/attendances'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(attendanceData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Attendance.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Create attendance error: $e');
      return null;
    }
  }

  Future<Attendance?> updateAttendance(int id, Map<String, dynamic> attendanceData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/attendances/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(attendanceData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Attendance.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Update attendance error: $e');
      return null;
    }
  }

  Future<bool> deleteAttendance(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/attendances/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 204;
    } catch (e) {
      print('Delete attendance error: $e');
      return false;
    }
  }

  Future<List<Attendance>> getDailyAttendanceReport(String date) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/attendances/report/daily?date=$date'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Attendance.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Get daily attendance report error: $e');
      return [];
    }
  }

  Future<List<Attendance>> getMonthlyAttendanceReport(String month) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/attendances/report/monthly?month=$month'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Attendance.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Get monthly attendance report error: $e');
      return [];
    }
  }
}