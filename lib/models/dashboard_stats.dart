class DashboardStats {
  final int totalStudents;
  final int totalClasses;
  final int todayAttendances;
  final List<AttendanceData> attendanceData;

  DashboardStats({
    required this.totalStudents,
    required this.totalClasses,
    required this.todayAttendances,
    required this.attendanceData,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    var attendanceDataList = json['attendance_data'] as List;
    List<AttendanceData> attendanceData = attendanceDataList
        .map((item) => AttendanceData.fromJson(item))
        .toList();

    return DashboardStats(
      totalStudents: json['total_students'],
      totalClasses: json['total_classes'],
      todayAttendances: json['today_attendances'],
      attendanceData: attendanceData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_students': totalStudents,
      'total_classes': totalClasses,
      'today_attendances': todayAttendances,
      'attendance_data': attendanceData.map((item) => item.toJson()).toList(),
    };
  }
}

class AttendanceData {
  final String date;
  final int count;

  AttendanceData({
    required this.date,
    required this.count,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      date: json['date'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'count': count,
    };
  }
}