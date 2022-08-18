import 'package:flutter/material.dart';
import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:sms_listener/sms_listener/sms_listener_bloc.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SmsListenerBloc>(
      create: (context) => SmsListenerBloc(),
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = TextEditingController();

  @override
  void dispose() {
    AltSmsAutofill().unregisterListener();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SmsListenerBloc, SmsListenerState>(
      listener: (context, state) async {
        String? smsBody;
        if (state is SmsListening) {
          try {
            smsBody = await AltSmsAutofill().listenForSms;
          } finally {
            if (smsBody == null) {
              context.read<SmsListenerBloc>().add(const DenySmsListener());
            } else {
              context.read<SmsListenerBloc>().add(SmsFound(smsBody));
            }
          }
          if (!mounted) return;
        } else if (state is SmsSuccess) {
          controller.text = state.otp;
          controller.selection =
              TextSelection.collapsed(offset: controller.text.length);
          context.read<SmsListenerBloc>().add(const DenySmsListener());
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 200),
          child: Column(
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () => context
                      .read<SmsListenerBloc>()
                      .add(const AllowSmsListener()),
                  child: const Text('Push me for allow sms listener'),
                ),
              ),
              const SizedBox(height: 30),
              PinInputTextField(
                pinLength: 4,
                keyboardType: TextInputType.number,
                controller: controller,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'(\d+)')),
                ],
                cursor: Cursor(
                  color: const Color(0xFF000000),
                  enabled: true,
                  width: 1,
                ),
                autoFocus: true,
                decoration: BoxLooseDecoration(
                  strokeWidth: 0,
                  bgColorBuilder: FixedColorListBuilder(
                    List.generate(4, (index) => const Color(0xFFEEF2F5)),
                  ),
                  obscureStyle: ObscureStyle(
                    isTextObscure: false,
                  ),
                  strokeColorBuilder: FixedColorListBuilder(
                    List.generate(4, (index) => const Color(0xFFEEF2F5)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
