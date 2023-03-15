import 'package:equatable/equatable.dart';

class BaseResponse extends Equatable {
  final bool? error;
  final String? message;

  const BaseResponse({this.error, this.message});

  @override
  List<Object?> get props => [error, message];

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      error: json['error'],
      message: json['message'],
    );
  }
}
