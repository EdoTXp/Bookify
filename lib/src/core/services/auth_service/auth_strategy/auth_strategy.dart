import 'package:bookify/src/core/models/user_model.dart';

abstract interface class AuthStrategy {
  Future<UserModel> signIn();
  Future<bool> signOut();
}
