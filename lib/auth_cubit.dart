import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:api_beer_bar/services/api_service.dart';
import 'package:api_beer_bar/services/service_locator.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void login(String email, String password) async {

    emit(AuthLoading());
    try {
      final ApiService apiService = getIt<ApiService>();
      final String? token = await apiService.login(email, password);
      if (token != null) {

        emit(AuthSuccess(token));
      } else {
        emit(AuthFailure("Ошибка авторизации"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
