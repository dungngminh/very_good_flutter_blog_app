import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const AuthenticationState()) {
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    // on<AuthenticationConectivityStatusChanged>(_onConnectivityStatusChanged);
    _authenticationSubcription =
        _authenticationRepository.status.listen((status) {
      add(AuthenticationStatusChanged(status: status));
    });
  }
  // TODO(dungngminh): handle connectivity to authentication repo
  final AuthenticationRepository _authenticationRepository;

  late final StreamSubscription<AuthenticationStatus>
      _authenticationSubcription;

  void _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) {
    emit(
      AuthenticationState(
        status: event.status,
      ),
    );
  }

  @override
  Future<void> close() {
    _authenticationSubcription.cancel();
    _authenticationRepository.dispose();
    return super.close();
  }
}
