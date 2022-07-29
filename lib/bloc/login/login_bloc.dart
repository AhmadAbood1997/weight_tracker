import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../repositories/user_repository.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository userRepository;
  LoginBloc({required this.userRepository}) : super(LoginInitial()) {
    on<SignInButtonPressed>(_onLogin);
    on<LoginStart>(_onLoginStart);
  }

  void _onLogin(SignInButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    await userRepository.signIn(event.email, event.password, emit);
  }

  void _onLoginStart(LoginStart event, Emitter<LoginState> emit) {
    emit(LoginInitial());
  }
}
