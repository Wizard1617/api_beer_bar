class RegisterRequest {
  String firstName;
  String lastName;
  String middleName;
  String email;
  String password;

  RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'middleName': middleName,
    'email': email,
    'password': password,
  };
}