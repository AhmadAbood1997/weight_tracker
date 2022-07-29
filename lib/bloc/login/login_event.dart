part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class SignInButtonPressed extends LoginEvent {
  final String email, password;

  const SignInButtonPressed({required this.email, required this.password});
}

class LoginStart extends LoginEvent {}
