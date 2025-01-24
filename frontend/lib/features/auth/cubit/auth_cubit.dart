import 'package:flutter_bloc/flutter_bloc.dart'; // BLoC kütüphanesini projeye dahil ediyor.
import 'package:task_app/core/services/shared_prefences_services.dart';
import 'package:task_app/models/user_model.dart';
import 'package:task_app/repository/auth_local_repository.dart';
import 'package:task_app/repository/auth_remote_repository.dart';
part 'auth_state.dart'; // AuthState durum sınıflarını içeren dosyayı bu Cubit'e bağlıyor.

/// AuthCubit sınıfı, kullanıcı kimlik doğrulama işlemleriyle ilgili durumları yönetir.
class AuthCubit extends Cubit<AuthState> {
  /// AuthCubit, başlangıç durumu olarak `AuthUserInitial` durumunu belirler.
  AuthCubit() : super(AuthInitial());
  final authRemoteRepository = AuthRemoteRepository();
  final spServices = SharedPrefencesServices();
  final authLocalRepository = AuthLocalRepository();

  void getUserData() async {
    try {
      emit(AuthLoading());
      final userModel = await authRemoteRepository.getUserData();
      if (userModel != null) {
        await authLocalRepository.insertUser(userModel);
        emit(AuthLoggedIn(userModel));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }

  void signUp(
      {required String name,
      required String email,
      required String password}) async {
    try {
      emit(AuthLoading());
      await authRemoteRepository.signUp(
        name: name,
        email: email,
        password: password,
      );
      emit(AuthSignUp());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void login({
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      final userModel = await authRemoteRepository.login(
        email: email,
        password: password,
      );
      if (userModel.token.isNotEmpty) {
        await spServices.setToken(userModel.token);
      }
      await authLocalRepository.insertUser(userModel);

      emit(AuthLoggedIn(userModel));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
