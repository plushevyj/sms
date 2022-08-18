part of 'sms_listener_bloc.dart';

abstract class SmsListenerEvent extends Equatable {
  const SmsListenerEvent();

  @override
  List<Object> get props => [];
}

class DenySmsListener extends SmsListenerEvent {
  const DenySmsListener();
}

class AllowSmsListener extends SmsListenerEvent {
  const AllowSmsListener();
}

class SmsFound extends SmsListenerEvent {
  final String message;
  const SmsFound(this.message);

  @override
  List<Object> get props => [message];
}