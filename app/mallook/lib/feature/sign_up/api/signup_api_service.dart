import 'package:mallook/config/dio_service.dart';
import 'package:mallook/feature/sign_up/model/random_nickname_model.dart';

class SignupApiService {
  static final _dio = DioService();

  static Future<RandomNicknameModel> getRandomNickname() async {
    return await _dio.baseGet<RandomNicknameModel>(
      path: "/api/members/random",
      fromJsonT: (json) => RandomNicknameModel.fromJson(json),
    );
  }

  static Future<String> registerMemberInfo(dynamic data) async {
    return await _dio.basePost(
      path: "/api/members",
      postData: data,
    );
  }
}
