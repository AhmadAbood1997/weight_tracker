part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignUpButtonPressed extends SignupEvent {
  final String email, password;
  const SignUpButtonPressed({required this.email, required this.password});
}

class SignupStart extends SignupEvent {}
