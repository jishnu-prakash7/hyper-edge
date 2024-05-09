import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/core/constants.dart';
import 'package:social_media/domain/models/user_model.dart';
import 'package:social_media/presentation/blocs/otp_bloc/bloc/otp_bloc.dart';
import 'package:social_media/presentation/blocs/signup_bloc/bloc/signup_bloc.dart';
import 'package:social_media/presentation/pages/login_page/login_screen.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';

class OtpScreen extends StatefulWidget {
  final UserModel user;
  const OtpScreen({
    super.key,
    required this.user,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

String enteredOtp = '';

class _OtpScreenState extends State<OtpScreen> {
  int resendTime = 60;
  late Timer countdownTimer;
  @override
  void initState() {
    startTimer();
    super.initState();
  }

  startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        resendTime--;
      });
      if (resendTime < 1) {
        countdownTimer.cancel();
      }
    });
  }

  @override
  void dispose() {
    countdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final otpBloc = context.read<OtpBloc>();
    final signupbloc = context.read<SignupBloc>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: kbackgroundColor,
        appBar: AppBar(
          backgroundColor: kbackgroundColor,
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<OtpBloc, OtpState>(
              listener: (context, state) {
                if (state is OtpVarifySuccessfulState) {
                  customRoutePushAndRemovieUntil(context, const LoginScreen());
                } else if (state is OtpVarifyInvalidPasswordState) {
                  customSnackBar(context, 'Invalid OTP', Colors.red);
                } else if (state is OtpVarifyServerErrorState) {
                  customSnackBar(context,
                      'Something wrong please try after sometime', Colors.red);
                }
              },
            ),
            BlocListener<SignupBloc, SignupState>(
              listener: (context, state) {
                if (state is SignupSuccessfulState) {
                  customSnackBar(context, 'OTP Send succesfully', Colors.teal);
                  resendTime = 60;
                  startTimer();
                }
              },
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Verification code',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                kheight20,
                const Text(
                  'We have send the code varification to',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500, color: kGrey),
                ),
                kheight10,
                Text(
                  widget.user.email.isNotEmpty
                      ? widget.user.email
                      : 'Email not available',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500, color: kBlack),
                ),
                kheight40,
                OtpTextField(
                  enabledBorderColor: const Color.fromARGB(255, 173, 173, 173),
                  focusedBorderColor: kBlack, 
                  fieldWidth: 50,
                  numberOfFields: 4,
                  showFieldAsBox: true,
                  onCodeChanged: (String code) {},
                  onSubmit: (String verificationCode) {
                    enteredOtp = verificationCode;
                  },
                ),
                kheight20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Haven't received OTP yet?",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    kWidth10,
                    resendTime == 0
                        ? InkWell(
                            onTap: () {
                              signupbloc
                                  .add(UserSignupEvent(user: widget.user));
                            },
                            child: const Text(
                              "Resend",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        : Text(
                            '$resendTime sec',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 254, 36, 21)),
                          )
                  ],
                ),
                kheight40,
                BlocBuilder<OtpBloc, OtpState>(
                  builder: (context, state) {
                    return state is OtpVarifyLoadingState
                        ? loadingElevatedButton(context)
                        : customElevatedButton(context,
                            backgroundColor: kBlack,
                            textColor: kWhite,
                            title: 'Verify', onpressed: () {
                            debugPrint(enteredOtp);
                            if (enteredOtp.length == 4) {
                              otpBloc.add(OtpVerifyEvent(
                                  email: widget.user.email, otp: enteredOtp));
                            } else if (enteredOtp.isNotEmpty) {
                              customSnackBar(context, 'Enter your 4 digit OTP',
                                  Colors.red);
                            } else {
                              customSnackBar(
                                  context, 'No OTP entered', Colors.red);
                            }
                          });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
