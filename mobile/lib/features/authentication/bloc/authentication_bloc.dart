import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/repository/repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const AuthenticationState()) {
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationConectivityStatusChanged>(_onConnectivityStatusChanged);
    _authenticationSubcription =
        _authenticationRepository.status.listen((status) {
      add(AuthenticationStatusChanged(status: status));
    });
    _connectivitySubcription =
        ConnectivityHelper.connectivityStatus.listen((status) {
      if (status == ConnectivityResult.ethernet ||
          status == ConnectivityResult.mobile ||
          status == ConnectivityResult.wifi) {
        add(const AuthenticationConectivityStatusChanged(isOffline: true));
      }
    });
  }
  // TODO(dungngminh): handle connectivity to authentication repo
  final AuthenticationRepository _authenticationRepository;

  late final StreamSubscription<AuthenticationStatus>
      _authenticationSubcription;

  late final StreamSubscription<ConnectivityResult> _connectivitySubcription;

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

  void _onConnectivityStatusChanged(
    AuthenticationConectivityStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) {
    emit(
      state.copyWith(isOffline: event.isOffline),
    );
  }

  @override
  Future<void> close() {
    _connectivitySubcription.cancel();
    _authenticationSubcription.cancel();
    _authenticationRepository.dispose();
    return super.close();
  }
}
