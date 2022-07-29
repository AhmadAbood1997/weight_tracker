import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../repositories/user_repository.dart';
part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  UserRepository userRepository;
  SignupBloc({required this.userRepository}) : super(SignupInitial()) {
    on<SignUpButtonPressed>(_onSignup);
    on<SignupStart>(_onSignupStart);
  }

  void _onSignup(SignUpButtonPressed event, Emitter<SignupState> emit) async {
    emit(SignupLoading());
    await userRepository.signUp(event.email, event.password, emit);
  }

  void _onSignupStart(SignupStart event, Emitter<SignupState> emit) {
    emit(SignupInitial());
  }
}
