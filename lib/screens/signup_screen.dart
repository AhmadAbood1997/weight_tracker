import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/bloc/signup/signup_bloc.dart';
import 'package:weight_tracker/screens/home_screen.dart';
import 'package:weight_tracker/screens/login_screen.dart';
import 'package:weight_tracker/widgets/reusable_button.dart';
import 'package:weight_tracker/widgets/reusable_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    userNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 12, 68, 128).withOpacity(0.5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Center(
          child: Text(
            "Sign Up",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: BlocListener<SignupBloc, SignupState>(
          listener: (context, state) {
            if (state is SignupSucced) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
              context.read<SignupBloc>().add(SignupStart());
            }
          },
          child: BlocBuilder<SignupBloc, SignupState>(
            builder: (context, state) {
              if (state is SignupInitial) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                    child: Column(children: [
                      const SizedBox(
                        height: 20,
                      ),
                      ReuseableTextField(
                          controller: userNameController,
                          icon: Icons.email,
                          isPasswordType: false,
                          text: 'Enter UserName'),
                      const SizedBox(
                        height: 20,
                      ),
                      ReuseableTextField(
                          controller: emailController,
                          icon: Icons.person_outline,
                          isPasswordType: false,
                          text: 'Enter Email ID'),
                      const SizedBox(
                        height: 20,
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
                          isLogin: false,
                          onTap: () {
                            if (emailController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty) {
                              context.read<SignupBloc>().add(
                                  SignUpButtonPressed(
                                      email: emailController.text,
                                      password: passwordController.text));
                            } else {}
                          }),
                      loginOption()
                    ]),
                  )),
                );
              }
              if (state is SignupLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is SignupFailed) {
                return Center(
                    child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ));
              } else {
                return const Center(
                    child: Text(
                  "Something is wrong",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ));
              }
            },
          ),
        ),
      ),
    );
  }

  Row loginOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("You have account?  ",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          },
          child: const Text(
            'Login',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
