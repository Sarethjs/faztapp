class RegisterUserDto {
  const RegisterUserDto(
      {required this.email, required this.userName, required this.password});

  final String email;
  final String userName;
  final String password;
}
