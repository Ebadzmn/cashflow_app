class ProfileResponse {
  final bool success;
  final String message;
  final ProfileData? data;

  ProfileResponse({required this.success, required this.message, this.data});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ProfileData.fromJson(json['data']) : null,
    );
  }
}

class ProfileData {
  final String name;
  final String email;
  final String? contact;
  final String image;
  final String plan;
  final String? expireDate;
  final bool verified;

  ProfileData({
    required this.name,
    required this.email,
    required this.contact,
    required this.image,
    required this.plan,
    required this.expireDate,
    required this.verified,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      contact: json['contact']?.toString(),
      image: json['image'] ?? '',
      plan: json['plan'] ?? '',
      expireDate: json['expireDate']?.toString(),
      verified: json['verified'] ?? false,
    );
  }
}
