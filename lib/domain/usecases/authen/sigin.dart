import 'package:dartz/dartz.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/data/models/authen/signin_user_req.dart';
import 'package:spotify/domain/repository/authen/authen.dart';

import '../../../service_locator.dart';

class SigninUseCase implements UseCase<Either,SigninUserReq> {

  @override
  Future<Either> call({SigninUserReq ? params}) async {
    return sl<AuthenReponsitory>().signin(params!);
  }
}