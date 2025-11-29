class Attendance {
  final int id;
  final int studentId;
  final String date;
  final String timeIn;
  final String? timeOut;
  final String status;
  final String createdAt;
  final String updatedAt;
  // We'll handle student data separately to avoid circular imports
  final Map<String, dynamic>? studentData;

  Attendance({
    required this.id,
    required this.studentId,
    required this.date,
    required this.timeIn,
    this.timeOut,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.studentData,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      studentId: json['student_id'],
      date: json['date'],
      timeIn: json['time_in'],
      timeOut: json['time_out'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      studentData: json['student'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'date': date,
      'time_in': timeIn,
      'time_out': timeOut,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'student': studentData,
    };
  }
}