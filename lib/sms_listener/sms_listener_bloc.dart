import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';

part 'sms_listener_event.dart';
part 'sms_listener_state.dart';

class SmsListenerBloc extends Bloc<SmsListenerEvent, SmsListenerState> {
  SmsListenerBloc() : super(const NoneSmsListening()) {
    on<DenySmsListener>(_denySmsListening);
    on<AllowSmsListener>(_allowSmsListening);
    on<SmsFound>(_smsFound);
  }

  void _denySmsListening(
    DenySmsListener event,
    Emitter<SmsListenerState> emit,
  ) {
    emit(const NoneSmsListening());
  }

  void _allowSmsListening(
    AllowSmsListener event,
    Emitter<SmsListenerState> emit,
  ) async {
    try {
      await Permission.sms.request();
      if (await Permission.sms.status.isGranted) {
        emit(const SmsListening());
      }
    } finally {
      emit(const NoneSmsListening());
    }
  }

  void _smsFound(
    SmsFound event,
    Emitter<SmsListenerState> emit,
  ) {
    String basicPartOfMessage = 'Ваш код для входа в StreamPlatform';
    try {
      List<String> splitMessage = event.message.split(' - ');
      if (basicPartOfMessage == splitMessage[1]) {
        String otp = splitMessage[0];
        if (otp.length == 4 && int.tryParse(otp) != null) {
          emit(SmsSuccess(otp));
          return;
        }
      }
    } finally {
      emit(const NoneSmsListening());
    }
  }
}
