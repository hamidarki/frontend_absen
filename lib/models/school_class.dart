class SchoolClass {
  final int id;
  final String className;
  final String createdAt;
  final String updatedAt;

  SchoolClass({
    required this.id,
    required this.className,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SchoolClass.fromJson(Map<String, dynamic> json) {
    return SchoolClass(
      id: json['id'],
      className: json['class_name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_name': className,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}