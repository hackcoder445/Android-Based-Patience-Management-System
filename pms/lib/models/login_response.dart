class LoginResponse {
  final String? key;
  final List<dynamic>? non_field_errors;

  LoginResponse({this.key, this.non_field_errors});

  factory LoginResponse.fromJson(jsonBody) {
    final key = jsonBody['key'];
    final non_field_errors = jsonBody['non_field_errors'];
    return LoginResponse(key: key, non_field_errors: non_field_errors);
  }
}
