import 'school_class.dart';

class Student {
  final int id;
  final int classId;
  final String studentName;
  final String nis;
  final String photo;
  final String faceEmbedding;
  final String createdAt;
  final String updatedAt;
  final SchoolClass? schoolClass;

  Student({
    required this.id,
    required this.classId,
    required this.studentName,
    required this.nis,
    required this.photo,
    required this.faceEmbedding,
    required this.createdAt,
    required this.updatedAt,
    this.schoolClass,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      classId: json['class_id'],
      studentName: json['student_name'],
      nis: json['nis'],
      photo: json['photo'],
      faceEmbedding: json['face_embedding'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      schoolClass: json['school_class'] != null
          ? SchoolClass.fromJson(json['school_class'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_id': classId,
      'student_name': studentName,
      'nis': nis,
      'photo': photo,
      'face_embedding': faceEmbedding,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'school_class': schoolClass?.toJson(),
    };
  }
}