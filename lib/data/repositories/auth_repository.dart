import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/login_response.dart';
import '../models/signup_response.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient.instance;

  Future<LoginResponse> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      body: {
        'email': email,
        'password': password,
      },
    );
    
    return LoginResponse.fromJson(response.data);
  }

  Future<SignupResponse> signUp(Map<String, dynamic> data) async {
    final response = await _apiClient.post(
      ApiEndpoints.signup,
      body: data,
    );

    return SignupResponse.fromJson(response.data);
  }

  Future<LoginResponse> refreshToken(String refreshToken) async {
    final response = await _apiClient.post(
      ApiEndpoints.refreshToken,
      body: {
        'refreshToken': refreshToken,
      },
    );

    return LoginResponse.fromJson(response.data);
  }
}
