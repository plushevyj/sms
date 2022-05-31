part of 'sms_listener_bloc.dart';

abstract class SmsListenerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class DenySmsListener extends SmsListenerEvent {}

class AllowSmsListener extends SmsListenerEvent {}

class SmsFound extends SmsListenerEvent {
  final String message;

  SmsFound(this.message);

  @override
  List<Object> get props => [message];
}