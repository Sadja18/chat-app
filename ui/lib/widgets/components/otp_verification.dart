import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class OtpVerificationWidget extends StatefulWidget {
  final Function(String?) verificationCallBack;
  const OtpVerificationWidget({super.key, required this.verificationCallBack});

  @override
  State<OtpVerificationWidget> createState() => _OtpVerificationWidgetState();
}

class _OtpVerificationWidgetState extends State<OtpVerificationWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
