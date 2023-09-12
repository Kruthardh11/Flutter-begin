class User {
  final String name;
  final String age;
  final String email;
  final String password;
  final String gender;
  final String city;
  final String favSport;

  const User({
    required this.name,
    required this.age,
    required this.email,
    required this.password,
    required this.gender,
    required this.city,
    required this.favSport,
  });

  Map<String, dynamic> toJson() {
    return {
      "Name": name,
      "Age": age,
      "Password": password,
      "Gender": gender,
      "City": city,
      "FavSport": favSport,
    };
  }

  //map users fetched from firebase to Usermodel
}
