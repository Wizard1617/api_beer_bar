import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:api_beer_bar/services/api_service.dart';
import 'package:api_beer_bar/services/service_locator.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final ApiService apiService = getIt<ApiService>();

  RegisterCubit() : super(RegisterInitial());

  Future<void> register({
    required String firstName,
    required String lastName,
    required String middleName,
    required String email,
    required String password,
  }) async {
    emit(RegisterLoading());
    try {
      final success = await apiService.register(
        firstName,
        lastName,
        middleName,
        email,
        password,
      );
      if (success) {
        emit(RegisterSuccess());
      } else {
        emit(RegisterFailure("Ошибка регистрации. Попробуйте снова."));
      }
    } catch (e) {
      emit(RegisterFailure("Ошибка регистрации: ${e.toString()}"));
    }
  }
}
