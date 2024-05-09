import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/core/constants.dart';
import 'package:social_media/presentation/blocs/all_followers_posts_bloc/all_followers_posts_bloc.dart';
import 'package:social_media/presentation/blocs/login_bloc/bloc/login_bloc.dart';
import 'package:social_media/presentation/pages/main_page/main_page.dart';
import 'package:social_media/presentation/pages/signup_page/signup_screen.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

final _formkey = GlobalKey<FormState>();
TextEditingController passwordController = TextEditingController();
TextEditingController emailController = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    logoutUser();
    super.initState();
  }

  @override
  void dispose() {
    passwordController.clear();
    emailController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = context.read<LoginBloc>();
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kbackgroundColor,
      ),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccessfulState) {
            context
                .read<AllFollowersPostsBloc>()
                .add(AllFollowersPostsInitialFetchEvent());
            customRoutePushAndRemovieUntil(context, const MainPage());
          } else if (state is LoginLoadingState) {
            const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is LoginUserNotFoundState) {
            customSnackBar(context, 'User Not Found', Colors.red);
          } else if (state is LoginAccountBlockedState) {
            customSnackBar(context, 'Your Account is Blocked', Colors.red);
          } else if (state is LoginInvalidPasswordState) {
            customSnackBar(context, 'Password incorrect', Colors.red);
          } else if (state is LoginServerErrorState) {
            customSnackBar(
                context, 'Something went wrong try after sometime', Colors.red);
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // const Spacer(),
                    kheight20,
                    Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ),
                          kheight20,
                          customTextFormField(
                              context: context,
                              labeltext: 'Email',
                              controller: emailController,
                              fieldEmptyMessage: 'Email is Needed !',
                              validationMessage: 'Enter valid Email',
                              regEx: emailValidator),
                          kheight20,
                          customTextFormField(
                              context: context,
                              labeltext: 'Password',
                              controller: passwordController,
                              fieldEmptyMessage: 'Password is Needed !',
                              validationMessage: 'Enter valid Password',
                              regEx: passwordValidator),
                          kheight40,
                          state is LoginLoadingState
                              ? loadingElevatedButton(context)
                              : customElevatedButton(
                                  context,
                                  backgroundColor: kBlack,
                                  textColor: kWhite,
                                  title: 'Login',
                                  onpressed: () {
                                    final isvalid =
                                        _formkey.currentState?.validate();
                                    if (isvalid!) {
                                      loginBloc.add(
                                        UserLoginEvent(
                                            email: emailController.text,
                                            password: passwordController.text),
                                      );
                                    }
                                  },
                                ),
                        ],
                      ),
                    ),
                    kheight20,
                    authBottomText(context,
                        text1: 'Dont have an Account?  ',
                        text2: 'SignUp', onTap: () {
                      customRoutePushReplacement(context, const SignupScreen());
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
