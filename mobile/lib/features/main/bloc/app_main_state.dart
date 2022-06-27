part of 'app_main_bloc.dart';

abstract class AppMainState extends Equatable {
  const AppMainState();
  
  @override
  List<Object> get props => [];
}

class AppMainInitial extends AppMainState {}
