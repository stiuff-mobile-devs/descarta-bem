class User {
  String id; // uid
  String email;
  String name;
  DateTime createdAt;
  DateTime updatedAt;
  String createdBy;
  String updatedBy;

  User({
    required this.id,
    required this.email,
    required this.name,
  })  : createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        createdBy = id,
        updatedBy = id;

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "name": name,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "created_by": createdBy,
      "updated_by": updatedBy,
    };
  }
}