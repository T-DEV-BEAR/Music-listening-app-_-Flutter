import 'package:dartz/dartz.dart';
import 'package:spotify/data/models/authen/create_user_req.dart';
import 'package:spotify/data/models/authen/signin_user_req.dart';
import 'package:spotify/data/sources/authen/authen_firebase_service.dart';
import 'package:spotify/domain/repository/authen/authen.dart';

import '../../../service_locator.dart';

class AuthenRepositoryImpl extends AuthenReponsitory {
  @override
  Future<Either> signin(SigninUserReq signinUserReq) async {
     return await sl<AuthenFirebaseService>().signin(signinUserReq);
  }

  @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    return await sl<AuthenFirebaseService>().signup(createUserReq);
  }
  
  @override
  Future<Either> signupGoogle(CreateUserReq createUserReq) async {
    return await sl<AuthenFirebaseService>().signupGoogle(createUserReq);
  }

  @override
  Future<Either> getUser() async {
    return await sl<AuthenFirebaseService>().getUser();
  }
  
  @override
  Future<Either> signupFaceboook(CreateUserReq createUserReq) async{
    return await sl<AuthenFirebaseService>().signupFacebook(createUserReq);
  }
  
}