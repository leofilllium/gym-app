import 'package:equatable/equatable.dart';

abstract class AppStatusEvent extends Equatable {
  const AppStatusEvent();

  @override
  List<Object?> get props => [];
}

class LoadAppStatus extends AppStatusEvent {}

class SaveLanguageEvent extends AppStatusEvent {
  final String languageCode;

  const SaveLanguageEvent(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

// Renamed to avoid conflict with domain use case
class SaveUuidEvent extends AppStatusEvent {
  final String uuid;

  const SaveUuidEvent(this.uuid);

  @override
  List<Object?> get props => [uuid];
}