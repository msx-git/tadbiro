class User {
  final String id;
  String firstName;
  String lastName;
  String imageUrl;
  String profession;
  String email;
  String token;
  String refreshToken;
  DateTime expiresIn;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.imageUrl,
    required this.profession,
    required this.email,
    required this.token,
    required this.refreshToken,
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
      'refreshToken': refreshToken,
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
      refreshToken: json['refreshToken'] as String? ?? '',
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
