import 'package:equatable/equatable.dart';

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
