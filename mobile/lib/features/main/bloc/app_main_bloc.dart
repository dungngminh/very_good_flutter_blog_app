import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_main_event.dart';
part 'app_main_state.dart';

class AppMainBloc extends Bloc<AppMainEvent, AppMainState> {
  AppMainBloc() : super(AppMainInitial()) {
    on<AppMainEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
