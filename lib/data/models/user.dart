class User {
  final String id;
  String firstName;
  String lastName;
  String imageUrl;
  String profession;
  String email;
  String token;
  DateTime expiresIn;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.imageUrl,
    required this.profession,
    required this.email,
    required this.token,
    required this.expiresIn,
  });

  Map<String, dynamic> toJson() {
    return {
      'localId': id,
      'firstName': firstName,
      'lastName': lastName,
      'imageUrl': imageUrl,
      'profession': profession,
      'email': email,
      'idToken': token,
      'expiresIn': expiresIn.toString(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['localId'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      profession: json['profession'] as String? ?? '',
      email: json['email'] as String? ?? '',
      token: json['idToken'] as String? ?? '',
      expiresIn: DateTime.now().add(
        Duration(
          seconds: int.parse(
            json['expiresIn'],
          ),
        ),
      ),
    );
  }
}
