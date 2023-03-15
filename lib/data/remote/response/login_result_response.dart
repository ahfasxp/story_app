import 'package:equatable/equatable.dart';

class LoginResultResponse extends Equatable {
  final bool? error;
  final String? message;
  final LoginResult? loginResult;

  const LoginResultResponse({this.error, this.message, this.loginResult});

  @override
  List<Object?> get props => [error, message, loginResult];

  factory LoginResultResponse.fromJson(Map<String, dynamic> json) {
    return LoginResultResponse(
      error: json['error'],
      message: json['message'],
      loginResult: json['loginResult'] != null
          ? LoginResult.fromJson(json['loginResult'])
          : null,
    );
  }
}

class LoginResult extends Equatable {
  final String? userId;
  final String? name;
  final String? token;

  const LoginResult({this.userId, this.name, this.token});

  @override
  List<Object?> get props => [userId, name, token];

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      userId: json['userId'],
      name: json['name'],
      token: json['token'],
    );
  }
}
