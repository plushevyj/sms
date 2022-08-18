part of 'sms_listener_bloc.dart';

abstract class SmsListenerState extends Equatable {
  const SmsListenerState();

  @override
  List<Object> get props => [];
}

class NoneSmsListening extends SmsListenerState {
  const NoneSmsListening();
}

class SmsListening extends SmsListenerState {
  const SmsListening();
}

class SmsSuccess extends SmsListenerState {
  final String otp;
  const SmsSuccess(this.otp);

  @override
  List<Object> get props => [otp];
}
