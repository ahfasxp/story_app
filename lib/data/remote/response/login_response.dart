
import 'package:equatable/equatable.dart';
import 'package:story_app/data/remote/response/login_result.dart';

class LoginResponse extends Equatable {
  final bool? error;
  final String? message;
  final LoginResult? loginResult;

  const LoginResponse({this.error, this.message, this.loginResult});

  @override
  List<Object?> get props => [error, message, loginResult];

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      error: json['error'],
      message: json['message'],
      loginResult: json['loginResult'] != null
          ? LoginResult.fromJson(json['loginResult'])
          : null,
    );
  }
}
