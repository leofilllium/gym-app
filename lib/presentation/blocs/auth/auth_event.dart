import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthSubmitEvent extends AuthEvent {
  final String uuid;
  final String languageCode;

  const AuthSubmitEvent({required this.uuid, required this.languageCode});

  @override
  List<Object?> get props => [uuid, languageCode];
}