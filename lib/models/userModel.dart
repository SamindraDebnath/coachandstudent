class UserModel {
  String? uid;
  String? email;
  String? name;
  String? password; // optional, avoid storing in DB
  String? imageUrl;
  bool isCoach;

  UserModel({
    this.uid,
    this.email,
    this.name,
    this.password,
    this.imageUrl,
    this.isCoach = false, // default false
  });

  // receiving data from server
  UserModel.fromMap(Map<String, dynamic> map)
      : uid = map['uid'],
        email = map['email'],
        name = map['name'],
        password = map['password'],
        imageUrl = map['image_url'],
        isCoach = map['isCoach'] ?? false;

  // sending data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'image_url': imageUrl,
      'isCoach': isCoach,
    };
  }

  // from JSON
  UserModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        email = json['email'],
        name = json['name'],
        password = json['password'],
        imageUrl = json['image_url'],
        isCoach = json['isCoach'] ?? false;

  // to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'image_url': imageUrl,
      'isCoach': isCoach,
    };
  }
}
