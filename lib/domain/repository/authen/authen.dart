import 'package:dartz/dartz.dart';
import 'package:spotify/data/models/authen/create_user_req.dart';
import 'package:spotify/data/models/authen/signin_user_req.dart';

abstract class AuthenReponsitory{
  Future<Either> signup(CreateUserReq createUserReq);
  Future<Either> signin(SigninUserReq signinUserReq);
  Future<Either> signupGoogle(CreateUserReq createUserReq);
  Future<Either> signupFaceboook(CreateUserReq createUserReq);
  Future<Either> getUser();
}