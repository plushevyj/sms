import 'package:flutter/material.dart';
import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:sms_listener/sms_listener/sms_listener_bloc.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SmsListenerBloc>(
      create: (context) => SmsListenerBloc()..add(DenySmsListener()),
      child: AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  late final SmsListenerBloc smsListenerBloc;
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    smsListenerBloc = BlocProvider.of<SmsListenerBloc>(context)
      ..add(DenySmsListener());
    super.initState();
  }

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
          print(BlocProvider.of<SmsListenerBloc>(context).state);
          try {
            smsBody = await AltSmsAutofill().listenForSms;
          } finally {
            if (smsBody == null) {
              BlocProvider.of<SmsListenerBloc>(context).add(
                DenySmsListener(),
              );
            } else {
              BlocProvider.of<SmsListenerBloc>(context).add(
                SmsFound(smsBody),
              );
            }
          }
          if (!mounted) return;
        } else if (state is SmsSuccess) {
          print(BlocProvider.of<SmsListenerBloc>(context).state);
          setState(() {
            controller.text = state.otp;
          });
          BlocProvider.of<SmsListenerBloc>(context).add(
            DenySmsListener(),
          );
        } else {
          print(BlocProvider.of<SmsListenerBloc>(context).state);
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 200),
          child: Column(
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () =>
                      BlocProvider.of<SmsListenerBloc>(context).add(
                    AllowSmsListener(),
                  ),
                  child: Text('Push me for allow sms listener'),
                ),
              ),
              SizedBox(height: 30),
              PinInputTextField(
                pinLength: 4,
                keyboardType: TextInputType.number,
                controller: controller,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'(\d+)')),
                ],
                cursor: Cursor(
                  color: Color(0xFF000000),
                  enabled: true,
                  width: 1,
                ),
                autoFocus: true,
                decoration: BoxLooseDecoration(
                  strokeWidth: 0,
                  bgColorBuilder: FixedColorListBuilder([
                    Color(0xFFEEF2F5),
                    Color(0xFFEEF2F5),
                    Color(0xFFEEF2F5),
                    Color(0xFFEEF2F5),
                  ]),
                  obscureStyle: ObscureStyle(
                    isTextObscure: false,
                  ),
                  strokeColorBuilder: FixedColorListBuilder([
                    Color(0xFFEEF2F5),
                    Color(0xFFEEF2F5),
                    Color(0xFFEEF2F5),
                    Color(0xFFEEF2F5),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
