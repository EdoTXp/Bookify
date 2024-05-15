import 'package:bookify/src/shared/models/user_model.dart';

abstract interface class AuthRepository {
  Future<UserModel?> getUserModel();
  Future<int> setUserModel({required UserModel userModel});
}
