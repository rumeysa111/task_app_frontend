part of "auth_cubit.dart"; // Bu dosyanın, auth_cubit.dart'ın bir parçası olduğunu belirtir.

/// Tüm kimlik doğrulama durumlarını temsil eden ana sınıf.
sealed class AuthState {}

/// Uygulama ilk başlatıldığında kullanılacak başlangıç durumu.
final class AuthInitial extends AuthState {}
final class AuthLoading extends AuthState {}
final class AuthSignUp extends AuthState {}
/// Kullanıcı giriş yaptığında yayılan durum.
final class AuthLoggedIn extends AuthState {
  /// Kullanıcı bilgilerini içeren model.
  final UserModel user;

  /// Kullanıcı giriş durumunu oluşturur ve kullanıcı bilgilerini saklar.
  AuthLoggedIn(this.user);
}
final class AuthError extends AuthState {
  final String error;
  AuthError(this.error);

}
