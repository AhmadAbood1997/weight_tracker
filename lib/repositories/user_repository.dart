import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/bloc/signup/signup_bloc.dart';

import '../bloc/login/login_bloc.dart';

class UserRepository {
  FirebaseAuth? firebaseAuth = FirebaseAuth.instance;
//
  UserRepository({this.firebaseAuth});

  // Sign Up with email and password

  signUp(String email, String password, Emitter<SignupState> emit) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        emit(const SignupSucced());
        print('True');
      });
    } catch (e) {
      print('False');
      emit(SignupFailed(message: e.toString()));
    }
  }

  // Sign In with email and password

  signIn(String email, String password, Emitter<LoginState> emit) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        emit(LoginSucced());
        print(email);
      });
    } catch (e) {
      print('False');
      emit(LoginFailed(message: e.toString()));
    }
  }

  // Sign Out

  Future<void> signOut() async {
    await firebaseAuth?.signOut();
  }

  // check Sign In
  Future<bool> isSignedIn() async {
    var currentUser = await firebaseAuth?.currentUser;
    return currentUser != null;
  }

  //get current user

  Future<User?> getCurrentUser() async {
    return await firebaseAuth?.currentUser;
  }
}
