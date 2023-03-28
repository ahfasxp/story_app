import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:{{appName.snakeCase()}}/data/remote/response/login_result.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse extends Equatable {
  final bool? error;
  final String? message;
  final LoginResult? loginResult;

  const LoginResponse({this.error, this.message, this.loginResult});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  @override
  List<Object?> get props => [error, message, loginResult];
}
