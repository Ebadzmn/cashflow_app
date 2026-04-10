class VerifyEmailResponse {
  final bool success;
  final String message;

  VerifyEmailResponse({required this.success, required this.message});

  factory VerifyEmailResponse.fromJson(Map<String, dynamic> json) {
    return VerifyEmailResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
