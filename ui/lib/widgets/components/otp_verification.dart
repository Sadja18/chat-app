import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:ui/services/api/post.dart';

class OtpVerificationWidget extends StatefulWidget {
  final Function(String?) verificationCallBack;
  const OtpVerificationWidget({super.key, required this.verificationCallBack});

  @override
  State<OtpVerificationWidget> createState() => _OtpVerificationWidgetState();
}

class _OtpVerificationWidgetState extends State<OtpVerificationWidget> {
  bool otpGenerated = false;
  bool _obscureText = true;
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocus = FocusNode();

  Future<void> generateHandler() async {
    var value = await sendRequestToGenerateOTP();

    if (kDebugMode) {
      log("value fetched");
      log(value.toString());
    }
    if (value != null && value is Map) {
      if (value.containsKey("message")) {
        Future.delayed(const Duration(milliseconds: 500));

        setState(() {
          otpGenerated = true;
        });
      } else if (value.containsKey("error")) {
        Future.delayed(const Duration(milliseconds: 500));

        setState(() {
          otpGenerated = false;
        });
      } else {
        Future.delayed(const Duration(milliseconds: 500));

        setState(() {
          otpGenerated = false;
        });
      }
    } else {
      if (kDebugMode) {
        log("otp cannot be generated");
      }
      Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        otpGenerated = false;
      });
    }
  }

  dynamic validator(value) {
    if (value!.isEmpty) {
      return "Please enter the OTP";
    }
    if (value.toString().length != 7) {
      return "Please enter the correct OTP";
    }
    return null;
  }

  Future<void> verifyOtpHandler(String otp) async {
    var result = await sendRequestToVerifyOTP(otp);
    if (kDebugMode) {
      log("result is");
      log(result.toString());
    }
    if (result != null && result is Map) {
      if (result.containsKey("message") && result['message'] != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'].toString())));
        }
        Future.delayed(const Duration(milliseconds: 500));
        widget.verificationCallBack(result["message"].toString());
      } else {
        if (result.containsKey("error")) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['error'].toString().trim())));
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Cannot verify OTP.\nPlease try later")));
          }
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Cannot verify OTP.\nPlease try later")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      // margin: const EdgeInsets.symmetric(
      //   horizontal: 15.0,
      //   vertical: 8.0,
      // ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 8.0,
      ),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.purple.shade100,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              if (kDebugMode) {
                log("message generate otp");
              }
              generateHandler();
            },
            child: const Text('Generate OTP'),
          ),
          // Text(
          //   otpGenerated.toString(),
          //   style: const TextStyle(
          //     color: Colors.white,
          //   ),
          // ),
          otpGenerated
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('The OTP has been sent to your email account.\nCheck your inbox(or spam) for email from'),
                )
              : const SizedBox(
                  height: 10,
                ),
          TextField(
            controller: _otpController,
            obscureText: _obscureText,
            focusNode: _otpFocus,
            decoration: InputDecoration(
              labelText: 'OTP',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  if (kDebugMode) {
                    log(_obscureText ? "textObscured" : "Text visible");
                  }
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: _obscureText ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              if (kDebugMode) {
                log("verify otp button clicked");
              }
              _otpFocus.unfocus();

              var value = _otpController.text.trim();
              if (validator(value) != null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(validator(value))));
              } else {
                if (kDebugMode) {
                  log("api call verify otp");
                }
                verifyOtpHandler(value.trim());
              }
            },
            child: const Text(
              'Verify Email',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
