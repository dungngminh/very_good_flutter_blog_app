import 'dart:async';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();


  //action
  Stream<AuthenticationStatus> get status async*{
    
  }
}
