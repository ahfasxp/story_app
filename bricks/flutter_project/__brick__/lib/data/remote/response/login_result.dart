import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_result.g.dart';

@JsonSerializable()
class LoginResult extends Equatable {
  final String? userId;
  final String? name;
  final String? token;

  const LoginResult({this.userId, this.name, this.token});

  factory LoginResult.fromJson(Map<String, dynamic> json) =>
      _$LoginResultFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResultToJson(this);

  @override
  List<Object?> get props => [userId, name, token];
}
