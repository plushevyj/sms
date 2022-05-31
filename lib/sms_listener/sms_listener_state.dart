part of 'sms_listener_bloc.dart';

abstract class SmsListenerState extends Equatable {
  const SmsListenerState();

  @override
  List<Object> get props => [];
}

class NoneSmsListening extends SmsListenerState {}

class SmsListening extends SmsListenerState {}

class SmsSuccess extends SmsListenerState {
  final String otp;

  SmsSuccess(this.otp);

  @override
  List<Object> get props => [otp];
}
