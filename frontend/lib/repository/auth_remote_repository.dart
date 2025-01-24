import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_app/core/constans/constans.dart';
import 'package:task_app/core/services/shared_prefences_services.dart';
import 'package:task_app/models/user_model.dart';
import 'package:task_app/repository/auth_local_repository.dart';

class AuthRemoteRepository {
  final spService = SharedPrefencesServices();
  final authLocalRepository = AuthLocalRepository();
  Future<UserModel> signUp(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final res = await http.post(
        Uri.parse('${Constans.backendUri}/auth/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      ); //deploy ettiğimizde bunu değiştirmemmiz gerekiyor
      if (res.statusCode != 201) {
        throw jsonDecode(res.body)["error"];
      }
      return UserModel.fromMap(jsonDecode(res.body));
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel> login(
      {required String email, required String password}) async {
    try {
      final res = await http.post(
        Uri.parse('${Constans.backendUri}/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ); //deploy ettiğimizde bunu değiştirmemmiz gerekiyor
      if (res.statusCode != 200) {
        throw jsonDecode(res.body)["error"];
      }
      return UserModel.fromMap(jsonDecode(res.body));
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      final token = await spService.getToken();
      if (token == null) {
        return null;
      }
      final res = await http.post(
        Uri.parse('${Constans.backendUri}/auth/tokenIsValid'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      ); //deploy ettiğimizde bunu değiştirmemmiz gerekiyor
      print(res.body);
      if (res.statusCode != 200 || jsonDecode(res.body) == false) {
        // throw jsonDecode(res.body)["error"];
        return null;
      }
      final userResponse = await http.get(
        Uri.parse('${Constans.backendUri}/auth'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );
      print(userResponse.body);
      if (userResponse.statusCode != 200) {
        throw jsonDecode(userResponse.body)['error'];
      }
      return UserModel.fromJson(userResponse.body);
    } catch (e) {
      final user = await authLocalRepository.getUser();
      print(user);

      return user;
    }
  }
}
