import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/bloc/login/login_bloc.dart';
import 'package:weight_tracker/screens/home_screen.dart';
import 'package:weight_tracker/screens/signup_screen.dart';
import 'package:weight_tracker/widgets/reusable_button.dart';
import 'package:weight_tracker/widgets/reusable_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Center(
          child: Text(
            "Sign In",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 12, 68, 128).withOpacity(0.5),
      body: SingleChildScrollView(
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSucced) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
              context.read<LoginBloc>().add(LoginStart());
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              if (state is LoginInitial) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                      child: Column(children: [
                        ReuseableTextField(
                            controller: emailController,
                            icon: Icons.person_outlined,
                            isPasswordType: false,
                            text: 'Enter UserName'),
                        const SizedBox(
                          height: 30,
                        ),
                        ReuseableTextField(
                            controller: passwordController,
                            icon: Icons.lock_outline,
                            isPasswordType: true,
                            text: 'Enter Password'),
                        const SizedBox(
                          height: 20,
                        ),
                        ReuseableButton(
                            context: context,
                            isLogin: true,
                            onTap: () {
                              if (emailController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty) {
                                context.read<LoginBloc>().add(
                                    SignInButtonPressed(
                                        email: emailController.text,
                                        password: passwordController.text));
                              }
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        signUpOption()
                      ]),
                    ),
                  ),
                );
              }
              if (state is LoginLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is LoginFailed) {
                return Center(child: Text(state.message));
              } else {
                return const Center(
                  child: Text(
                    "There is a wrong ",
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?  ",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text(
            'Sign Up',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
