import 'dart:io';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/profile_response.dart';
import '../models/login_response.dart';
import '../models/signup_response.dart';
import '../models/verify_email_response.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient.instance;

  Future<LoginResponse> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      body: {'email': email, 'password': password},
    );

    return LoginResponse.fromJson(response.data);
  }

  Future<SignupResponse> signUp(Map<String, dynamic> data) async {
    final response = await _apiClient.post(ApiEndpoints.signup, body: data);

    return SignupResponse.fromJson(response.data);
  }

  Future<ProfileResponse> getProfile() async {
    final response = await _apiClient.get(ApiEndpoints.profile);

    return ProfileResponse.fromJson(response.data);
  }

  Future<ProfileResponse> updateProfile({
    required String name,
    File? image,
  }) async {
    final fields = <String, dynamic>{};
    final trimmedName = name.trim();

    if (trimmedName.isNotEmpty) {
      fields['name'] = trimmedName;
    }

    final response = await _apiClient.patchMultipart(
      ApiEndpoints.profile,
      fields: fields.isEmpty ? null : fields,
      files: image == null ? null : {'image': image},
    );

    return ProfileResponse.fromJson(response.data);
  }

  Future<VerifyEmailResponse> verifyEmail({
    required String email,
    required int oneTimeCode,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.verifyEmail,
      body: {'email': email, 'oneTimeCode': oneTimeCode},
    );

    return VerifyEmailResponse.fromJson(response.data);
  }

  Future<LoginResponse> refreshToken(String refreshToken) async {
    final response = await _apiClient.post(
      ApiEndpoints.refreshToken,
      body: {'refreshToken': refreshToken},
    );

    return LoginResponse.fromJson(response.data);
  }
}
