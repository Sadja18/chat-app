import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class OtpVerificationWidget extends StatefulWidget {
  final Function(String?) verificationCallBack;
  const OtpVerificationWidget({super.key, required this.verificationCallBack});

  @override
  State<OtpVerificationWidget> createState() => _OtpVerificationWidgetState();
}

class _OtpVerificationWidgetState extends State<OtpVerificationWidget> {
  bool otpGenerated = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.65,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      child: !otpGenerated
          ? ElevatedButton(
              onPressed: () {},
              child: const Text('Generate OTP'),
            )
          : Row(
              children: [const Text('The OTP has been sent to your email account.\Check your inbox(or spam) for email from')],
            ),
    );
  }
}
