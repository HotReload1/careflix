import 'package:careflix/core/exception/app_exceptions.dart';
import 'package:careflix/layers/data/data_provider/auth_provider.dart' as auth;
import 'package:careflix/layers/data/model/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../generated/l10n.dart';

class AuthRepository {
  auth.AuthProvider _authProvider;

  AuthRepository(this._authProvider);

  Future<Either<AppException, UserCredential>> logIn(
      String email, password) async {
    try {
      final UserCredential user = await _authProvider.logIn(email, password);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(AppException(getMessageFromErrorCode(e.code)));
    }
  }

  Future<Either<AppException, UserCredential>> register(
      String email, password) async {
    try {
      final UserCredential user = await _authProvider.register(email, password);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(AppException(getMessageFromErrorCode(e.code)));
    }
  }

  String getMessageFromErrorCode(String error) {
    switch (error) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return S.current.emailUsed;
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return S.current.wrongEmailPasswordCombination;
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return S.current.noUserFound;
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return S.current.userDisabled;
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return S.current.tooManyRequests;

      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        return S.current.serverError;
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return S.current.invalidEmail;
      default:
        return S.current.theProcessFailed;
    }
  }
}
