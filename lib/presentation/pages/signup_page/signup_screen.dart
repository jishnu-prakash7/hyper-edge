import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/core/constants.dart';
import 'package:social_media/domain/models/user_model.dart';
import 'package:social_media/presentation/blocs/signup_bloc/bloc/signup_bloc.dart';
import 'package:social_media/presentation/pages/login_page/login_screen.dart';
import 'package:social_media/presentation/pages/otp_page/otp_screen.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

final _formkey = GlobalKey<FormState>();
TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmpaswordController = TextEditingController();

class _SignupScreenState extends State<SignupScreen> {
  @override
  void dispose() {
    emailController.clear();
    nameController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmpaswordController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signupBloc = context.read<SignupBloc>();
    UserModel? user;
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        // title: mainTitle(),
        // centerTitle: true,
        backgroundColor: kbackgroundColor,
      ),
      body: BlocConsumer<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is SignupSuccessfulState) {
            customSnackBar(context, 'OTP Send succesfully', Colors.teal);
            customRoutePushAndRemovieUntil(
                context,
                OtpScreen(
                  user: user!,
                ));
          } else if (state is SignupLoadingState) {
            const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SignupAlreadyAccountState) {
            customSnackBar(context, 'Already have an account', Colors.red);
          } else if (state is SignupServerErrorState) {
            customSnackBar(context,
                'Something wrong please try after sometime', Colors.red);
          } else if (state is SignupAlreadyAccountState) {
            customSnackBar(context,
                "OTP already sent within the last one minute", Colors.red);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // const Spacer(),
                      kheight40,
                      Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'SignUp',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            kheight20,
                            customTextFormField(
                                context: context,
                                labeltext: 'Username',
                                controller: nameController,
                                fieldEmptyMessage: 'Username is needed !',
                                validationMessage:
                                    'Username not shorter than 4 letters',
                                regEx: nameValidator),
                            kheight20,
                            customTextFormField(
                                context: context,
                                labeltext: 'Email',
                                controller: emailController,
                                fieldEmptyMessage: 'Email is needed !',
                                validationMessage: 'Enter a valid Email',
                                regEx: emailValidator),
                            kheight20,
                            customTextFormField(
                                context: context,
                                labeltext: 'Phone No',
                                controller: phoneController,
                                fieldEmptyMessage: 'Phone Number is needed !',
                                validationMessage: 'Must contain 10 Digits',
                                regEx: phoneNumberValidator),
                            kheight20,
                            customTextFormField(
                                context: context,
                                labeltext: 'Password',
                                controller: passwordController,
                                fieldEmptyMessage: 'Password is needed !',
                                validationMessage: 'Enter a Strong Password',
                                regEx: passwordValidator),
                            kheight20,
                            customTextFormField(
                                context: context,
                                labeltext: 'Confirm Password',
                                controller: confirmpaswordController,
                                fieldEmptyMessage: 'Password is Needed !',
                                validationMessage: 'Enter a valid Password',
                                regEx: passwordValidator),
                            kheight40,
                            state is SignupLoadingState
                                ? loadingElevatedButton(context)
                                : customElevatedButton(
                                    context,
                                    backgroundColor: kBlack,
                                    textColor: kWhite,
                                    title: 'Register',
                                    onpressed: () {
                                      if (_formkey.currentState!.validate()) {
                                        if (passwordController.text ==
                                            confirmpaswordController.text) {
                                          UserModel data = UserModel(
                                              email: emailController.text,
                                              userName: nameController.text,
                                              phone: phoneController.text,
                                              password:
                                                  passwordController.text);
                                          user = data;
                                          signupBloc.add(
                                              UserSignupEvent(user: data));
                                        } else {
                                          customSnackBar(
                                              context,
                                              'Confirm password wrong',
                                              Colors.red);
                                        }
                                      }
                                    },
                                  )
                          ],
                        ),
                      ),
                      kheight20,
                      // const Spacer(),
                      authBottomText(context,
                          text1: 'Already have an Account?',
                          text2: 'Login', onTap: () {
                        customRoutePushReplacement(
                            context, const LoginScreen());
                      }),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
    // );
  }
}
